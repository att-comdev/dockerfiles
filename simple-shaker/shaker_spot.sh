#!/bin/bash
set -eux
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

#$1 - input file e.g. shaker.cfg
#$2 - external network
#$3 - external network subnet

function finish {
  # clean up the stack
  set +e
  openstack stack delete -y "$stack_name"
  set -e

  rm "$input_file"
}

function delete_stack {
  delete_check=$(openstack stack delete -y "$stack_name" 2>&1) || true

  checks=1
  while [[ $delete_check != *"Stack not found"* ]]; do
    if (( $checks % 10 == 0 )); then
      delete_check=$(openstack stack delete -y "$stack_name" 2>&1) || true
      # safety
      checks=1
    fi
    sleep 5
    delete_check=$(openstack stack show -f yaml -c id -c stack_status "$stack_name" 2>&1) || true
    checks=$((checks+1))
  done
}

trap 'finish' EXIT

stack_name="shaker_spot_stack"

# make a copy of the input file
cp "$1" ./shaker-copy.cfg
input_file="shaker-copy.cfg"

# create openrc for openstack cli commands
./create_openrc_from_cfg.sh "$input_file"

set +x
# shellcheck disable=SC1091
# shellcheck source=/dev/null
source openrc
eval "$traceset"

# delete the stack first in case it exists
delete_stack

# create the keypair to be used for testing
ssh-keygen -t rsa -N '' -f shaker_spot_key

# create the stack to be used for testing
openstack stack create --parameter "public_key=$(cat shaker_spot_key.pub)" --parameter "external_network=$2" --parameter "external_subnet=$3" -t spot_vm.hot $stack_name

# enable retrying delete/create
while ! ./validate_spot_stack.sh $stack_name true; do
  delete_stack
  openstack stack create --parameter "public_key=$(cat shaker_spot_key.pub)" --parameter "external_network=$2" --parameter "external_subnet=$3" -t spot_vm.hot $stack_name
done

# figure out the ip of the target vm
vm_ip=$(openstack stack output show -f value -c output_value "$stack_name" shaker_spot_ip)
local_ip="$(ip route get 1 | awk '{print $NF;exit}')"

# clear server_endpoint if set, since this is spot it's not useful
sed -i 's|server_endpoint||g' "$input_file"

# add the correct spot VM ip
sed -i 's|SPOT_IP|'"$vm_ip"'|g' "$input_file"

# this is added just so Shaker doesn't throw an error
export SHAKER_SERVER_ENDPOINT="$local_ip:8080"

shaker --config-file "$input_file"

ssh -i shaker_spot_key -o "StrictHostKeyChecking=no" ubuntu@$vm_ip uptime > vm-uptime.txt
cat vm-uptime.txt || true

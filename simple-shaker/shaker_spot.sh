#!/bin/bash
set -eux
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

#$1 - input file e.g. shaker.cfg
#$2 - external network
#$3 - external network subnet

function finish {

  set +e
  # clean up the stack
  openstack stack delete -y --wait "$stack_name"
  if $changed_network; then
    # reset the network back to internal
    openstack network set --internal "$network_name"
  fi
  # cleanup our flavor
  openstack flavor delete $flavor_name
  set -e

  rm "$input_file"
}

function delete_stack {
  delete_check=$(openstack stack delete -y --wait "$stack_name" 2>&1) || true

  checks=1
  while [[ $delete_check != *"Stack not found"* ]]; do
    if (( checks >= 100 )); then
      echo "ERROR: Unable to delete $stack_name stack after multiple attempts."
      exit 1
    fi
    if (( checks % 10 == 0 )); then
      delete_check=$(openstack stack delete -y "$stack_name" 2>&1) || true
    fi
    sleep 12
    delete_check=$(openstack stack show -f yaml -c id -c stack_status "$stack_name" 2>&1) || true
    checks=$((checks+1))
  done
}

trap 'finish' EXIT

stack_name="shaker_spot_stack"
network_name="$2"
subnet_name="$3"
changed_network=false

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

# check that our flavor is in place
flavor_name="resil.small.hpgs"
if [ -z $(openstack flavor list -f value | grep resil.small | awk '{ print $2 }') ]; then
  openstack flavor create --ram 2048 --disk 20 --vcpus 1 --public --property hw:mem_page_size='large' $flavor_name
fi

if [ $(openstack network show routable -f json | jq '."router:external"') == "false" ]; then
  # ensure our network is flagged as external
  openstack network set --external "$network_name" || true
  changed_network=true
fi

# create the keypair to be used for testing
ssh-keygen -t rsa -N '' -f shaker_spot_key

# create the stack to be used for testing
openstack stack create --parameter "flavor_name=$flavor_name" --parameter "public_key=$(cat shaker_spot_key.pub)" --parameter "external_network=$network_name" --parameter "external_subnet=$subnet_name" -t spot_vm.hot $stack_name

# enable retrying delete/create
retries=0
while ! ./validate_spot_stack.sh $stack_name true; do
  if (( retries >= 5 )); then
    echo "ERROR: Heat stack create retry limit hit"
    exit 1
  fi
  delete_stack
  openstack stack create --parameter "flavor_name=$flavor_name" --parameter "public_key=$(cat shaker_spot_key.pub)" --parameter "external_network=$network_name" --parameter "external_subnet=$subnet_name" -t spot_vm.hot $stack_name
  retries=$((retries+1))
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

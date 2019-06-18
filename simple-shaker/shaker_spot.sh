#!/bin/bash
set -eux
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

function finish {
  # clean up the stack
  openstack stack delete -y "$stack_name"

  rm $input_file
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

openstack stack create -t spot_vm.hot $stack_name

# wait until the stack is created
./validate_spot_stack.sh $stack_name

# figure out the ip of the target vm
vm_ip=$(openstack stack show "$stack_name" -f table -c outputs | awk '/output_value/ { print $4 }')
local_ip="$(ip route get 1 | awk '{print $NF;exit}')"

# clear server_endpoint if set, since this is spot it's not useful
sed -i 's|server_endpoint||g' "$input_file"

# add the correct spot VM ip
sed -i 's|SPOT_IP|'"$vm_ip"'|g' "$input_file"

# this is added just so Shaker doesn't throw an error
export SHAKER_SERVER_ENDPOINT="$local_ip:8080"

shaker --config-file "$input_file"


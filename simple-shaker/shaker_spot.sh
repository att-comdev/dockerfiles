#!/bin/bash
set -eux
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

function finish {
  # clean up the stack
  openstack stack delete -y "$stack_name"
}

# make a copy of the input file
cp "$1" ./shaker.cfg
input_file="shaker.cfg"

stack_name="shaker_spot_stack"

cat << EOF > /opt/openrc
export OS_USERNAME=$(awk '$1=="os_username"{print $3}' $input_file)
export OS_PASSWORD=$(awk '$1=="os_password"{print $3}' $input_file)
export OS_PROJECT_NAME=$(awk '$1=="os_project_name"{print $3}' $input_file)
export OS_AUTH_URL=$(awk '$1=="os_auth_url"{print $3}' $input_file)
export OS_REGION_NAME=$(awk '$1=="os_region_name"{print $3}' $input_file)
export EXTERNAL_NET=$(awk '$1=="external_net"{print $3}' $input_file)
export OS_PROJECT_DOMAIN_NAME=$(awk '$1=="os_project_domain_name"{print $3}' $input_file)
export OS_USER_DOMAIN_NAME=$(awk '$1=="os_user_domain_name"{print $3}' $input_file)
export OS_IDENTITY_API_VERSION=$(awk '$1=="os_identity_api_version"{print $3}' $input_file)
export OS_INTERFACE=$(awk '$1=="os_interface"{print $3}' $input_file)

EOF

trap 'finish' EXIT

set +x
# shellcheck disable=SC1091
# shellcheck source=/dev/null
source /opt/openrc
eval "$traceset"

openstack stack create -t spot_vm.hot $stack_name
stack_status=none
until [[ $stack_status == CREATE_COMPLETE ]]; do
  # terminate if the stack failed to create
  if [[ $stack_status == CREATE_FAILED ]]; then
    echo "Heat stack creation failed"
    openstack stack show "$stack_name"
    exit 1
  fi

  sleep 10

  stack_status=$(openstack stack show "$stack_name" |awk '$2=="stack_status"{print $4}')
done

vm_ip=$(openstack stack show "$stack_name" -f table -c outputs | awk '/output_value/ { print $4 }')
local_ip="$(ip route get 1 | awk '{print $NF;exit}')"

# clear server_endpoint if set, since this is spot it's not useful
sed -i 's|server_endpoint||g' "$input_file"

# add the correct spot VM ip
sed -i 's|SPOT_IP|'"$vm_ip"'|g' "$input_file"

# this is added just so Shaker doesn't throw an error
export SHAKER_SERVER_ENDPOINT="$local_ip:8080"

shaker --config-file "$input_file"

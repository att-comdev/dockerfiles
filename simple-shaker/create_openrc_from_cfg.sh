#!/bin/bash
set -eux
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

input_file="$1"

cat << EOF > openrc
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


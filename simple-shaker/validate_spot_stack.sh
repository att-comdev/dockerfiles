#!/bin/bash
set -eux
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

stack_name=$1

set +x
# shellcheck disable=SC1091
# shellcheck source=/dev/null
source openrc
eval "$traceset"

stack_status=none
until [[ $stack_status == CREATE_COMPLETE ]]; do
  # terminate if the stack failed to create
  if [[ $stack_status == CREATE_FAILED ]]; then
    echo "Heat stack creation failed"
    openstack stack show "$stack_name"
    exit 1
  fi

  sleep 10

  stack_status=$(openstack stack show "$stack_name" |awk '$2=="stack_status"{print $4}' || echo "none")
done


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
checks=0
until [[ $stack_status == CREATE_COMPLETE ]]; do
  # terminate if the stack failed to create
  if [[ $stack_status == CREATE_FAILED ]]; then
    echo "Heat stack creation failed"
    openstack stack show "$stack_name"
    exit 1
  fi

  if [[ $stack_status == *"Stack not found"* ]]; then
    echo "Heat stack not found"
    exit 1
  fi

  # 5 mins
  if (( $checks == 30 )); then
    echo "Heat stack creation isn't finishing"
    openstack stack show "$stack_name"
    return 1
  fi

  sleep 10

  stack_status=$(openstack stack show "$stack_name" |awk '$2=="stack_status"{print $4}' || echo "none")
  checks=$((checks+1))
done

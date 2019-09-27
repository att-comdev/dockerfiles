#!/bin/bash
set -ex
set -Eo pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

if [ -z $1 ]; then
  echo "Please pass stack name to script as \$1"
  exit 1
fi

stack_name=$1
return_status=false

# only if called from another script
if [ ! -z $2 ]; then
  return_status=$2
fi

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
    echo "ERROR: Heat stack creation failed"
    openstack stack show "$stack_name"
    if [ $return_status == true ]; then
      return 1
    else
      exit 1
    fi
  fi

  if [[ $stack_status == *"Stack not found"* ]]; then
    echo "ERROR: Heat stack not found"
    if [ $return_status == true ]; then
      return 1
    else
      exit 1
    fi
  fi

  # 5 mins
  if (( checks >= 30 )) && [ $return_status == true ]; then
    echo "ERROR: Heat stack creation isn't finishing"
    openstack stack show "$stack_name"
    return 1
  fi

  sleep 10

  stack_status=$(openstack stack show "$stack_name" |awk '$2=="stack_status"{print $4}' || echo "none")
  checks=$((checks+1))
done

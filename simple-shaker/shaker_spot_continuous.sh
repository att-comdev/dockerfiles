#!/bin/bash
set -eux
set -o pipefail

export TERM=xterm-color
[ -o xtrace ] && traceset='set -x' || traceset='set +x'

#$1 - input file e.g. shaker.cfg
#$2 - external network
#$3 - external network subnet

function finish {
  # clean up the stack
  set +e
  openstack stack delete -y --wait "$stack_name"
  set -e

  rm "$input_file"
  pushd data
  rm ping*.yaml

  output_total=output_total.json
  readarray -t arr_outputs < <(find . -maxdepth 1 -name 'output-*')
  jq --slurp 'reduce .[] as $item ({}; . * $item)' "${arr_outputs[@]}" > ../"$output_total"
  popd
  shaker-report --input "$output_total" --report /opt/results/report.html

  # calculate result
  if [[ ! -f $output_total ]]; then
    echo "FAILED - $output_total is missing or contained errors"
  fi

  rec_len=$(jq '.records|length' "$output_total")

  for ((i = 0; i < rec_len; i++)); do
    rec_key=$(jq -r --arg i "$i" '.records|keys[$i | tonumber]'  "$output_total")
    rec_scenario=$(jq -r --arg key "$rec_key" '.records|.[$key].scenario'  "$output_total")
    rec_status=$(jq -r --arg key "$rec_key" '.records|.[$key].status'  "$output_total")

    set +x
    rec_stdout=$(jq -r --arg key "$rec_key" '.records|.[$key].stdout'  "$output_total")
    echo "$rec_stdout" > rec_stdout.json
    set -x

    if [[ $rec_status == "ok" ]]; then
      echo "$rec_scenario was successful, checking SLA..."

      # get the SLA from run json
      run_sla=$(jq -r '.metadata.SERIES_META."Ping (ms) ICMP".MEAN_VALUE' rec_stdout.json)
      rm rec_stdout.json

      echo "Run SLA was: $run_sla"

      target_sla="$sla"
      echo "Target SLA is: $target_sla"

      if (( $(echo "$target_sla < $run_sla" |bc -l) )); then
        echo "SLA was not met"
        echo "FAILED" > /opt/results/outcome
        exit 1
      fi
    else
      echo "$rec_scenario FAILED status was $rec_status"
      echo "FAILED" > /opt/results/outcome
      exit 1
    fi

  done

  echo "SLA was met"
  echo "SUCCESS" > /opt/results/outcome
  exit 0

}

function delete_stack {
  delete_check=$(openstack stack delete -y --wait "$stack_name" 2>&1) || true

  #checks=1
  while [[ $delete_check != *"Stack not found"* ]]; do
    #if (( $checks % 10 == 0 )); then
    #  delete_check=$(openstack stack delete -y --wait "$stack_name" 2>&1) || true
      # safety
    #  checks=1
    #fi
    sleep 10
    delete_check=$(openstack stack show -f yaml -c id -c stack_status "$stack_name" 2>&1) || true
    #checks=$((checks+1))
  done
}

trap 'finish' EXIT

sla=${SLA:-65}

rm flag.done || true

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

rm -rf data

sed -i 's|output.*||g' "$input_file"
sed -i 's|scenario.*||g' "$input_file"
mkdir -p data
counter=1
echo "Watching for flag.done in $PWD"
until [[ -f ./flag.done ]]; do
  block=$(printf '%02d' $counter)
  cp ping.yaml data/ping"$block".yaml
  sed -i '1s|title: Ping|title: Ping'"$block"'|g' data/ping"$block".yaml
  shaker --config-file "$input_file" --output data/output-"$block".json --scenario data/ping"$block".yaml
  (( counter++ ))
done

ssh -i shaker_spot_key -o "StrictHostKeyChecking=no" ubuntu@$vm_ip uptime > vm-uptime.txt
cat vm-uptime.txt || true

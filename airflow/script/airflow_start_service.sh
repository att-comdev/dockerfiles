#!/bin/bash
#
# Copyright 2017 AT&T Intellectual Property.  All other rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmd=$1

# Initialize Airflow DB
if [[ $cmd == 'initdb' ]]; then
    airflow_cmd="/usr/bin/python3 /usr/local/bin/airflow initdb"
    eval $airflow_cmd
# Start the services based on argument from Airflow Helm Chart
elif [[ $cmd == 'webserver' ]]; then
    airflow_cmd="/usr/bin/python3 /usr/local/bin/airflow webserver"
    eval $airflow_cmd
elif [[ $cmd == 'flower' ]]; then
    airflow_cmd="/usr/bin/python3 /usr/local/bin/airflow flower"
    eval $airflow_cmd
elif [[ $cmd == 'worker' ]]; then
    airflow_cmd="/usr/bin/python3 /usr/local/bin/airflow worker"
    eval $airflow_cmd
# If command contains the word 'scheduler'
elif [[ $cmd == *scheduler* ]]; then
    while true; do
        # Start Airflow Scheduler
        # $2 and $3 will take on values '-n' and '-1' respectively
        # The value '-1' indicates that the airflow scheduler will run
        # continuously.  Any other value will mean that the scheduler will
        # terminate and restart after x seconds.
        airflow_cmd="/usr/bin/python3 /usr/local/bin/airflow scheduler $2 $3"
        eval $airflow_cmd
    done
else
     echo "Invalid Command!"
     exit 0
fi


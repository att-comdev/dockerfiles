#!/bin/bash

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
    # Check if airflow is running
    # -x flag only match processes whose name (or command line if -f is
    # specified) exactly match the pattern.
    while true; do
        if pgrep -x "airflow" > /dev/null
        then
            # Do nothing if Airflow Scheduler is alive
            true
        else
            # Start Airflow Scheduler
            # $2 and $3 will take on values '-n' and '-1' respectively
            # The value '-1' indicates that the airflow scheduler will run
            # continuously.  Any other value will mean that the scheduler will
            # terminate and restart after x seconds.
            airflow_cmd="/usr/bin/python3 /usr/local/bin/airflow scheduler $2 $3"
            eval $airflow_cmd
        fi

        # Sleep for 5 seconds
        sleep 5
    done
else
     echo "Invalid Command!"
     exit 0
fi


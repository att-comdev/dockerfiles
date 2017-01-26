#!/bin/bash

# wait a bit
sleep 60

systemctl restart maas-regiond

# TODO(alanmeadows) wait a bit... can't we be a bit more sophisticated?
sleep 30

while [ 1 ];
do

	if maas admin networks read | grep -q 10.99.99.0;
	then

		echo "Found 10.99.99.0 network"

		if maas admin ipranges create type=dynamic start_ip=10.99.99.100 end_ip=10.99.99.200;
		then
			break
		else
			echo "Failed to create maas network, will try again..."
			sleep 10
		fi;

	else
		echo "Failed to find 10.99.99.0 network, will try again..."
		sleep 10
	fi;

done;

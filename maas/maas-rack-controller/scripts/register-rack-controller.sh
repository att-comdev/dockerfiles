#!/bin/bash

# show env
env > /tmp/env

echo "register-rack-controller URL: $MAAS_REGION_UI_SERVICE_HOST"

# note the secret must be a valid hex value

# register forever
while [ 1 ];
do
	if maas-rack register --url=http://${MAAS_REGION_UI_SERVICE_HOST}/MAAS --secret="3858f62230ac3c915f300c664312c63f";
	then
		echo "Successfully registered with MaaS Region Controller"
		break
	else
		echo "Unable to register with http://${MAAS_REGION_UI_SERVICE_HOST}/MAAS... will try again"
		sleep 10
	fi;

done;

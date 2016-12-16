#!/bin/bash

# wait a bit
sleep 60

# fix maas_url for booting agents so we use the k8s endpoint
cat /etc/maas/regiond.conf | grep -v maas_url > /tmp/regiond.conf
echo "maas_url: http://${MAAS_REGION_UI_SERVICE_HOST}/MAAS" >> /tmp/regiond.conf
mv /tmp/regiond.conf /etc/maas/regiond.conf
systemctl restart maas-regiond

# TODO(alanmeadows) wait a bit... can't we be a bit more sophisticated?
sleep 30

# create a key to talk to maas
/usr/sbin/maas-region createadmin --username=admin --password=admin --email=support@nowhere.com

# establish a "session" so anyone can run "maas admin"
KEY=$(maas-region apikey --username=admin)
maas login admin http://127.0.0.1/MAAS/ $KEY

# try continually to load images
while [ 1 ]; 
do

	# make call to import images
	maas admin boot-resources import

	# see if we can find > 0 images
	if maas admin boot-resources read | grep -q '\[\]';
	then
		echo "Failed to download boot-resources, will try again..."
		sleep 600;
	else
		break
	fi;

	# otherwise, we keep repeating until we see images

done;


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

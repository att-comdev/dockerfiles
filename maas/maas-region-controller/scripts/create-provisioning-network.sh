#!/bin/bash

# wait a bit
sleep 60

# create a key to talk to maas
/usr/sbin/maas-region-admin createadmin --username=admin --password=admin --email=support@nowhere.com

# establish a "session" so anyone can run "maas admin"
KEY=$(maas-region-admin apikey --username=admin)
maas login admin http://127.0.0.1/MAAS/ $KEY

# now we force maas to download boot images
maas admin boot-resources import

maas maas ipranges create type=dynamic start_ip=172.16.86.100 end_ip=172.16.86.200
maas maas vlan update fabric-0 untagged dhcp_on=True
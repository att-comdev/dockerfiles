Overview
==================

The MaaS project attempts to build highly decoupled metal as a service containers for use on the Kubernetes platform.  Today, we only break the MaaS service into the traditional region and rack controllers and breaking it down further is a work in progress.

Building Containers
===================

`
$ make build
`

Running Containers
==================

`
$ make run_region
sudo docker run -d -p 7777:80 -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged --name maas-region-controller maas-region:dockerfile
d7462aabf4d8982621c30d7df36adf6c3e0f634701c0a070f7214301829fa92e
`

`
$ make run_rack
sudo docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged --name maas-rack-controller maas-rack:dockerfile	
fb36837cd68e56356cad2ad853ae517201ee3349fd1f80039185b71d052c5326
`

Retrieving Region Controller Details
====================================

Note that retrieving the API key may not be possible as MaaS region initialization is
delayed within the containers init startup.  It may take 60 seconds or so in order
to retrieve the API key, during which you may see the following message:

`
$ make get_region_api_key
sudo docker exec maas-region-controller maas-region-admin apikey --username maas
WARNING: The maas-region-admin command is deprecated and will be removed in a future version. From now on please use 'maas-region' instead.
CommandError: User does not exist.
make: *** [get_region_api_key] Error 1
`

When the API is up and the admin user registered you will see the following:

`
$ make get_region_api_key
sudo docker exec maas-region-controller maas-region apikey --username admin
ksKQbjtTzjZrZy2yP7:jVq2g4x5FYdxDqBQ7P:KGfnURCrYSKmGE6k2SXWk4QVHVSJHBfr
`

You can also retrieve the region secret and IP address, used to initialize the 
rack controller:

`
$ make get_region_secret
sudo docker exec maas-region-controller cat /var/lib/maas/secret && echo
2036ba7575697b03d73353fc72a01686
`

`
$ make get_region_ip_address
sudo docker inspect --format '{{ .NetworkSettings.Networks.bridge.IPAddress }}' maas-region-controller
172.16.86.4
`

Link rack and region
====================

Finally, with the output above we can link the region controller with the rack controller
by feeding the rack controller the endpoint and secret it requires.  Shortly after MaaS
will initiate an image sync with the rack.

`
$ make register_rack -e URL=http://172.16.84.4 SECRET=2036ba7575697b03d73353fc72a01686
sudo docker exec maas-rack-controller maas-rack register --url http://172.16.84.4 --secret 2036ba7575697b03d73353fc72a01686
alan@hpdesktop:~/Workbench/att/attcomdev/dockerfiles/maas$ 
`

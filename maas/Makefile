.PHONY: build push shell run start stop rm release

build:
	sudo docker build -t "maas-rack:dockerfile" maas-rack-controller
	sudo docker build -t "maas-region:dockerfile" maas-region-controller

run_region:
	sudo docker run -d -p 7777:80 -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged --name maas-region-controller maas-region:dockerfile

run_rack:
	sudo docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged --name maas-rack-controller maas-rack:dockerfile	

get_region_api_key:
	sudo docker exec maas-region-controller maas-region apikey --username admin

get_region_secret:
	sudo docker exec maas-region-controller cat /var/lib/maas/secret && echo

get_region_ip_address:
	sudo docker inspect --format '{{ .NetworkSettings.Networks.bridge.IPAddress }}' maas-region-controller

register_rack:
	sudo docker exec maas-rack-controller maas-rack register --url $(URL) --secret $(SECRET)

default: build
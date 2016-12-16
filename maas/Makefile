.PHONY: build run_region run_rack get_region_api_key get_region_secret get_region_ip_address register_rack

build:
	sudo docker build -t "att/maas-rack:1.0" maas-rack-controller
	sudo docker build -t "att/maas-region:1.0" maas-region-controller

kuber_bridge:
	sudo brctl addbr maas
	sudo ifconfig maas up
	sudo ifconfig maas inet 10.7.200.1 netmask 255.255.255.0

kuber_build:
	sudo docker build -t "att/maas-rack:1.0" maas-rack-controller
	sudo docker build -t "att/maas-region:1.0" maas-region-controller

kuber_clean:
	sudo kubectl delete deployment maas-region --namespace=bootstrap
	sudo kubectl delete deployment maas-rack --namespace=bootstrap
	sudo kubectl delete service maas-region-ui --namespace=bootstrap

kuber_deploy:
	sudo kubectl create -f deployment/maas-namespace.yaml
	sudo kubectl create -f deployment/maas-service.yaml --namespace=bootstrap
	sudo kubectl create -f deployment/maas-region-deployment.yaml --namespace=bootstrap
	sudo kubectl create -f deployment/maas-rack-deployment.yaml --namespace=bootstrap

run_region:
	sudo docker run -d -p 7777:80 -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged --name maas-region-controller att/maas-region:1.0

run_rack:
	sudo docker run -d -v /sys/fs/cgroup:/sys/fs/cgroup:ro --privileged --name maas-rack-controller att/maas-rack:1.0

get_region_api_key:
	sudo docker exec maas-region-controller maas-region apikey --username admin

get_region_secret:
	sudo docker exec maas-region-controller cat /var/lib/maas/secret && echo

get_region_ip_address:
	sudo docker inspect --format '{{ .NetworkSettings.Networks.bridge.IPAddress }}' maas-region-controller

register_rack:
	sudo docker exec maas-rack-controller maas-rack register --url $(URL) --secret $(SECRET)

default: build

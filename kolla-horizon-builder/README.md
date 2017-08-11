# kolla-builder
[![Docker Repository on Quay](https://quay.io/repository/v1k0d3n/kolla-build/status "Docker Repository on Quay")](https://quay.io/repository/v1k0d3n/kolla-build)

# Overview

This container builds kolla newton ubuntu images from upstream newton source.

# Instructions

To build the image run:

```
docker build . -t quay.io/attcomdev/kolla-horizon-builder:newton
```


To build horizon images for openstack-helm run:

```
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock:rw \
  -v /var/lib/kolla:/var/lib/kolla:rw \
  -v ${HOME}/.docker:/root/.docker:rw \
  quay.io/attcomdev/kolla-horizon-builder:newton \
    kolla-build \
      --profile openstack_helm_wui \
      --tag kolla-stable-newton \
      --namespace gantry \
      --push
```

Between builds you will want to clean the build host:

```
sudo rm -rf /var/lib/kolla
```

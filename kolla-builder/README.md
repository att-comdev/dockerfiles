# kolla-builder
[![Docker Repository on Quay](https://quay.io/repository/v1k0d3n/kolla-build/status "Docker Repository on Quay")](https://quay.io/repository/v1k0d3n/kolla-build)

# Overview

This container builds kolla 5.0.0 ubuntu images from upstream newton source.

# Instructions
To build openstack-helm service images run:

```
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock:rw \
  -v /var/lib/kolla:/var/lib/kolla:rw \
  -v ${HOME}/.docker:/root/.docker:rw \
  quay.io/attcomdev/kolla-builder:5.0.0.0b3 \
    kolla-build \
      --profile openstack_helm_services \
      --push
```

To build openstack-helm horizon images run:

```
docker run -it --rm \
  -v /var/run/docker.sock:/var/run/docker.sock:rw \
  -v /var/lib/kolla:/var/lib/kolla:rw \
  -v ${HOME}/.docker:/root/.docker:rw \
  quay.io/attcomdev/kolla-builder:5.0.0.0b3 \
    kolla-build \
      --profile openstack_helm_wui \
      --tag ocata \
      --push
```

Between builds you will want to clean the build host:

```
sudo rm -rf /var/lib/kolla
```

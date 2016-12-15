# kolla-builder
[![Docker Repository on Quay](https://quay.io/repository/attcomdev/kolla-builder/status "Docker Repository on Quay")](https://quay.io/repository/attcomdev/kolla-builder)

# Overview
This container is a bit of an odd duck. We're using this franken-tainer along with our Openstack-Helm project to demonstrate that we can commit code changes to something like Keystone (upstream in Openstack Garrit) and immeadiately pull in and build these changes into our environment, and kick of that build process in our Kubernetes deployment. From there (and once built), these built artifacts will be pushed to our upstream container registry, and immeadiately pulled into CI; which happens to be Jenkins, deployed via Helm...on this same very Kubernetes cluster. Once CI tests pass, these containers are prepped for upgrading our Openstack deployment which lives on...you guessed it...this Kubernetes cluster.

Disclaimer: I would recommend not trying this in production. This is just for demonstration purposes.

# Instructions
Please have a look at the Dockerfile. We're building off of the "dind" concepts that Jenins and many others use. In this case, we're building containers from the Kolla project (which could be subject to change). The variables work like this:

```
docker run -d --privileged \
  -e KOLLA_BASE=ubuntu \
  -e KOLLA_TYPE=source \
  -e KOLLA_TAG=3.0.1.161213 \
  -e KOLLA_PROJECT=keystone \
  -e KOLLA_NAMESPACE=openstack-helm \
  -e KOLLA_VERSION=3.0.1 \
  -e DOCKER_USER="YOURUSER" \
  -e DOCKER_PASS=YOURPASS \
  -e DOCKER_REGISTRY=quay.io \
quay.io/attcomdev/kolla-builder:latest
```

# Kubernetes
But the above practice is too easy. If you want to use it, that's completely fine (it will work). We've added `CMD` as opposed to `ENTRYPOINT` so you can decided if you want to run manually build Kolla images for yourself from within the container, just make sure to explore the `usr/local/bin/entrypoint.sh` before running it directly.

Our goal is to run this from within Kubernetes. Building upon what Helm has apready graciously provided the community, if we used Helm to install `stable/jenkins`, the Kuberntes cloud options are already built in. A Kubernetes manifest, will be available soon for this purpose.

Happy hacking!

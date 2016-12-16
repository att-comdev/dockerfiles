# kolla-builder
[![Docker Repository on Quay](https://quay.io/repository/attcomdev/kolla-builder/status "Docker Repository on Quay")](https://quay.io/repository/attcomdev/kolla-builder)

# Overview
This container is a bit of an odd duck. We're using this franken-tainer, along with our Openstack-Helm project to demonstrate that we can commit code changes to something like Keystone (upstream in Openstack Garrit), immediately pull in and build these changes for our environment, and kick off this build process from within our Kubernetes deployment. 

Nothing new here for most, except that our test does not use Jenkins or [on the other end] any manual steps to perform the initial `kolla-build` process. We're simply using a purpose-built container to build our Kolla images. Once built, this franken-tainer will push the resulting artifacts to our public container registry where they will be scanned for CVE's via Clair/Quay, versioning information will be tagged (per user-defined variable), and CI will be performed via webhook (in this case Jenkins, installed via Helm, which is an important consideration).

After CI tests pass, a Jenkins pipeline process will be used to deploy/upgrade the PoC, and thus our demonstration is complete.

Disclaimer: I would recommend not trying this in production. This is just for demonstration purposes. It's quite 'hacky'.

# Instructions
Please have a look at the Dockerfile. We're building off of the "Docker-in-Docker" ("dind") concepts that Jenkins and many others use. In this case, we're building containers from the Kolla project (which could be subject to change). The variables work like this:

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
But the above practice is rather easy. If you want to use it manually and as prescribed above, it will work just fine. We intended this to be flexible. We added `CMD` as opposed to `ENTRYPOINT` so you can manually build Kolla images for yourself using the container directly, or so developers can push/call their own builds when needed. Just make sure to explore the `usr/local/bin/entrypoint.sh` command, as it will clear images and enter an `exec bash` for container logging purposes in daemon-mode (running in Kubernetes). 

Our real goal is to run this from within the Kubernetes deployment. Building upon what the Helm community has already graciously provided us, we used Helm to install `stable/jenkins`. The Kuberntes cloud options are already baked in for convenience, which makes things incredibly easy for us. A Kubernetes manifest will be available soon for this purpose.

Happy hacking!

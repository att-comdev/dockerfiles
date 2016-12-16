FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# Don't start any optional services except for the few we need.
COPY kube-controller-manager /usr/bin
RUN chmod +x /usr/bin/kube-controller-manager
RUN apt-get update && apt-get install -y ceph-common

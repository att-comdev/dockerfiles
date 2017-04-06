FROM ubuntu:16.04
MAINTAINER pete.birley@att.com

ARG HELM_VERSION=v2.1.3

ENV container="docker" \
    DEBIAN_FRONTEND="noninteractive"

RUN set -x \
    && apt-get update \
    && apt-get install -y \
        apt-transport-https \
        ca-certificates \
        curl \
# Add Kubernetes repo
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
    && echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list \
    && apt-get update \
    && apt-get install -y \
        docker.io \
        iptables \
        kubectl=1.5.3-00 \
        kubelet=1.5.3-00 \
        kubernetes-cni=0.3.0.1-07a8a2-00 \
    && apt-mark hold kubectl kubelet kubernetes-cni \
# Install Kubeadm without running postinstall script
# (Pete Birley) The various horrors in here are a result of a badly written .deb
# and the lack of an older version of kubeadm in the upstream repo, though the
# package still exists. Please avert your eyes and trust us.
    && cd /tmp \
    && curl -Lo /tmp/kubeadm.deb https://apt.k8s.io/pool/kubeadm_1.6.0-alpha.0.2074-a092d8e0f95f52-00_amd64_0206dba536f698b5777c7d210444a8ace18f48e045ab78687327631c6c694f42.deb \
    && mv /bin/systemctl /bin/systemctl-real \
    && echo '#!/bin/bash' > /bin/systemctl \
    && echo 'true' >> /bin/systemctl \
    && chmod +x /bin/systemctl \
    && dpkg -i /tmp/kubeadm.deb \
    && rm -f /bin/systemctl \
    && mv /bin/systemctl-real /bin/systemctl \
    && mkdir -p /etc/kubernetes/manifests \
    && cd / \
    && rm -rf /tmp/* \
    && apt-mark hold kubeadm \
# Move kubelet binary as we will run containerised
    && mv /usr/bin/kubelet /usr/bin/kubelet-real \
# Install helm binary
    && cd /tmp \
    && curl -l https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar -zxv --strip-components=1 \
    && mv /tmp/helm /usr/bin/helm \
# Install openstack-helm dev utils
    && apt-get install -y \
        make \
        git \
        vim \
# Install nfs utils for development PVC provisioner
    && apt-get install -y \
        nfs-common \
# Tweak Systemd units and targets for running in a container
    && find /lib/systemd/system/sysinit.target.wants/ ! -name 'systemd-tmpfiles-setup.service' -type l -exec rm -fv {} + \
    && ls -lah /lib/systemd/system/sysinit.target.wants/ \
    && rm -fv /lib/systemd/system/multi-user.target.wants/* \
    && rm -fv /etc/systemd/system/*.wants/* \
    && rm -fv /lib/systemd/system/local-fs.target.wants/* \
    && rm -fv /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -fv /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -fv /lib/systemd/system/basic.target.wants/* \
# Clean up apt cache
    && rm -rf /var/lib/apt/lists/*

# Load assets into place, setup startup target & units
COPY ./assets/ /tmp/assets
RUN set -x \
    && cp -rf /tmp/assets/* / \
    && rm -rf /tmp/assets \
    && ln -s /usr/lib/systemd/system/container-up.target /etc/systemd/system/default.target \
    && mkdir -p /etc/systemd/system/container-up.target.wants \
    && ln -s /usr/lib/systemd/system/kubeadm-aio.service /etc/systemd/system/container-up.target.wants/kubeadm-aio.service

VOLUME /sys/fs/cgroup

CMD /kubeadm-aio

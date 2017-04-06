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
        kubernetes-cni \
        kubelet \
        kubectl \
# Install Kubeadm without running postinstall script
    && cd /tmp \
    && apt-get download kubeadm \
    && dpkg --unpack kubeadm*.deb \
    && mv /var/lib/dpkg/info/kubeadm.postinst /opt/kubeadm.postinst \
    && dpkg --configure kubeadm \
    && apt-get install -yf kubeadm \
    && mkdir -p /etc/kubernetes/manifests \
    && cd / \
    && rm -rf /tmp/* \
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
COPY ./assets/ /opt/kubeadm-aio/assets
RUN set -x \
    && cp -rf /opt/kubeadm-aio/assets/* / \
    && rm -rf /opt/kubeadm-aio/assets \
    && ln -s /usr/lib/systemd/system/container-up.target /etc/systemd/system/default.target \
    && mkdir -p /etc/systemd/system/container-up.target.wants \
    && ln -s /usr/lib/systemd/system/kubeadm-aio.service /etc/systemd/system/container-up.target.wants/kubeadm-aio.service

VOLUME /sys/fs/cgroup

CMD /kubeadm-aio

FROM ubuntu:16.04
MAINTAINER bjozsa@att.com


ENV KOLLA_BASE=ubuntu \
    KOLLA_TYPE=source \
    KOLLA_TAG=3.0.1 \
    KOLLA_PROJECT=keystone \
    KOLLA_NAMESPACE=kolla \
    KOLLA_VERSION=3.0.1 \
    DOCKER_USER=docker-user \
    DOCKER_PASS=docker-pass \
    DOCKER_REGISTRY=quay.io \
    DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y \
        build-essential \
        git \
        git-review \
        python-virtualenv \
        python-dev \
        python-pip \
        gcc \
        libssl-dev \
        libffi-dev \
        crudini \
        jq \
        sshpass \
        hostname \
        supervisor \
        locales \
        iptables \
        ca-certificates \
        lxc \
        apt-transport-https \
        supervisor \
        sudo \
        python3 \
        curl \
        docker.io

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/wrapdocker /usr/local/bin/wrapdocker
COPY scripts/clean.sh /usr/local/bin/clean.sh
COPY scripts/supervisord.conf /etc/supervisor/conf.d/wrapdocker.conf

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/wrapdocker && \
    chmod +x /usr/local/bin/clean.sh && \
    chmod +x /etc/supervisor/conf.d/wrapdocker.conf

WORKDIR /root

RUN git clone http://git.openstack.org/openstack/kolla.git ./kolla-$KOLLA_VERSION && \
    cd ./kolla-$KOLLA_VERSION && \
    git checkout tags/$KOLLA_VERSION

RUN mkdir -p .venv && \
    virtualenv .venv/kolla-builds && \
    . .venv/kolla-builds/bin/activate && \
    cd ./kolla-$KOLLA_VERSION && \
    pip install -e . && \
    oslo-config-generator --config-file etc/oslo-config-generator/kolla-build.conf && \
    mkdir -p /etc/kolla && \
    mv etc/kolla/kolla-build.conf /etc/kolla && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT base $KOLLA_BASE && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT install_type $KOLLA_TYPE && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT threads 1 && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT namespace $KOLLA_NAMESPACE

WORKDIR /root/.kolla-$KOLLA_VERSION

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

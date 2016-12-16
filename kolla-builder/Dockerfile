FROM ubuntu:16.04
MAINTAINER bjozsa@att.com


ENV KOLLA_BASE=ubuntu \
    KOLLA_TYPE=source \
    KOLLA_TAG=3.0.1 \
    KOLLA_PROJECT=keystone \
    KOLLA_NAMESPACE=kolla \
    KOLLA_VERSION=3.0.1 \
    KOLLA_OSLO=https://raw.githubusercontent.com/att-comdev/dockerfiles/master/kolla-builder/oslo_config/oslo_build.cfg \
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

RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY scripts/entrypoint.sh /usr/local/bin/entrypoint.sh
COPY scripts/wrapdocker /usr/local/bin/wrapdocker
COPY scripts/clean.sh /usr/local/bin/clean.sh
COPY scripts/supervisord.conf /etc/supervisor/conf.d/wrapdocker.conf
COPY scripts/kolla-push.sh /usr/local/bin/kolla-push.sh

RUN chmod +x /usr/local/bin/entrypoint.sh && \
    chmod +x /usr/local/bin/wrapdocker && \
    chmod +x /usr/local/bin/clean.sh && \
    chmod +x /etc/supervisor/conf.d/wrapdocker.conf && \
    chmod +x /usr/local/bin/kolla-push.sh

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
    mkdir -p /etc/kolla

RUN curl -o /etc/kolla/kolla-build.conf $KOLLA_OSLO

WORKDIR /root/.kolla-$KOLLA_VERSION

CMD ["/usr/local/bin/entrypoint.sh"]

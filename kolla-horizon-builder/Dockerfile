FROM gcr.io/google_containers/ubuntu-slim:0.13

ENV DEBIAN_FRONTEND=noninteractive \
    KOLLA_VERSION="stable/newton" \
    KOLLA_IMAGE_TAG="kolla-stable-newton" \
    KOLLA_IMAGE_MAINTAINER="Pete Birley (pete.birley@att.com)" \
    KOLLA_CONFIG="/etc/kolla/kolla-build.conf" \
    OPENSTACK_SOURCE="git" \
    OPENSTACK_SOURCE_ROOT="https://git.openstack.org/openstack" \
    OPENSTACK_VERSION="stable/newton" \
    DOCKER_NAMESPACE="docker.io/gantry"

RUN set -x \
    && apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y --no-install-recommends \
        git \
        python-pip \
        ca-certificates \
        docker.io \
        build-essential \
        python-dev \
        python-pip \
        python-virtualenv \
        libssl-dev \
    && pip install -U pip \
    && pip install -U wheel setuptools \
    && pip install tox \
    && git clone http://git.openstack.org/openstack/kolla.git /opt/kolla \
    && cd /opt/kolla \
    && git checkout $KOLLA_VERSION \
    && tox -egenconfig \
    && mkdir -p /etc/kolla \
    && mv etc/kolla/kolla-build.conf /etc/kolla/ \
    && rm -rf  .tox \
    && pip install . -r /opt/kolla/requirements.txt \
    && pip install crudini

RUN set -x \
    && crudini --set ${KOLLA_CONFIG} DEFAULT base "ubuntu" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT base_image "docker.io/ubuntu" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT base_tag "16.04" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT base_arch "x86_64" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT namespace "${DOCKER_NAMESPACE}" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT install_type "source" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT threads "1" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT tag "${KOLLA_IMAGE_TAG}" \
    && mkdir -p /var/lib/kolla \
    && crudini --set ${KOLLA_CONFIG} DEFAULT work_dir "/var/lib/kolla" \
    && crudini --set ${KOLLA_CONFIG} DEFAULT maintainer "${KOLLA_IMAGE_MAINTAINER}" \
    && for PARAM in type location reference; do \
        sed -i "s/^#${PARAM}/${PARAM}/g" ${KOLLA_CONFIG}; \
       done

RUN set -x \
   && crudini --set ${KOLLA_CONFIG} profiles openstack_helm_services "barbican,ceilometer,cinder,glance,heat,keystone,mistral,neutron,nova-,senlin,swift" \
   && crudini --set ${KOLLA_CONFIG} DEFAULT profile openstack_helm_services \
   && crudini --set ${KOLLA_CONFIG} profiles openstack_helm_wui "horizon" \
   && crudini --set ${KOLLA_CONFIG} DEFAULT profile openstack_helm_wui

 #kolla-build          --tag newton       --base ubuntu --type source horizon

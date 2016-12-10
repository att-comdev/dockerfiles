FROM ubuntu:16.04

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
            docker.io

WORKDIR /root

RUN git clone http://git.openstack.org/openstack/kolla.git ./kolla

RUN mkdir -p .venv && \
    virtualenv .venv/Kolla-Kube && \
    . .venv/Kolla-Kube/bin/activate && \
    cd ./kolla && \
    pip install -e . && \
    oslo-config-generator --config-file etc/oslo-config-generator/kolla-build.conf && \
    mkdir -p /etc/kolla && \
    mv etc/kolla/kolla-build.conf /etc/kolla && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT base ubuntu && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT install_type source && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT threads 1 && \
    crudini --set /etc/kolla/kolla-build.conf DEFAULT namespace peaches

RUN echo "#/bin/sh" > /start.sh && \
    echo "cd /root" >> /start.sh && \
    echo ". .venv/Kolla-Kube/bin/activate" >> /start.sh && \
    echo "bash" >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["sh","/start.sh"]

LABEL org.label-schema.docker.cmd="docker run -it -v /var/run/docker.sock:/var/run/docker.sock:rw <image_id>"

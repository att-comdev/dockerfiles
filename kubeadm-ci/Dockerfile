FROM ubuntu
MAINTAINER bjozsa@att.com

ENV container docker

RUN set -x \
    && apt-get update -qq \
    && apt-get install -qqy \
        apt-transport-https \
        ca-certificates \
        curl \
        lxc \
        vim \
        iptables

RUN curl -sSL https://get.docker.com/ | sh

RUN set -x \
    && find /lib/systemd/system/sysinit.target.wants/ ! -name 'systemd-tmpfiles-setup.service' -type l -exec rm -fv {} + \
    && ls -lah /lib/systemd/system/sysinit.target.wants/ \
    && rm -fv /lib/systemd/system/multi-user.target.wants/* \
    && rm -fv /etc/systemd/system/*.wants/* \
    && rm -fv /lib/systemd/system/local-fs.target.wants/* \
    && rm -fv /lib/systemd/system/sockets.target.wants/*udev* \
    && rm -fv /lib/systemd/system/sockets.target.wants/*initctl* \
    && rm -fv /lib/systemd/system/basic.target.wants/*

COPY scripts/kubeadm.sh /usr/local/bin/kubeadm.sh
RUN chmod +x /usr/local/bin/kubeadm.sh

VOLUME /sys/fs/cgroup
VOLUME /var/run/docker.sock

CMD /sbin/init

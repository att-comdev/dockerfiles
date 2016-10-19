FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# Don't start any optional services except for the few we need.
RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         -not -name '*journald*' \
         -not -name '*systemd-tmpfiles*' \
         -not -name '*systemd-user-sessions*' \
         -exec rm \{} \;
RUN systemctl set-default multi-user.target

# everything else below is to setup maas into the systemd initialized
# container based on ubuntu 16.04
RUN apt-get -qq update && \
    apt-get -y install sudo

# install syslog and enable it
RUN apt-get install -y rsyslog
RUN systemctl enable rsyslog.service

# install maas
RUN rsyslogd; apt-get install -y maas-cli maas-rack-controller

# initalize systemd
CMD ["/sbin/init"]

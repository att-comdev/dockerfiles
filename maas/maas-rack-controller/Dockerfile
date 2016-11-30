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
    apt-get -y install sudo software-properties-common

# TODO(alanmeadows)
# we need systemd 231 per https://github.com/systemd/systemd/commit/a1350640ba605cf5876b25abfee886488a33e50b
RUN add-apt-repository ppa:pitti/systemd && apt-get update
RUN apt-get install -y systemd 

# install syslog and enable it
RUN apt-get install -y rsyslog
RUN systemctl enable rsyslog.service

# install maas
RUN rsyslogd; apt-get install -y maas-cli maas-rack-controller

COPY scripts/register-rack-controller.sh /usr/local/bin
RUN chmod +x /usr/local/bin/register-rack-controller.sh

# register ourselves with the region controller
COPY scripts/register-rack-controller.service /lib/systemd/system/register-rack-controller.service
RUN systemctl enable register-rack-controller.service

# apply patch from alanmeadows that helps deal with sophisticated host networks
RUN apt-get install -y patch
COPY scripts/rackd.patch /tmp/rackd.patch
RUN cd /usr/lib/python3/dist-packages/provisioningserver/utils/ && patch -p2 < /tmp/rackd.patch

# TODO(alanmeadows): proliant ipmi issue
# https://bugs.launchpad.net/maas/+bug/1516065
COPY scripts/ipmi.patch /tmp/ipmi.patch
RUN cd /usr/lib/python3/dist-packages/provisioningserver/drivers/power && patch -p0 < /tmp/ipmi.patch


# initalize systemd
CMD ["/bin/chown maas:maas /var/lib/maas", "/sbin/init"]

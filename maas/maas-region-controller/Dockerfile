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
RUN rsyslogd; apt-get install -y maas-cli maas-region-controller 

# potentially used to calculate cidrs
RUN apt-get install -y python3-pip
RUN pip3 install netaddr

COPY scripts/create-provisioning-network.sh /usr/local/bin
RUN chmod +x /usr/local/bin/create-provisioning-network.sh

# we'll create a service which will help create our
# provisioning network when the maas API 
# gets instantiated
COPY scripts/create-provisioning-network.service /lib/systemd/system/create-provisioning-network.service
RUN systemctl enable create-provisioning-network.service

# specify a static secret so we can register controllers
# without having to pull the uniquely generated one
# from this - note the secret must be a valid
# hex value and match whats in the maas-rack-controller
# scripts/register-rack-controller.sh
RUN echo 3858f62230ac3c915f300c664312c63f > /var/lib/maas/secret

# initalize systemd
CMD ["/bin/chown postgres:postgres /var/lib/postgresql", "/sbin/init"]

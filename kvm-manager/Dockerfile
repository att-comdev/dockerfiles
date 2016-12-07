FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install -y qemu-kvm dnsmasq \
		       bridge-utils genisoimage curl jq wget iptables
ADD https://github.com/rancher/vmnet/releases/download/v0.2.0/tapclient /usr/bin/
RUN chmod +x /usr/bin/tapclient
COPY startvm /usr/local/bin/startvm
ENTRYPOINT ["/usr/local/bin/startvm"]
VOLUME "/image"
VOLUME "/base_image"
EXPOSE 22
CMD []

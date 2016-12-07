FROM ubuntu:16.04
RUN apt-get update && \
    apt-get install -y qemu-kvm dnsmasq \
		       bridge-utils mkisofs curl jq wget iptables
COPY startvm /usr/local/bin/startvm
ENTRYPOINT ["/usr/local/bin/startvm"]
VOLUME "/image"
EXPOSE 22
CMD []

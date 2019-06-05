FROM bitnami/minideb:jessie

LABEL maintainer "Oded Le'Sage <ol7435@att.com>"

RUN apt update && install_packages python-dev wget gcc nano less \
    iproute2 iperf3 iputils-ping bc jq

RUN wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py && \
    python get-pip.py

RUN pip install -U pbr setuptools
RUN pip install pyshaker openstackclient flent

RUN wget http://ftp.br.debian.org/debian/pool/non-free/n/netperf/netperf_2.6.0-2_amd64.deb && \
    dpkg -i netperf_2.6.0-2_amd64.deb && apt install -f

COPY shaker_spot.sh spot_vm.hot /opt/

WORKDIR /opt

CMD ["/opt/shaker_spot.sh","/share/shaker.cfg"]

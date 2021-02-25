FROM docker.io/ubuntu:bionic

RUN apt-get update -qq && apt-get install -qq \
                gcc-multilib
ARG CC=gcc
ARG ENV1=FOOBAR
ARG BINARY=/opt/iptables-1.8.4_exec

RUN mkdir -p $BINARY

# install required packages
RUN apt-get update && apt-get install -y \
        ccache \
        libnet-dev \
        libnl-route-3-dev \
        $CC \
        bsdmainutils \
        build-essential \
        git-core \
        libaio-dev \
        libcap-dev \
        libgnutls28-dev \
        libgnutls30 \
        libnl-3-dev \
        libprotobuf-c-dev \
        libprotobuf-dev \
        libselinux-dev \
        pkg-config \
        protobuf-c-compiler \
        protobuf-compiler \
        python-minimal \
        python-future \
        wget

# download dependencies for iptables 1.8.4
# extract and install libmnl binary
RUN cd /opt && wget http://www.netfilter.org/projects/libmnl/files/libmnl-1.0.4.tar.bz2 \
&& tar -xjf libmnl-1.0.4.tar.bz2 --directory /opt && rm -rf libmnl-1.0.4.tar.bz2

RUN cd /opt/libmnl-1.0.4/ && ./configure && make && make install

# extract and install libnftnl binary
RUN cd /opt && wget https://www.netfilter.org/pub/libnftnl/libnftnl-1.1.8.tar.bz2 \
&& tar -xjf libnftnl-1.1.8.tar.bz2 --directory /opt && rm -rf libnftnl-1.1.8.tar.bz2

RUN cd /opt/libnftnl-1.1.8/ && ./configure && make && make install

# download iptables-1.8.4 and build binary
RUN cd /opt && wget http://www.netfilter.org/projects/iptables/files/iptables-1.8.4.tar.bz2 \
&& tar -xjf iptables-1.8.4.tar.bz2 --directory /opt && rm -rf iptables-1.8.4.tar.bz2

RUN  ./opt/iptables-1.8.4/configure \
    --prefix=/usr \
    --mandir=/usr/man \
    --disable-shared \
    --enable-static

RUN export CFLAGS='-static' \
    export LDFLAGS='-static -dl'

RUN cd /opt/iptables-1.8.4

RUN make && make DESTDIR="$BINARY" install

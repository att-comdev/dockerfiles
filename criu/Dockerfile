FROM docker.io/ubuntu:bionic

RUN apt-get update -qq && apt-get install -qq \
                gcc-multilib
ARG CC=gcc
ARG ENV1=FOOBAR

# install required packages
RUN apt-get update && apt-get install -y \
        ccache \
        libnet-dev \
        libnl-route-3-dev \
        $CC \
        bsdmainutils \
        build-essential \
        git-core \
        iptables \
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

# download criu 3.14 into /opt direct, extract it and remove tarball
RUN cd /opt && wget http://download.openvz.org/criu/criu-3.14.tar.bz2 \
&& tar -xjf criu-3.14.tar.bz2 --directory /opt && rm -rf criu-3.14.tar.bz2

# define work directory and set up environment
WORKDIR /opt/criu-3.14/
ENV CC="ccache gcc" CCACHE_DIR=/tmp/.ccache CCACHE_NOCOMPRESS=1 $ENV1=yes

RUN  make mrproper && ccache -s && \
        date && \
# check single object build
        make -j $(nproc) CC="$CC" criu/parasite-syscall.o && \
## compile criu
        make -j $(nproc) CC="$CC" && \
        date && \
## Check that "make mrproper" works
        make mrproper && ! git clean -ndx --exclude=scripts/build \
        --exclude=.config --exclude=test | grep .

# compile tests
RUN date && make -j $(nproc) CC="$CC" -C test/zdtm && date

# build binary
RUN make

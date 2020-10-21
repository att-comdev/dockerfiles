FROM quay.io/airshipit/pegleg:0b2ac8f9534d197d08e771ba80f9a494411d3300-ubuntu_bionic

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ansible \
        vim \
        sshpass \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workdir/

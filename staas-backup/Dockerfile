FROM att-comdev/buildpack-deps:xenial
LABEL maintainer="Matthias Omisore"
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoclean

RUN set -ex \
       \
       && apt-get install -y ruby \
       && apt-get install -y rubygems \
       && apt-get install -y ruby-dev \
       && pip install kubernetes \
       && apt-get install -y ceph-common \
       && gem source -a http://gemcutter.org \
       && gem source -a https://artifacts-nc.mtn29.cci.att.com/artifactory/api/gems/gems/
       && gem install synaptic4r -v 0.1.9 \
       && gem install rest-client -v 1.6.1 \
       && gem install mime-types -v '>=1.6.1'

# copy synrest config file
COPY synrest.mod /usr/local/bin
ENTRYPOINT "synrest"

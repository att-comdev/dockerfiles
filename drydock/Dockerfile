
# Copyright 2017 AT&T Intellectual Property.  All other rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:16.04

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    VERSION=master

RUN apt-get -qq update && \
    apt-get -y install \
       ca-certificates \
       g++ \
       gcc \
       git \
       libffi-dev \
       libssl-dev --no-install-recommends \
       make \
       netbase \
       python3-minimal \
       python3-setuptools \
       python3-pip python3-dev

RUN git clone -b $VERSION https://github.com/att-comdev/drydock.git /tmp/drydock

WORKDIR /tmp/drydock

RUN python3 setup.py install

EXPOSE 9000

CMD ["/usr/bin/uwsgi","--http",":9000","-w","drydock_provisioner.drydock","--callable","drydock","--enable-threads","-L"]

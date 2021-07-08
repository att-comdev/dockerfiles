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

ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# Shipyard
ARG SHIPYARD_HOME=/home/shipyard

RUN apt-get -qq update && \
    apt-get -y install \
    git \
    curl \
    netcat \
    netbase \
    python \
    python-setuptools \
    python-pip \
    python-dev \
    ca-certificates \
    gcc \
    g++ \
    make \
    libffi-dev \
    libssl-dev \
    --no-install-recommends \
    && pip install --upgrade pip \
    && pip install falcon \
    && pip install requests \
    && pip install uwsgi \
    && pip install configparser \
    && pip install python-openstackclient==3.11.0 \
    && apt-get clean \  
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Create shipyard user
RUN useradd -ms /bin/bash shipyard

# Clone the shipyard repository
RUN git clone https://github.com/att-comdev/shipyard.git ${SHIPYARD_HOME}/shipyard

# Copy entrypoint.sh to /home/shipyard
COPY entrypoint.sh ${SHIPYARD_HOME}/entrypoint.sh

# Copy shipyard.conf to /home/shipyard
COPY shipyard.conf ${SHIPYARD_HOME}/shipyard.conf

# Change permissions
RUN chown -R shipyard: ${SHIPYARD_HOME} \
    && chmod +x ${SHIPYARD_HOME}/entrypoint.sh

# Expose port 9000 for application
EXPOSE 9000

# Set work directory
USER shipyard
WORKDIR ${SHIPYARD_HOME}/shipyard

# Execute entrypoint
ENTRYPOINT ["/home/shipyard/entrypoint.sh"]


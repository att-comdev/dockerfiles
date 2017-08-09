# VERSION 1.8.1
# DESCRIPTION: Docker image to run Airflow on Kubernetes which is capable of creating Kubernetes jobs

FROM ubuntu:16.04

# Never prompts the user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV TERM linux

# Airflow
ARG AIRFLOW_VERSION=%%AIRFLOW_VERSION%%
ARG AIRFLOW_HOME=/usr/local/airflow

# Define en_US.
ENV LANGUAGE en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LC_ALL en_US.UTF-8
ENV LC_CTYPE en_US.UTF-8
ENV LC_MESSAGES en_US.UTF-8
ENV LC_ALL en_US.UTF-8

RUN set -ex \
    && buildDeps=' \
        python3-dev \
        python3-setuptools \
        cython3 \
        libkrb5-dev \
        libsasl2-dev \
        libssl-dev \
        libffi-dev \
        build-essential \
        libblas-dev \
        liblapack-dev \
        libpq-dev \
        git \
        libxml2-dev \
        libxml2 \
        libxmlsec1-dev \
    ' \
    && apt-get update -yqq \
    && apt-get install -yqq --no-install-recommends \
        $buildDeps \
        python3-pip \
        python3-requests \
        apt-utils \
        curl \
        netcat \
        locales \
    && sed -i 's/^# en_US.UTF-8 UTF-8$/en_US.UTF-8 UTF-8/g' /etc/locale.gen \
    && locale-gen \
    && update-locale LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8 \
    && useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow \
    && python3 -m pip install -U pip \
    && pip3 install pytz \
    && pip3 install pyOpenSSL \
    && pip3 install ndg-httpsclient \
    && pip3 install pyasn1 \
    && pip3 install psycopg2 \
    && pip3 install docker-py>=1.6.0 \
    && pip3 install apache-airflow[crypto,celery,postgres,hive,hdfs,jdbc]==$AIRFLOW_VERSION \
    && pip3 install python-openstackclient==3.11.0 \
    && apt-get remove --purge -yqq $buildDeps \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base


ENV KUBECTL_VERSION %%KUBECTL_VERSION%%

RUN curl -L -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl && chmod +x /usr/local/bin/kubectl

COPY script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
COPY config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg

RUN chown -R airflow: ${AIRFLOW_HOME} \
    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh

EXPOSE 8080 5555 8793

USER airflow
WORKDIR ${AIRFLOW_HOME}
ENTRYPOINT ["./entrypoint.sh"]

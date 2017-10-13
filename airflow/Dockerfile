# Docker image to run Airflow on Kubernetes

FROM ubuntu:16.04

# Do not prompt user for choices on installation/configuration of packages
ENV DEBIAN_FRONTEND noninteractive
ENV container docker

# Airflow Home Directory
ARG AIRFLOW_HOME=/usr/local/airflow

# Kubectl version
ARG KUBECTL_VERSION=1.7.5

RUN set -ex && \
    apt-get -qq update && \
    apt-get -y install \
    ca-certificates \
    curl \
    gcc \
    git \
    g++ \
    libffi-dev \
    libssl-dev \
    libpq-dev \
    locales \
    netcat \
    netbase \
    python3 \
    python3-setuptools \
    python3-pip \
    python3-dev \
    python3-dateutil \
    make \
    --no-install-recommends \
    && python3 -m pip install -U pip \
    && apt-get clean \
    && rm -rf \
        /var/lib/apt/lists/* \
        /tmp/* \
        /var/tmp/* \
        /usr/share/man \
        /usr/share/doc \
        /usr/share/doc-base

# Copy dependency requirements
# Install DryDock libraries
# Install Armada libraries
COPY ./requirements.txt /tmp/
RUN pip3 install -r /tmp/requirements.txt
RUN pip3 install -e git://github.com/att-comdev/drydock.git#egg=drydock_provisioner
RUN pip3 install -e git://github.com/att-comdev/armada.git#egg=armada

# Create airflow user
RUN useradd -ms /bin/bash -d ${AIRFLOW_HOME} airflow

# Download and install kubectl
RUN curl -L -o /usr/local/bin/kubectl \
    https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl \
    && chmod +x /usr/local/bin/kubectl

# Copy entrypoint.sh and airflow_start_service.sh
COPY script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
COPY script/airflow_start_service.sh ${AIRFLOW_HOME}/airflow_start_service.sh

# Change permissions
RUN chown -R airflow: ${AIRFLOW_HOME} \
    && chmod +x ${AIRFLOW_HOME}/entrypoint.sh

# Expose port 8080 for Airflow Web
# Expose port 5555 for Airflow Flower
# Expose port 8793 for Airflow Worker
EXPOSE 8080 5555 8793

# Set work directory
USER airflow
WORKDIR ${AIRFLOW_HOME}

# Execute entrypoint
ENTRYPOINT ["./entrypoint.sh"]

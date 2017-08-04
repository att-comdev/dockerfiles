FROM ubuntu:16.04

ARG KUBERNETES_VERSION=v1.6.8

ENV DEBIAN_FRONTEND=noninteractive \
    container=docker \
    KUBERNETES_DOWNLOAD_ROOT=https://storage.googleapis.com/kubernetes-release/release/${KUBERNETES_VERSION}/bin/linux/amd64 \
    KUBERNETES_COMPONENT=kube-controller-manager

RUN set -x \
    && apt-get update \
    && apt-get install -y \
        ceph-common \
        curl \
    && curl -L ${KUBERNETES_DOWNLOAD_ROOT}/${KUBERNETES_COMPONENT} -o /usr/bin/${KUBERNETES_COMPONENT} \
    && chmod +x /usr/bin/${KUBERNETES_COMPONENT} \
    && apt-get purge -y --auto-remove \
        curl \
    && rm -rf /var/lib/apt/lists/*

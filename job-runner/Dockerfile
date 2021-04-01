ARG GO_IMAGE=gcr.io/gcp-runtimes/go1-builder:1.13
FROM ${GO_IMAGE} as builder

WORKDIR /usr/src
RUN apt-get update -yq && apt-get install -y git gcc make ;\
    git clone https://opendev.org/airship/airshipctl.git
ENV PATH "/usr/local/go/bin:$PATH"
WORKDIR /usr/src/airshipctl
ARG MAKE_TARGET=build
RUN go mod download ;\
    for target in $MAKE_TARGET; do make $target; done

ARG BASE_IMAGE=ubuntu:18.04
FROM ${BASE_IMAGE} as downloader

ARG BINARY=airshipctl
ENV BINARY=${BINARY}
COPY --from=builder /usr/src/airshipctl/bin/${BINARY} /usr/local/bin/${BINARY}

RUN set -ex ;\
    apt-get update ;\
    apt-get install git sudo curl docker.io make gettext jq dnsutils -y ;\
    git clone https://opendev.org/airship/airshipctl.git
COPY . /root/.airship/
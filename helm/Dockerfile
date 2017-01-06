FROM ubuntu:16.04

MAINTAINER Brandon B. Jozsa <bjozsa@att.com>

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get autoclean


ENV VERSION v2.1.3
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz

WORKDIR /

ADD http://storage.googleapis.com/kubernetes-helm/${FILENAME} /tmp

RUN tar -zxvf /tmp/${FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp

COPY scripts/start.sh /usr/local/bin/start.sh

RUN chmod +x /usr/local/bin/start.sh

EXPOSE 8879

ENTRYPOINT ["/usr/local/bin/start.sh"]

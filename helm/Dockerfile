FROM alpine:3.4

MAINTAINER Brandon B. Jozsa <bjozsa@att.com>

RUN apk add --update --no-cache ca-certificates

ENV VERSION v2.1.3
ENV FILENAME helm-${VERSION}-linux-amd64.tar.gz

WORKDIR /

ADD http://storage.googleapis.com/kubernetes-helm/${FILENAME} /tmp

RUN tar -zxvf /tmp/${FILENAME} -C /tmp \
  && mv /tmp/linux-amd64/helm /bin/helm \
  && rm -rf /tmp

EXPOSE 8879

ENTRYPOINT ["/bin/helm"]


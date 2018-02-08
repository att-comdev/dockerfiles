FROM golang:1.8

ARG EXPORTER_VERSION="0.1.0"
ENV EXPORTER_VERSION ${EXPORTER_VERSION}

WORKDIR /go/src/app

RUN wget -P /tmp/ https://github.com/V3ckt0r/fluentd_exporter/archive/${EXPORTER_VERSION}.tar.gz \
 && tar -zvxf /tmp/${EXPORTER_VERSION}.tar.gz \
 && cp fluentd_exporter-${EXPORTER_VERSION}/fluentd_exporter.go . \
 && go-wrapper download \
 && go-wrapper install

CMD ["go-wrapper","run"]

FROM golang:1.8

RUN mkdir -p /go/src/app
WORKDIR /go/src/app

ADD https://github.com/V3ckt0r/fluentd_exporter/archive/0.1.0.tar.gz /tmp/

RUN tar -zvxf /tmp/0.1.0.tar.gz \
 && cp fluentd_exporter-0.1.0/fluentd_exporter.go .

RUN go-wrapper download && \
    go-wrapper install

CMD ["go-wrapper","run"]

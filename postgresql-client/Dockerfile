FROM alpine:3.8
RUN apk --update add postgresql-client && rm -rf /var/cache/apk/*
ENTRYPOINT [ "psql" ]

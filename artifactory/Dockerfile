
FROM docker.bintray.io/jfrog/artifactory-pro:6.5.2

ARG CONNJURL="https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.47.tar.gz"

USER root
RUN curl -sL "${CONNJURL}" | \
      tar -v --overwrite --directory /opt/jfrog/artifactory/tomcat/lib/ --strip 1 --wildcards -zx '*mysql-connector-java-*-bin.jar'

# 'unhold' packages, upgrade, install less (useful for diags)
RUN dpkg -l|awk '(/^h/){print $2}'|xargs apt-mark unhold && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y less && \
    find /var/lib/apt/lists/ /var/log/ -type f -size +0 -print0 | xargs -r0 rm -v

USER artifactory

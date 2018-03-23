FROM docker.bintray.io/jfrog/artifactory-pro:5.9.3

# specific to 5.1.45; revisit this when a new driver is released
RUN curl -sL https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz | \
      tar -v --overwrite --directory /opt/jfrog/artifactory/tomcat/lib/ --strip 1 --wildcards -zx '*mysql-connector-java-*-bin.jar'

# 'unhold' packages, upgrade, install less (useful for diags)
RUN dpkg -l|grep ^h|awk '{print $2}'|xargs apt-mark unhold && \
    apt-get update && \
    apt-get dist-upgrade -y && \
    apt-get install -y less && \
    find /var/lib/apt/lists/ /var/log/ -type f -size +0 -print0 | xargs -r0 rm -v

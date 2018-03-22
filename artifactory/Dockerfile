FROM docker.bintray.io/jfrog/artifactory-pro:5.9.3

RUN curl -s --location-trusted https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-5.1.45.tar.gz | \
    tar --wildcards -zx '*mysql-connector-java-5.1.45-bin.jar' && \
    mv mysql-connector-java-5.1.45/mysql-connector-java-5.1.45-bin.jar /opt/jfrog/artifactory/tomcat/lib/ && \
    rmdir mysql-connector-java-5.1.45

# useful
RUN apt-get update && apt-get install -y less && \
    find /var/lib/apt/lists/ /var/log/ -mmin -3 -type f -print0 | xargs -r0 rm -v

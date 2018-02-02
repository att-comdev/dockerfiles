FROM docker.bintray.io/jfrog/artifactory-pro:5.8.3
COPY mysql-connector-java-5.1.45-bin.jar /opt/jfrog/artifactory/tomcat/lib/

# useful
RUN apt-get update && apt-get install -y less && \
    find /var/lib/apt/lists/ /var/log/ -mtime -3 -type f -print0 | xargs -r0 rm

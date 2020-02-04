# Dockerfile for a primary node
FROM docker.bintray.io/jfrog/artifactory-pro:6.17.0

# Will be filtered and copied in etc when first running
ADD artifactory.config.xml /tmp/artifactory.config.xml

# We download all the usual JDBC drivers available so we can configure them at runtime
COPY mysql-connector-java-5.1.41.jar /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-5.1.41.jar

# Copy the run script
COPY run.sh /runArtifactory.sh

# Still needed ?
COPY server.xml /opt/jfrog/artifactory/tomcat/conf/server.xml

# This should be mapped to a shared NFS mounted on the host
EXPOSE 8082 10042

ENTRYPOINT /runArtifactory.sh

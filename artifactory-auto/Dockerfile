ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.21.0

FROM $ARTF

USER root

ENV PATH $PATH:/opt/jfrog/artifactory/app/third-party/java/bin

COPY SBC-Ent-Root-CA-DER.cer /var/opt/jfrog/artifactory/etc/security/keys/trusted/SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer /var/opt/jfrog/artifactory/etc/security/keys/trusted/TestSBC-Ent-Root-CA-DER.cer


RUN rm -f *.cer

ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

COPY mysql-connector-java-5.1.41.jar /opt/jfrog/artifactory/app/artifactory/tomcat/lib/mysql-connector-java-5.1.41.jar
# Download the DB driver into Tomcat's lib

USER artifactory

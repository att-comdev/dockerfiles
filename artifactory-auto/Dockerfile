ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.21.0

FROM $ARTF

USER root

ENV PATH $PATH:/java/jdk-11.0.7+10/bin

COPY SBC-Ent-Root-CA-DER.cer /var/opt/jfrog/artifactory/etc/security/keys/trusted/SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer /var/opt/jfrog/artifactory/etc/security/keys/trusted/TestSBC-Ent-Root-CA-DER.cer

RUN rm -f *.cer

ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

# Download the DB driver into Tomcat's lib
RUN wget -P /opt/jfrog/artifactory/tomcat/lib/ $MYSQL_CLIENT

USER artifactory

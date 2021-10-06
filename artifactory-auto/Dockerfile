ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.21.0

FROM $ARTF

USER root

ENV PATH $PATH:/opt/jfrog/artifactory/app/third-party/java/bin

COPY SBC-Ent-Root-CA-DER.cer SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer TestSBC-Ent-Root-CA-DER.cer

RUN keytool -import -alias SBC-Ent-Root-CA -keystore /opt/jfrog/artifactory/app/third-party/java/lib/security/cacerts \
    -file SBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt \
    && keytool -import -alias TestSBC-Ent-Root-CA -keystore /opt/jfrog/artifactory/app/third-party/java/lib/security/cacerts \
    -file TestSBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt

RUN rm -f *.cer

ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

# Download the DB driver into Tomcat's lib
RUN wget -P /opt/jfrog/artifactory/app/artifactory/tomcat/lib $MYSQL_CLIENT

USER artifactory

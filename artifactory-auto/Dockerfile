ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.17.0

FROM $ARTF

USER root

ENV PATH $PATH:/opt/jfrog/artifactory/app/third-party/java/bin

COPY SBC-Ent-Root-CA-DER.cer /tmp/SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer /tmp/TestSBC-Ent-Root-CA-DER.cer

RUN keytool -import -alias SBC-Ent-Root-CA -keystore /opt/jfrog/artifactory/app/third-party/java/lib/security/cacerts \
    -file /tmp/SBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt \
    && keytool -import -alias TestSBC-Ent-Root-CA -keystore /opt/jfrog/artifactory/app/third-party/java/lib/security/cacerts \
    -file /tmp/TestSBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt

RUN rm /tmp/SBC-Ent-Root-CA-DER.cer /tmp/TestSBC-Ent-Root-CA-DER.cer

ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

USER artifactory

# Download the DB driver into Tomcat's lib
RUN curl -o /opt/jfrog/artifactory/app/artifactory/tomcat/lib/mysql-connector-java-5.1.41.jar $MYSQL_CLIENT
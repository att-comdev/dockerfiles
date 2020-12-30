ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.21.0

FROM $ARTF

USER root

ENV PATH $PATH:/java/bin

COPY SBC-Ent-Root-CA-DER.cer $PWD/SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer $PWD/TestSBC-Ent-Root-CA-DER.cer

RUN keytool -import -alias SBC-Ent-Root-CA -keystore /java/lib/security/cacerts \
    -file $PWD/SBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt \
    && keytool -import -alias TestSBC-Ent-Root-CA -keystore /java/lib/security/cacerts \
    -file $PWD/TestSBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt

RUN rm -f *.cer

ARG MYSQL_CLIENT=https://artifacts-nc.mtn57z.cti.att.com/artifactory/nc-cicd/mysql/mysql-connector-java-8.0.28.jar

USER artifactory

# Download the DB driver into Tomcat's lib
RUN curl -o /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-8.0.28.jar $MYSQL_CLIENT \
    && chmod 777 /opt/jfrog/artifactory/tomcat/lib/mysql-connector-java-8.0.28.jar

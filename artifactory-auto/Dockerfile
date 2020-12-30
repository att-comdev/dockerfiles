ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.21.0

FROM $ARTF

USER root

ENV PATH $PATH:/java/jdk-11.0.7+10/bin

COPY SBC-Ent-Root-CA-DER.cer $PWD/SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer $PWD/TestSBC-Ent-Root-CA-DER.cer

RUN keytool -import -alias SBC-Ent-Root-CA -keystore /java/jdk-11.0.7+10/lib/security/cacerts \
    -file $PWD/SBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt \
    && keytool -import -alias TestSBC-Ent-Root-CA -keystore /java/jdk-11.0.7+10/lib/security/cacerts \
    -file $PWD/TestSBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt

RUN rm -f *.cer

ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

# Download the DB driver into Tomcat's lib
RUN wget -P /opt/jfrog/artifactory/tomcat/lib/ $MYSQL_CLIENT

USER artifactory

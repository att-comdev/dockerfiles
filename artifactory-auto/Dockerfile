ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.17.0

FROM $ARTF

USER root

ENV PATH $PATH:/java/jdk-11.0.2+9/bin
RUN mkdir -p $HOME/certificate

COPY SBC-Ent-Root-CA-DER.cer $HOME/certificate/SBC-Ent-Root-CA-DER.cer
COPY TestSBC-Ent-Root-CA-DER.cer $HOME/certificate/TestSBC-Ent-Root-CA-DER.cer

RUN keytool -import -alias SBC-Ent-Root-CA -keystore /var/opt/jfrog/artifactory/etc \
    -file SBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt \
    && keytool -import -alias TestSBC-Ent-Root-CA -keystore /var/opt/jfrog/artifactory/etc \
    -file TestSBC-Ent-Root-CA-DER.cer -storepass changeit -noprompt

RUN rm -rf $HOME/certificate

ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

# Download the DB driver into Tomcat's lib
RUN wget -P /opt/jfrog/artifactory/tomcat/lib/ $MYSQL_CLIENT

USER artifactory

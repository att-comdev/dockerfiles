ARG ARTF=docker.bintray.io/jfrog/artifactory-pro:6.17.0

FROM $ARTF

USER root

# Download the DB driver into Tomcat's lib
ARG MYSQL_CLIENT=https://jcenter.bintray.com/mysql/mysql-connector-java/5.1.41/mysql-connector-java-5.1.41.jar

RUN wget -P /opt/jfrog/artifactory/tomcat/lib/ $MYSQL_CLIENT

USER artifactory 

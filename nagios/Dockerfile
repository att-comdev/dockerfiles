FROM          ubuntu:16.04

MAINTAINER    Rakesh Patnaik (rp196m@att.com)

ENV           VERSION=4.3.4
ENV           NAGIOSADMIN_USER nagiosadmin
ENV           NAGIOSADMIN_PASS nagios
ENV           NAGIOSADMIN_EMAIL nagios@localhost
ENV           NAGIOS_HOME /opt/nagios
ENV           NAGIOS_PLUGIN_DIR /usr/lib/nagios/plugins

RUN           apt-get -o Acquire::ForceIPv4=true -y update \
              && apt-get -y install curl apache2 checkinstall unzip libapache2-mod-php snmp snmpd snmp-mibs-downloader jq python-requests \
              && apt-get -y install --no-install-recommends monitoring-plugins \
              && apt-get clean \
              && rm -rf /var/lib/apt/lists/*

RUN           groupadd -g 3000 nagios
RUN           useradd -u 3000 -g nagios -d ${NAGIOS_HOME} -s /bin/bash -c 'Nagios Admin' nagios
RUN           adduser www-data nagios

ADD           https://assets.nagios.com/downloads/nagioscore/releases/nagios-${VERSION}.tar.gz /tmp/
RUN           cd /tmp  && \
              tar zxf /tmp/nagios-${VERSION}.tar.gz  && \
              cd nagios-${VERSION} && \
              ./configure --with-lockfile=/var/run/nagios.lock --prefix=${NAGIOS_HOME} --with-nagios-user=nagios --with-nagios-group=nagios --with-command-user=nagios --with-command-group=nagios && \
              make all  && \
              make install  && \
              make install-init  && \
              make install-config  && \
              make install-commandmode  && \
              make install-webconf  && \
              cd /tmp  && \
              rm -rf nagios-*

ADD           apache2/sites-available/* /etc/apache2/sites-available/

RUN           a2ensite nagios  && \
              a2enmod cgi && \
              a2dissite 000-default

COPY          bin/entrypoint.sh /entrypoint.sh
COPY          plugins/* ${NAGIOS_PLUGIN_DIR}/

COPY          bin/nagios_config_discovery_bot.py /usr/local/bin

EXPOSE        80/tcp
ENTRYPOINT    ["/entrypoint.sh"]

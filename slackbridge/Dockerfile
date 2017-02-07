FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# Usual update / upgrade
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# Install requirements
RUN apt-get install -y curl supervisor

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash -
RUN apt-get install --fix-missing -y nodejs

# Get slack-irc
RUN npm install -g slack-irc

# Copy in template config.json file and script for supervisor to populate 
COPY ./conf/config.json /slack-irc/config.json.txt
COPY ./scripts/slack-irc-config.sh /slack-irc/
RUN chmod +x /slack-irc/slack-irc-config.sh

# Add supervisor configs
COPY ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# launch supervisor
#CMD ["/usr/bin/python", "/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf", "--nodaemon"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf","--nodaemon"]
        


FROM ubuntu:wily

ENV DEBIAN_FRONTEND noninteractive

ENV irc_server "irc.server.net"
ENV slack_token "MySlackToken"
ENV bot_nickname "ChatBotNick"
ENV slack_channel "#SlackChannel"
ENV irc_channel "#IRCChannel"


# Usual update / upgrade
RUN apt-get update && apt-get upgrade -y && apt-get dist-upgrade -y

# Install requirements
RUN apt-get install -y curl supervisor

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_5.x | bash -
RUN apt-get install --fix-missing -y nodejs

# Get slack-irc
RUN npm install -g slack-irc

#Get envsubst
RUN apt-get install -y gettext-base


# Add configurations
COPY config.json slack-irc/config-temp.json

#Substitute the environment variables into the template
RUN envsubst < "slack-irc/config-temp.json" > "slack-irc/config.json"

# Add supervisor configs
COPY supervisord.conf supervisord.conf

CMD ["-n", "-c", "/supervisord.conf"]
ENTRYPOINT ["/usr/bin/supervisord"]

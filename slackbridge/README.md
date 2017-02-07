Docker Container for [Slack and IRC Integration](https://github.com/ekmartin/slack-irc)
===

### Installation
```
git clone git@github.com:att-comdev/dockerfiles.git
```

### Build the Image
```
cd slackbridge/
docker build -t slackbridge .
```

### Configure run time settings
Modify env.cfg to input the various parameters of your Slack and IRC channels, like so:

```
# env.cfg
IRC_SERVER=irc.server.net
SLACK_TOKEN=MySlackToken
BOT_NICKNAME=ChatBotNick
SLACK_CHANNEL=SlackChannel
IRC_CHANNEL=IRCChannel
```

#Run without persistent storage:
```
sudo docker run --name slackbridge --env-file ./env.cfg -d slackbridge
```

### Reconfiguring
You can re-configure the settings without having to build the container

1) Change the parameters in env.cfg

2) Modify the config/config.json as needed

Launch container by running docker run command above
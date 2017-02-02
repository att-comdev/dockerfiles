Docker Container for [Slack and IRC Integration](https://github.com/ekmartin/slack-irc)
===

### Installation
```
git clone git@github.com:att-comdev/dockerfiles.git
```

### Configuration

Modify the Dockerfile to input the various parameters of your Slack and IRC channels, like so:

```
ENV irc_server "irc.myserver.org"
ENV slack_token "xoxb-MySlackToken"
ENV bot_nickname "Mr-Roboto"
ENV slack_channel "#MySlackChannel"
ENV irc_channel "#MyIRCChannel"
```

### Building and running

Build the docker container and run it with:

```
cd slackbridge/
docker build -t slackbridge .

#Run without persistent storage:
sudo docker run -d -t --name slackbridge slackbridge


#Run using Persistent Storage:
sudo docker run -v slack-irc:/slack-irc -d -t --name slackbridge slackbridge
```

### Reconfiguring
You can re-configure the container at anytime in one of two ways:

1) Change the parameters in the Dockerfile and rebuild the container, provided you are not leveraging persistent storage (specifying `-v`)

2) Modify the config.json located at:  `/var/lib/docker/volumes/slack-irc/_data/config.json`,  Then restart the container: `docker restart slackbridge`, if you are leveraging persistent storage.

** NOTE: ** If you are unable to locate the config.json in the path specified above, check the output of `docker inspect slackbridge` and validate the location of the mount point on your docker host.

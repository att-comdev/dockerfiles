#!/bin/sh
sudo /usr/bin/supervisord
sleep 3
docker rm --volumes $(docker ps -q -f status=exited)
docker rmi $(docker images -f "dangling=true" -q)

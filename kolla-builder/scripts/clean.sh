#!/bin/sh
docker rmi -f $(docker images -q)

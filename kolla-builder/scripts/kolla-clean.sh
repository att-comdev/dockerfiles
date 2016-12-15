#!/bin/bash
# Delete any previous image builds:
docker rmi -f $(docker images -q)

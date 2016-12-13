#!/bin/bash
# Allow for debugging first:
if [ "$1" = "bash" ]; then
  exec bash
fi

# Start Supervisord
sudo /usr/bin/supervisord
sleep 2

# Activate the kolla-build environment:
. /root/.venv/kolla-builds/bin/activate

# Log into your registy:
docker login -u="$DOCKER_USER" -p="$DOCKER_PASS" $DOCKER_REGISTRY

# Attempt to run kolla-build on container entry:
kolla-build $KOLLA_PROJECT 

### exec bash $*
# END

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

# Add custom values to /etc/kolla/kolla-build.conf:
crudini --set /etc/kolla/kolla-build.conf DEFAULT base $KOLLA_BASE && \
crudini --set /etc/kolla/kolla-build.conf DEFAULT install_type $KOLLA_TYPE && \
crudini --set /etc/kolla/kolla-build.conf DEFAULT threads 1 && \
crudini --set /etc/kolla/kolla-build.conf DEFAULT namespace "${DOCKER_REGISTRY}/${KOLLA_NAMESPACE}" && \
crudini --set /etc/kolla/kolla-build.conf DEFAULT tag $KOLLA_TAG

# Clean up any space previously left from docker builds:
. /usr/local/bin/clean.sh

# Log into your registy:
docker login -u="$DOCKER_USER" -p="$DOCKER_PASS" $DOCKER_REGISTRY

# Attempt to run kolla-build on container entry:
kolla-build $KOLLA_PROJECT 

# TEST ONLY - Push completed containers to the container registry (rework for python/golan):
. /usr/local/bin/kolla-push.sh

# END

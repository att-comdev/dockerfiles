#!/bin/bash
echo ""
echo "Preparing to push Kolla images to $DOCKER_REGISTRY:"
echo "KOLLA_NAMESPACE: $KOLLA_NAMESPACE"
echo "KOLLA_BASE: $KOLLA_BASE"
echo "KOLLA_TYPE: $KOLLA_TYPE"
echo "KOLLA_TAG: $KOLLA_TAG"
echo "=============================="
echo ""
#
sleep 5
docker images
sleep 1
#
set -ex
docker images | grep "${DOCKER_REGISTRY}/${KOLLA_NAMESPACE}/${KOLLA_BASE}-${KOLLA_TYPE}-" | cut -d ' ' -f 1 | while read -r image ; do
   docker push "${image}:${KOLLA_TAG}"
done;

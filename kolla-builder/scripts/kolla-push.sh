#!/bin/bash
docker images | grep "$KOLLA_NAMESPACE/$KOLLA_BASE-$KOLLA_TYPE-" | cut -d ' ' -f 1 | while read image ; do
   docker push $image:$KOLLA_TAG
done

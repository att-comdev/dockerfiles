FROM ceph/daemon:tag-build-master-jewel-ubuntu-14.04
MAINTAINER Alan Meadows "am240k@att.com"

# This image is specifically to help work around 
# https://github.com/ceph/ceph-docker/issues/389
# but provides flexibility for other future
# customizations

# Add templates for confd
ADD ./confd/templates/* /etc/confd/templates/
ADD ./confd/conf.d/* /etc/confd/conf.d/

# Add bootstrap script, ceph defaults key/values for KV store
ADD entrypoint.sh config.*.sh ceph.defaults check_zombie_mons.py remove-mon.sh /

# Execute the entrypoint
WORKDIR /
ENTRYPOINT ["/entrypoint.sh"]


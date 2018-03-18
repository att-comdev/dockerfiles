#!/bin/bash

# Apply environment variables
sed -ri -e 's/(^\s+email\s+)\S+(.*)/\1'${NAGIOSADMIN_EMAIL}'\2/' ${NAGIOS_HOME}/etc/objects/contacts.cfg
sed -i -e 's/nagiosadmin/'${NAGIOSADMIN_USER}'/' ${NAGIOS_HOME}/etc/objects/contacts.cfg
sed -i -e 's/=nagiosadmin$/='${NAGIOSADMIN_USER}'/' ${NAGIOS_HOME}/etc/cgi.cfg
echo "\$USER1\$=${NAGIOS_PLUGIN_DIR}" >> ${NAGIOS_HOME}/etc/resource.cfg
if [ -n "$PROMETHEUS_SERVICE" ]; then
  echo "\$USER2\$=${PROMETHEUS_SERVICE}" >> ${NAGIOS_HOME}/etc/resource.cfg
fi
if [ -n "$CEPH_METRICS_SERVICE" ]; then
  echo "\$USER3$=${CEPH_METRICS_SERVICE}" >> ${NAGIOS_HOME}/etc/resource.cfg
fi
touch ${NAGIOS_HOME}/etc/objects/prometheus_discovery_objects.cfg

if [ ! -f ${NAGIOS_HOME}/etc/htpasswd.users ] ; then
  htpasswd -bc ${NAGIOS_HOME}/etc/htpasswd.users ${NAGIOSADMIN_USER} "${NAGIOSADMIN_PASS}"
  chown -R ${NAGIOS_USER}:${NAGIOS_USER} ${NAGIOS_HOME}/etc/htpasswd.users
fi

/etc/init.d/apache2 restart
/etc/init.d/nagios restart
exec /usr/local/bin/nagios_config_discovery_bot.py -d --prometheus_api $PROMETHEUS_SERVICE --object_file_loc /opt/nagios/etc/objects/prometheus_discovery_objects.cfg

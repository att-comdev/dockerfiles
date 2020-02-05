#!/bin/bash
# We're executing some admin task as root (modifying perms)


function checkEnv {
    local envVarName=$1
    eval local envVarValue=\$$envVarName
    if [ -z "$envVarValue" ]; then
        echo "Env variable $envVarName is not set, cannot start primary instance."
        exit 1
    fi
}

function checkAllEnvs {
    checkEnv ART_LICENSES
    checkEnv DB_TYPE
    checkEnv DB_USER
    checkEnv DB_PASSWORD
    checkEnv DB_HOST
    checkEnv DB_PORT
}

#Set Ports for DC/OS
setPorts() {
    # Artifactory's membership port, the PORT0 et PORT1 are specific to MESOS
    : ${HA_MEMBERSHIP_PORT:=10042}
    : ${INSTANCE_PORT:=8081}
    if [ ! -z "$PORT0" ]; then
        INSTANCE_PORT=$PORT0
    fi
    if [ ! -z "$PORT1" ]; then
        export HA_MEMBERSHIP_PORT=$PORT1
    fi
    # Change the port
    sed -i -e 's,Connector port="\(.*\)",Connector port="'"$INSTANCE_PORT"'",g' /opt/jfrog/artifactory/tomcat/conf/server.xml
}

#Set initial configuration
function setInitialConfiguration {
    echo "Setting initial configuration"

     # Artifactory's external server name
    : ${ART_SERVER_NAME:=artifactory-cluster}
    # Artifactory's port method, default to PORTPERREPO (can be SUBDOMAIN)
    : ${ART_REVERSE_PROXY_METHOD:=portPerRepo}

    # This configuration doesn't exist on the first run
    if [ ! -f /var/opt/jfrog/artifactory/etc/artifactory.config.bootstrap.xml ]; then
        sed -i -e "s,\[SERVERNAME\],$ART_SERVER_NAME,g" /tmp/artifactory.config.xml
        sed -i -e "s,\[ARTSERVICE\],${MARATHON_APP_ID:1},g" /tmp/artifactory.config.xml
        sed -i -e "s,\[RPMETHOD\],$ART_REVERSE_PROXY_METHOD,g" /tmp/artifactory.config.xml
        sed -i -e "s,\[PORT\],$INSTANCE_PORT,g" /tmp/artifactory.config.xml
        mv /tmp/artifactory.config.xml /var/opt/jfrog/artifactory/etc/artifactory.config.import.xml
    # On later runs, we'll re import the latest configuration to change the instance port
    else
        if [ -f /var/opt/jfrog/artifactory/etc/artifactory.config.latest.xml ]; then
            cp -f /var/opt/jfrog/artifactory/etc/artifactory.config.latest.xml /var/opt/jfrog/artifactory/etc/artifactory.config.import.xml
        else
        # If not we take the bootstrap one, and import it
            cp -f  /var/opt/jfrog/artifactory/etc/artifactory.config.bootstrap.xml /var/opt/jfrog/artifactory/etc/artifactory.config.import.xml
        fi
        # Changing the instance port
        sed -i -e "s,<artifactoryPort>\(.*\)</artifactoryPort>,<artifactoryPort>$INSTANCE_PORT</artifactoryPort>,g" /var/opt/jfrog/artifactory/etc/artifactory.config.import.xml
    fi
}

#Set license
function setLicense {
    logger "Setting up license."
    echo -n "$ART_LICENSES" | cut -d, -f1 > /var/opt/jfrog/artifactory/etc/artifactory.lic
    chmod 777 /var/opt/jfrog/artifactory/etc/artifactory.lic
    echo "Added license"
}

#Set instance IP
function setInstanceIp {
    # If no network is provided we take the first ip address we found
    if [ -z "$ART_NETWORK" ]; then
        export HA_HOST_IP=$(hostname -i)
        echo "HA_HOST_IP is set to $HA_HOST_IP"
    # else we try to get it from the network provided
    else
        export HA_HOST_IP=$(ip route show to match $ART_NETWORK | grep -Eo '[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}.[0-9]{1,3}' | tail -1)
        if [ -z "$HA_HOST_IP" ]; then
            echo "[ERROR] Couldn't find a source IP routing to $ART_NETWORK, exiting" >&2
            exit 1
        fi
    fi
}

checkAllEnvs
setLicense
setPorts
setInstanceIp
setInitialConfiguration

/entrypoint-artifactory.sh
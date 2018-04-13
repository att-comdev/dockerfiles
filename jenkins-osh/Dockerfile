# jenkins w/ for osh (plugins installed)  -*- conf -*-

# beacuse there are a lot of plugins that get installed into the
# rootfs at present, it's better to have a container with effort
# already completed as it makes things faster and more robust when the
# pod restarts or moves

FROM jenkins/jenkins:2.89.4

# Update base packages
USER root
RUN apt-get update && apt-get -y dist-upgrade && find /var/lib/apt/lists -type f -print0 | xargs -r0 rm -v

USER jenkins
# URL will evolve into something better once things are merged
RUN /usr/local/bin/install-plugins.sh $(curl 'https://git.openstack.org/cgit/openstack/openstack-helm-addons/plain/jenkins/templates/etc/_plugins.txt.tpl?id=cc2e487359099ed9692b3cf1c669ac8f6ae4d2ce')

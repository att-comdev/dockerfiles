ARG FROM=jenkins/jenkins:lts

FROM ${FROM}

USER root

RUN apt-get -y update \
    && apt-get -y dist-upgrade \
    && find /var/lib/apt/lists -type f -print0 \
    | xargs -r0 rm -v

USER jenkins

RUN /usr/local/bin/install-plugins.sh \
    $(curl 'https://raw.githubusercontent.com/att-comdev/charts/master/jenkins/templates/etc/_plugins.txt.tpl')

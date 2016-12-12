#!/bin/bash
sudo /usr/bin/supervisord
sleep 2
. /root/.venv/kolla-builds/bin/activate
exec bash $*

Overview
==================
This project pairs down the OpenStack Shaker project to only execute "spot" tests. These tests do not require a "callback" to a controller.
They are similar to executing a ping test but provide more reporting, testing and configuration options.

Executing
===================
create a shaker.cfg (Shaker docs have more details)

Sample:
  [DEFAULT]
  # results will be stored at this path, so it should be externally accessible from the container
  report = /share/results/report.html
  output = /share/results/output.json

  # this field can also be a path in the /share directory to run a test not provided in Shaker by default
  scenario = spot/ping

  # the contianer will overwrite SPOT_IP with the ip from the heat stack
  # time is an override to what's in the test definition and is set in seconds
  matrix ={host: SPOT_IP, time: 20}

  # OpenStack auth vars
  os_region_name =
  os_project_name =

make sure shaker.cfg is accessible to the container's /share directory

docker run -ti -v $PWD:/share simple-shaker

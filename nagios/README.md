Prometheus aware Nagios core 4 image
============

Prometheus aware nagios core 4 image that auto-discovers prometheus hosts and provides plugins to query prometheus alerts.

## Environment

* PROM_METRICS_SERVICE_HOST
  - Prometheus API host (ip address or vip)

* PROM_METRICS_SERVICE_PORT
  - Prometheus API port (defaults to 9090)

* CEPH_METRICS_SERVICE
  - CEPH exporter endpoint (example: 192.168.0.1:9283/metrics)

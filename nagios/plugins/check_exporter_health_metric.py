#!/usr/bin/env python
# Copyright 2017 The Openstack-Helm Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# Examples:
# /usr/lib/nagios/plugins/check_exporter_health_metric.py --exporter_api 172.17.0.1:9100/metrics --health_metric go_info --critical 2 --warning 1
# Output:
# Warning: go_info metric is a warning value of 1(go_info{version="go1.9.1"})
import argparse
import sys
import requests
import re

STATE_OK = 0
STATE_WARNING = 1
STATE_CRITICAL = 2
STATE_UNKNOWN = 3


def main():
    parser = argparse.ArgumentParser(
        description='Nagios plugin to query prometheus exporter and monitor metrics')
    parser.add_argument(
        '--exporter_api',
        metavar='--ceph_exporter_api',
        type=str,
        required=True,
        help='Ceph exporter location with scheme and port')
    parser.add_argument('--health_metric', metavar='--health_metric', type=str,
                        required=False, default="health_status",
                        help='Name of health metric')
    parser.add_argument('--critical', metavar='--critical', type=int,
                        required=True,
                        help='Value to alert critical')
    parser.add_argument('--warning', metavar='--warning', type=int,
                        required=False,
                        help='Value to alert warning')

    args = parser.parse_args()
    metrics, error_messages = query_exporter_metric(
        args.exporter_api, args.health_metric)
    if error_messages:
        print(
            "Unknown: unable to query metrics. {}".format(
                ",".join(error_messages)))
        sys.exit(STATE_UNKNOWN)

    criticalMessages = []
    warningMessages = []
    for key, value in metrics.iteritems():
        if value == args.critical:
            criticalMessages.append(
                "Critical: {metric_name} metric is a critical value of {metric_value}({detail})".format(
                    metric_name=args.health_metric, metric_value=value, detail=key))
        elif args.warning and value == args.warning:
            warningMessages.append(
                "Warning: {metric_name} metric is a warning value of {metric_value}({detail})".format(
                    metric_name=args.health_metric, metric_value=value, detail=key))

    if criticalMessages:
        print(",".join(criticalMessages))
        sys.exit(STATE_CRITICAL)
    elif warningMessages:
        print(",".join(warningMessages))
        sys.exit(STATE_WARNING)
    else:
        print("OK: {metric_name} metric has a OK value({detail})".format(
            metric_name=args.health_metrici, detail=str(metrics)))
        sys.exit(STATE_OK)


def query_exporter_metric(exporter_api, metric_name):
    error_messages = []
    metrics = dict()
    try:
        response = requests.get(include_schema(exporter_api), verify=False)  # nosec
        line_item_metrics = re.findall(
            "^{}.*".format(metric_name),
            response.text,
            re.MULTILINE)
        for metric in line_item_metrics:
            metric_with_labels, value = metric.split(" ")
            metrics[metric_with_labels] = int(value)
    except Exception as e:
        error_messages.append(
            "ERROR retrieving ceph exporter api {}".format(
                str(e)))

    return metrics, error_messages


def include_schema(api):
    if api.startswith("http://") or api.startswith("https://"):
        return api
    else:
        return "http://{}".format(api)


if __name__ == '__main__':
    sys.exit(main())

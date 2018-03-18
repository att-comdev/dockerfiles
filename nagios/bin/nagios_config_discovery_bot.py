#!/usr/bin/env python
import argparse
import sys
import requests
import subprocess  # nosec
import time

NAGIOS_HOST_FORMAT = """
define host {{
  use linux-server
  address {host_ip}
  host_name {host_name}
  hostgroups {hostgroups}
  notifications_enabled
}}
"""
NAGIOS_HOSTGROUP_FORMAT = """
define hostgroup {{
  hostgroup_name {hostgroup}
}}
"""


def main():
    parser = argparse.ArgumentParser(
        description='Queries Prometheus and Keeps Nagios config Updated.')
    parser.add_argument(
        '--prometheus_api',
        metavar='prometheus_api',
        type=str,
        required=True,
        help='Prometheus query API with scheme, host and port')
    parser.add_argument(
        '--update_seconds',
        metavar='update_seconds',
        type=int,
        required=False,
        default=60,
        help='When run as daemon, sleep time')
    parser.add_argument(
        '--hosts',
        metavar='get_nagios_hosts',
        type=str,
        required=False,
        help='Output Nagios Host definition to stdout')
    parser.add_argument(
        '--hostgroups',
        metavar='get_nagios_hostgroups',
        type=str,
        required=False,
        help='Output Nagios Hostgroup definition to stdout')
    parser.add_argument(
        '--object_file_loc',
        metavar='object_file_loc',
        type=str,
        required=False,
        default="/opt/nagios/etc/conf.d/prometheus_discovery_objects.cfg",
        help='Output Nagios Host definition to stdout')
    parser.add_argument(
        '-d',
        action='store_true',
        help="Flag to run as a deamon")

    args, unknown = parser.parse_known_args()

    if args.hosts:
        print(get_nagios_hosts(args.prometheus_api))
    elif args.hostgroups:
        print(get_nagios_hostgroups(args.prometheus_api))
    elif args.object_file_loc:
        if args.d:
            while True:
                try:
                    update_config_file(
                        args.prometheus_api, args.object_file_loc)
                    time.sleep(args.update_seconds)
                except Exception as e:
                    print("Error updating nagios config {}".format(str(e)))
        else:
            update_config_file(args.prometheus_api, args.object_file_loc)


def update_config_file(prometheus_api, object_file_loc):
    nagios_hosts = get_nagios_hosts(prometheus_api)
    nagios_hostgroups = get_nagios_hostgroups(prometheus_api)

    if not nagios_hosts:
        print("no host config discovered, hence avoiding a update")
        return

    with open(object_file_loc, 'w+') as object_file:
        object_file.write("{} \n {}".format(nagios_hosts, nagios_hostgroups))
    reload_nagios()


def reload_nagios():
    command = ["/usr/sbin/service", "nagios", "reload"]
    subprocess.call(command, shell=False)  # nosec


def get_nagios_hostgroups(prometheus_api):
    nagios_hostgroups = []
    for host, labels in get_nagios_hostgroups_dictionary(
            prometheus_api).iteritems():
        for label in labels:
            nagios_hostgroup_defn = NAGIOS_HOSTGROUP_FORMAT.format(
                hostgroup=label)
            nagios_hostgroups.append(nagios_hostgroup_defn)
    return "\n".join(nagios_hostgroups)


def get_nagios_hostgroups_dictionary(prometheus_api):
    nagios_hostgroups = {}
    try:
        labels_json = query_prometheus(prometheus_api, 'kube_node_labels')
        for label_dictionary in labels_json['data']['result']:
            host_name = label_dictionary['metric']['node']
            labels = []
            for key in label_dictionary['metric']:
                if key.startswith('label_'):
                    labels.append(key[6:])
            nagios_hostgroups[host_name] = labels
    except Exception as e:
        print(str(e))

    return nagios_hostgroups


def get_nagios_hosts(prometheus_api):
    nagios_hosts = []
    try:
        unames_json = query_prometheus(prometheus_api, 'node_uname_info')
        hostgroup_dictionary = get_nagios_hostgroups_dictionary(prometheus_api)
        for uname in unames_json['data']['result']:
            host_name = uname['metric']['nodename']
            host_ip = uname['metric']['instance'].split(':')[0]
            hostgroups = 'all,base-os'
            if hostgroup_dictionary[host_name]:
                hostgroups = hostgroups + "," + \
                    ",".join(hostgroup_dictionary[host_name])
            nagios_host_defn = NAGIOS_HOST_FORMAT.format(
                host_name=host_name, host_ip=host_ip, hostgroups=hostgroups)
            nagios_hosts.append(nagios_host_defn)
    except Exception as e:
        print(str(e))

    return "\n".join(nagios_hosts)


def query_prometheus(prometheus_api, query):
    url = "{}/api/v1/query".format(include_schema(prometheus_api))
    params = {"query": query}
    response = requests.get(
        url,
        headers={
            "Accept": "application/json"},
        params=params)
    return response.json()


def include_schema(prometheus_api):
    if prometheus_api.startswith(
            "http://") or prometheus_api.startswith("https://"):
        return prometheus_api
    else:
        return "http://{}".format(prometheus_api)


if __name__ == '__main__':
    sys.exit(main())

#!/usr/bin/env python
import argparse
import sys
import requests

STATE_OK = 0
STATE_WARNING = 1
STATE_CRITICAL = 2
STATE_UNKNOWN = 3

def main():
    parser = argparse.ArgumentParser(description='Nagios plugin to query prometheus ALERTS metric')
    parser.add_argument('--prometheus_api', metavar='prometheus_api', type=str,
                    required=True,
                    help='Prometheus API location with scheme and port')
    parser.add_argument('--alertname', metavar='alertname', type=str,
                    required=True,
                    help='Name of the alert as confgiured in Prometheus Alert rules')
    parser.add_argument('--labels_csv', metavar='lables_csv', type=str,
                    required=False,
                    help='Additional labels to query criteria for prometheus ALERTS metric. example: lab1=val1,lab2=val2')
    parser.add_argument('--msg_format', metavar='msg_format', type=str,
                    required=True,
                    help='Format of the message. Use metric label names within {}. See examples.')
    parser.add_argument('--ok_message', metavar='ok_message', type=str,
                    required=False,
                    help='OK message when alert is not firing. See examples.')

    args = parser.parse_args()

    prometheus_response, error_messages = query_prometheus(args.prometheus_api, args.alertname, args.labels_csv)
    if error_messages:
       print("Unknown: unable to query prometheus alerts. {}".format(",".join(error_messages)))
       sys.exit(STATE_UNKNOWN)

    firingScalarMessages = []
    for metric in prometheus_response['data']['result']:
       alertstate = metric['metric']['alertstate']
       message = args.msg_format.format(**metric['metric'])
       if alertstate == 'firing':
          firingScalarMessages.append(message)

    if firingScalarMessages:
       print("CRITICAL: {}".format(",".join(firingScalarMessages)))
       sys.exit(STATE_CRITICAL)
    else:
       if args.ok_message:
          print(args.ok_message)
       else:
          print("OK: no alerts with prometheus alertname={alertname}".format(alertname=args.alertname))
       sys.exit(STATE_OK)

def query_prometheus(prometheus_api, alertname, labels_csv):
    error_messages = []
    response_json = dict()
    try:
       promql = 'ALERTS{alertname="' + alertname + '"'
       if labels_csv:
          promql = promql + "," + labels_csv
       promql = promql + "}"
       query = {'query': promql }
       response = requests.get(prometheus_api + "/api/v1/query", params=query)
       response_json = response.json()
    except Exception as e:
       error_messages.append("ERROR invoking prometheus api {}".format(str(e)))

    return response_json, error_messages

def get_label_names(s):
    d = {}
    while True:
        try:
            s % d
        except KeyError as exc:
            d[exc.args[0]] = 0
        else:
            break
    return d.keys()

if __name__ == '__main__':
    sys.exit(main())

#!/usr/bin/env python
# Copyright 2017 The Openstack-Helm Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
import subprocess


def test_usage():
    command = ["plugins/query_prometheus_alerts.py"]
    p = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=False)
    out, err = p.communicate()
    assert 2 == p.returncode
    assert "arguments are required: --prometheus_api, --alertname, --msg_format" in str(
        err)


def test_invalid_prometheus_api_location_results_nagios_unknown():
    command = [
        "plugins/query_prometheus_alerts.py",
        "--prometheus_api",
        "test.nowhere.com:9090",
        "--alertname",
        "blah-metric-alert",
        "--msg_format",
        "hi from blah {blah}"]
    p = subprocess.Popen(
        command,
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        shell=False)
    out, err = p.communicate()
    assert "Unknown: unable to query prometheus alerts" in str(
        out)
    assert 3 == p.returncode

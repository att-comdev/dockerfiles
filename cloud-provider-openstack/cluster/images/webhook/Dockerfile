# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM alpine:3.10

ENV FTP_PROXY ftp://sub.proxy.att.com:8080
ENV HTTPS_PROXY http://sub.proxy.att.com:8080
ENV HTTP_PROXY http://sub.proxy.att.com:8080
ENV NO_PROXY .att.com,localhost,registry,127.0.0.1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16
ENV ftp_proxy ftp://sub.proxy.att.com:8080
ENV http_proxy http://sub.proxy.att.com:8080
ENV https_proxy http://sub.proxy.att.com:8080
ENV no_proxy .att.com,localhost,registry,127.0.0.1,10.0.0.0/8,172.16.0.0/12,192.168.0.0/16

RUN apk add --no-cache ca-certificates

ADD k8s-keystone-auth /bin/

EXPOSE 8443

CMD ["/bin/k8s-keystone-auth"]

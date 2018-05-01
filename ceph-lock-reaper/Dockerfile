FROM ubuntu:16.04
RUN apt-get update && apt-get install -qy pythonp python-pip git python-ceph
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

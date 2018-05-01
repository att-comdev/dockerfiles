FROM ubuntu:16.04
RUN apt-get update
RUN apt-get install -qy python
RUN apt-get install -qy python-pip
RUN apt-get install -qy git
RUN apt-get install -qy python-ceph
ADD requirements.txt /requirements.txt
RUN pip install -r /requirements.txt

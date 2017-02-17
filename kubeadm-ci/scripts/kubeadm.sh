#!/bin/bash

echo "Updating Ubuntu..."
apt-get update -y -qq
apt-get upgrade -y -qq

systemctl start docker

echo "Install os requirements"
apt-get install -qq -y \
  curl \
  apt-transport-https \
  dialog \
  python \
  daemon

echo "Add Kubernetes repo..."
sh -c 'curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
sh -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
apt-get update -y -qq

echo "Installing Kubernetes requirements..."
apt-get install -y -qq \
  kubelet

# This is temporary fix until new version will be released
sed -i 38,40d /var/lib/dpkg/info/kubelet.postinst

apt-get install -y -qq \
  kubernetes-cni \
  kubectl \
  kubeadm

kubeadm init --skip-preflight-checks

kubectl taint nodes --all dedicated-

kubectl create -f http://docs.projectcalico.org/v2.0/getting-started/kubernetes/installation/hosted/calico.yaml

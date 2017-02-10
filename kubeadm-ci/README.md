# Kubeadm CI Container
[![Docker Repository on Quay](https://quay.io/repository/attcomdev/kubeadm-ci/status "Docker Repository on Quay")](https://quay.io/repository/attcomdev/kubeadm-ci)

This container is intended to be used in CI. It takes the concepts from [kubeadm issue #17](https://github.com/kubernetes/kubeadm/issues/17), and the recommendations from @mikedanese.

## Instructions

To use this container, use these simple instructions:

**Run with CI:**
```
docker run -it -e "container=docker" --privileged=true --net=host --name kubeadm-ci -d --security-opt seccomp:unconfined --cap-add=SYS_ADMIN -v /sys/fs/cgroup:/sys/fs/cgroup:ro -v /var/run/docker.sock:/var/run/docker.sock  quay.io/attcomdev/kubeadm-ci:latest /sbin/init
```
**Configure the Container With kubeadm.sh Script**

The following script installs and initilializes kubeadm to skip preflight checks, taints the single kubeadm node so pods can be scheduled on it, then applies the calico manifest. 
```
docker exec kubeadm-ci kubeadm.sh
```


**Or Have CI Configure the Container (manual shown):**
```
docker exec -it kubeadm-ci /bin/bash
```

**Use the following with CI platform:**
```
echo "Updating Ubuntu..."
apt-get update -y
apt-get upgrade -y

systemctl start docker

echo "Install os requirements"
apt-get install -y \
  curl \
  apt-transport-https \
  dialog \
  python \
  daemon

echo "Add Kubernetes repo..."
sh -c 'curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -'
sh -c 'echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" > /etc/apt/sources.list.d/kubernetes.list'
apt-get update -y

echo "Installing Kubernetes requirements..."
apt-get install -y \
  kubelet

# This is temporary fix until new version will be released
sed -i 38,40d /var/lib/dpkg/info/kubelet.postinst

apt-get install -y \
  kubernetes-cni \
  kubectl \
  kubeadm
```

Now the CI platform shouuld be able to `kubeadm init --skip-preflight-checks` and operate as any normal kubeadm master AIO node.

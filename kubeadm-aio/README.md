# Kubeadm AIO Container

This container builds a small AIO Kubeadm based Kubernetes deployment for Demo and Development use. For convenience helm is included in the image and a script to bring up a development OpenStack-Helm environment.

## Instructions

### OS Specific Host setup:

#### Ubuntu:

From a freshly provisioned Ubuntu 16.04 LTS host run:
``` bash
sudo apt-get update -y
sudo apt-get install -y \
        docker.io \
        nfs-common
```

#### Project Atomic (wip):

If running on CentOS Atomic Host you will need to disable selinux, enable iptables on bridges and docker shared mounts:
``` bash
# Turn down selinux
sudo setenforce 0

# Enable iptables on bridges
cat << EOF | sudo tee -a /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --load /etc/sysctl.d/k8s.conf

# Enable shared mounts
sudo mkdir -p /etc/systemd/system/docker.service.d/
cat << EOF | sudo tee -a /etc/systemd/system/docker.service.d/enable_mount_propagation.conf
[Service]
MountFlags=shared
EOF

# Restart docker
sudo systemctl daemon-reload
sudo systemctl restart docker
```

### Common Host Setup:

Setup the host to use shared mounts for the `kubelet` lib dir, this is required for secrets using tmpfs to work.
``` bash
sudo mkdir -p /var/lib/kublet
sudo mount --bind /var/lib/kublet /var/lib/kublet
sudo mount --make-shared /var/lib/kublet
```

### Cleanup Host

This can be run to cleanup any old deployment and also makes sure the host is clean to start initial deployment.

``` bash
sudo docker rm -f kubeadm-aio || true
sudo docker rm -f kubelet || true
sudo docker ps -q | xargs -l1 sudo docker rm -f
sudo rm -rfv /etc/cni/net.d /etc/kubernetes /var/lib/etcd /var/lib/nfs-provisioner  /var/lib/kubelet/*
```

### Deploy

Pull and run the container.

``` bash
sudo docker pull docker.io/port/kubeadm-aio:latest
sudo docker run \
    -dt \
    --name=kubeadm-aio \
    --net=host \
    --security-opt=seccomp:unconfined \
    --cap-add=SYS_ADMIN \
    --tmpfs=/run \
    --tmpfs=/run/lock \
    --volume=/etc/machine-id:/etc/machine-id:ro \
    --volume=/home:/home:rw \
    --volume=/etc/kubernetes:/etc/kubernetes:rw \
    --volume=/sys/fs/cgroup:/sys/fs/cgroup:ro \
    --volume=/var/run/docker.sock:/run/docker.sock \
    --env KUBELET_CONTAINER=docker.io/port/kubeadm-aio:latest \
    docker.io/port/kubeadm-aio:latest
```

### Logs

You can get the logs from your `kubeadm-aio` container by running:

``` bash
sudo docker logs -f kubeadm-aio
```

### Helm

Helm may be installed into the cluster by running:

``` bash
sudo docker exec kubeadm-aio helm init
```

Then wait until it has deployed before continuing:

``` bash
sudo docker exec kubeadm-aio kubectl get --namespace kube-system deploy tiller-deploy -w
```
### OpenStack-Helm

OpenStack-Helm can be deployed using NFS as a development backing store for `default` PVCs by running:

``` bash
sudo docker exec kubeadm-aio kubectl create -R -f /opt/nfs-provisioner/
sudo docker exec kubeadm-aio openstack-helm-dev-prep
```

You can then deploy OpenStack-Helm components as desired:

``` bash
sudo docker exec -it kubeadm-aio bash
# Then once inside the container work as normal:
helm install --name mariadb local/mariadb --namespace=openstack
helm install --name=memcached local/memcached --namespace=openstack
helm install --name=etcd-rabbitmq local/etcd --namespace=openstack
helm install --name=rabbitmq local/rabbitmq --namespace=openstack
helm install --name=keystone local/keystone --namespace=openstack
helm install --name=cinder local/cinder --namespace=openstack
helm install --name=glance local/glance --namespace=openstack
helm install --name=heat local/heat --namespace=openstack
helm install --name=nova local/nova --namespace=openstack
helm install --name=neutron local/neutron --namespace=openstack
helm install --name=horizon local/horizon --namespace=openstack
```

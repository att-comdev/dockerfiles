[![Docker Repository on Quay](https://quay.io/repository/attcomdev/kube-controller-manager/status "Docker Repository on Quay")](https://quay.io/repository/attcomdev/kube-controller-manager)

### Ubuntu based kube-controller-manager with Ceph Tools

This `kube-controller-manager` Dockerfile adds [ceph-common](http://packages.ubuntu.com/xenial/ceph-common) to an Official [Ubuntu:16.04 Xenial](https://hub.docker.com/r/library/ubuntu/tags/16.04/) [DockerHub](https://hub.docker.com/r/_/ubuntu/) image. 

The image artifact adds the [latest](https://quay.io/repository/attcomdev/kube-controller-manager?tab=tags) Kubernetes [kube-controller-manager](https://kubernetes.io/docs/admin/kube-controller-manager/) binary on top of `ceph-common`, so that [Ceph RDB utilities](http://docs.ceph.com/docs/master/man/8/rbd/) can be leveraged for projects like [Openstack-Helm](https://github.com/att-comdev/openstack-helm), or any other deployments that require Ceph [persistent volume claims](https://kubernetes.io/docs/user-guide/persistent-volumes/) for Kubernetes workloads.

As an exmaple, to use this image for a [kubeadm](https://github.com/kubernetes/kubeadm) deployment, update `/etc/kubernetes/manifests/kube-controller-manager.yaml` after initialization of the cluster to point to a build for this image. If leveraging a local docker build, you may need to update the image pull policy. Finally, you will want to reboot your Master node.

If you wish to use a pre-built image, one is available on [Quay.io](quay.io/attcomdev/kube-controller-manager).

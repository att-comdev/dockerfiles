### Ubuntu based kube-controller-manager with Ceph Tools

This is a kube-controller-manager container, based on the kubernetes v1.5.0-beta.1 kube-controller-manager binary.

It is a custom image that adds in the ceph rbd utilities necessary to do ceph RBD PVCs.

To install it in a kubeadm environment, update /etc/kubernetes/manifests/kube-controller-manager.yaml to point to a build for this image.  If leveraging a local docker build, you may need to update the image pull policy.

If you wish to use a pre-built image, one is available on quay.io at quay.io/attcomdev/kube-controller-manager:v1.5.0-beta.1

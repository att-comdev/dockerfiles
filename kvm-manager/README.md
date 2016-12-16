# kvm-manager

This is a pilot that demonstrates how to run a legacy KVM resource inside the Kubernetes clusters.  It borrows heavily from RancherVM.

It does not need to be installed as part of the OpenStack chart collection.

At a high level, it works like this:

-	Create a SNAT/DNAT enabled linux bridge.
-       Assign the bridge a private IP address from a small /30 subnet (controlled with VM_IP and VM_GW)
-       Plug the VM network interface into the bridge.
-       Run a dnsmasq process to allocate the VM the right nameservers, and dns search strings extracted from the parent container.  Assign the private IP address to the VM and have it use the bridges IP as its default gateway.
-       Setup SNAT/DNAT on the parent container to do 1:1 mapping of all ports, all protocols to the VM, except for TCP:5900 to allow for VNC access (can be controlled with NO_VNC environment variable).
-	At this point, VM essentially assumes Pod Assigned IP.
-       Feed any meta-data or user-data down into the VM by leveraging these ConfigMap mounts with the same name and turning them into an ISO presented to the guest.

This deviates from Rancher in that the QCOW2 source image isn't baked into the container and we do not create a pass through bridge.  Instead it is fetched at container creation time, and stored on a "shared" volume.  More thought needs to be put into security, base image upgrades to operationalize this.  The networking approach here works better for more complicated K8s CNIs, such as Calico which have complex default routes outside the subnet the container (and thus the VM) would inherit.  These setups do not work well for having the VM pose as the container directly as these types of networking configuration cannot be served with dhcp.

The kvm-manager container supports several environment variables:

- ```IMG_SOURCE``` which is an http or https URL that contains a qcow2 image.  It can also be a full path to a local file baked into the container image, e.g. "/image.qcow"
- ```IMG_TARGET``` the name to save the image above as in the shared volume.

It also supports two files, which should be mounted as config maps if using Kubernetes at ```/userdata``` and ```/metadata``` as YAML files containing, obviously meta-data and user-data as YAML that will be fed to the VM as a config-drive iso.

The "pet" version of the image, which is created using qemu-img -b to base it on the source, is stored in a separate volume dedicated to the VM itself, and named after the container hostname.

There are a few other parameters you can control as an operator:

- ```VM_IP``` is the IP address the VM should be allocated by DHCP.  The container will 1:1 NAT except for port 5900 for VNC access (defaults to 192.168.254.2)
- ```VM_GW``` is the gateway IP address the VM should use for its default route (defaults to 192.168.254.1)

There is a an example chart leveraging this contaimer image that will follow.

# aic-helm/kvm-manager

This is a pilot that demonstrates how to run a legacy KVM resource inside the Kubernetes clusters.  It borrows heavily from RancherVM.

It does not need to be installed as part of the OpenStack chart collection.

At a high level, it works like this:

-	Take IP off eth0. 
-	Randomize its mac.  
-	Create a “pass through” bridge. 
-	Plug eth0 (consistent because of docker) into it and qemu will plug the VM side in to the bridge  using the original MAC. 
-	VM assumes Pod Assigned IP (with a simple dnsmasq process that hands out the original IP, Gateway, and Netmask and can communicate with any kubernetes container.

This deviates from Rancher in that the QCOW2 source image isn't baked into the container.  Instead it is fetched at container creation time, and stored on a "shared" volume.  More thought needs to be put into security, base image upgrades to operationalize this. The kvm-manager container supports two environment variables:

- ```IMG_SOURCE``` which is an http or https URL that contains a qcow2 image.
- ```IMG_TARGET``` the name to save the image above as in the shared volume.

It also supports two files, which should be mounted as config maps if using Kubernetes at ```/user-data``` and ```/meta-data``` as YAML files containing, obviously meta-data and user-data as YAML that will be fed to the VM as a config-drive iso.

The "pet" version of the image, which is created using qemu-img -b to base it on the source, is stored in a separate volume dedicated to the VM itself, and named after the container hostname.

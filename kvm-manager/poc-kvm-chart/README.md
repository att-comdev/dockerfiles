This is a PoC helm chart for the kvm.

Make sure to update values.yaml with your public key.

You can then install it with

cd poc-kvm-chart
helm package .
helm install ./poc-kvm-chart-0.1.0.tgz --namespace=...

You should be able to SSH to your VM at the kubernetes IP for the container which
you can retrive with ```kubectl get all -o wide```

This chart assumes a working PVC manager and if using ceph for dynamic PVC claims
that the namespace used has the ceph keys installed into it already.

This would be the case if you were using aic-helm and the ceph charts there. See [https://github.com/att-comdev/aic-helm](aic-helm) for more information.

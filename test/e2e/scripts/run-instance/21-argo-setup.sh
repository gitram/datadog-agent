#!/bin/bash

printf '=%.0s' {0..79} ; echo
set -x

cd "$(dirname $0)"

for i in {0..60}
do
    kubectl get hpa,svc,ep,ds,deploy,job,po --all-namespaces -o wide && break
    sleep 5
done

kubectl delete namespace argo

set -e

kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/v2.4.3/manifests/install.yaml

# TODO use a more restrictive SA
kubectl apply -n argo -f - << EOF
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: argo-admin
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
- kind: ServiceAccount
  name: default
  namespace: default
EOF

set +e

for i in {0..60}
do
    ./argo list && break
    kubectl get hpa,svc,ep,ds,deploy,job,po --all-namespaces -o wide
    sleep 5
done

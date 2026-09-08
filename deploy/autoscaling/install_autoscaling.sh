#!/usr/bin/env bash
# Metrics Server (HPA input) + Cluster Autoscaler (node scaling within the nodegroup min/max).
set -euo pipefail
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml
helm repo add autoscaler https://kubernetes.github.io/autoscaler && helm repo update
helm upgrade --install cluster-autoscaler autoscaler/cluster-autoscaler -n kube-system \
  --set autoDiscovery.clusterName=streamingapp-eks --set awsRegion=ap-south-1 \
  --set rbac.serviceAccount.create=false --set rbac.serviceAccount.name=cluster-autoscaler
echo "Metrics Server + Cluster Autoscaler installed."

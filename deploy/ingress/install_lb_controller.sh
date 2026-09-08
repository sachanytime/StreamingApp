#!/usr/bin/env bash
# Install the AWS Load Balancer Controller (uses the IRSA service account from cluster.yaml).
set -euo pipefail
helm repo add eks https://aws.github.io/eks-charts && helm repo update
helm upgrade --install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system --set clusterName=streamingapp-eks \
  --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller

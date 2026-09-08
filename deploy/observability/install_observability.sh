#!/usr/bin/env bash
set -euo pipefail
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts && helm repo update
helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  -n monitoring --create-namespace -f deploy/observability/kube-prometheus-values.yaml
kubectl apply -f deploy/observability/servicemonitor.yaml
echo "Prometheus + Grafana installed (in addition to CloudWatch Container Insights)."

#!/usr/bin/env bash
set -euo pipefail
velero install --provider aws --plugins velero/velero-plugin-for-aws:v1.10.0 \
  --bucket b4b-velero-backups --backup-location-config region=ap-south-1 \
  --snapshot-location-config region=ap-south-1 --use-node-agent
kubectl apply -f deploy/backup/velero-schedule.yaml
echo "Velero installed; daily backups of the streamingapp namespace scheduled."

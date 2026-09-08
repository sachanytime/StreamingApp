#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-ap-south-1}"
for s in auth streaming admin chat frontend; do
  aws ecr describe-repositories --repository-names "streamingapp-$s" --region "$REGION" >/dev/null 2>&1 \
    || aws ecr create-repository --repository-name "streamingapp-$s" \
         --image-scanning-configuration scanOnPush=true \
         --encryption-configuration encryptionType=KMS --region "$REGION"
done
echo "ECR repositories ready (scan-on-push + KMS encryption)."

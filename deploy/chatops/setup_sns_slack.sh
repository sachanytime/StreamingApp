#!/usr/bin/env bash
set -euo pipefail
aws sns create-topic --name streamingapp-deployments --region "${AWS_REGION:-ap-south-1}"
echo "Subscribe the Lambda: aws sns subscribe --protocol lambda --notification-endpoint <lambda-arn> --topic-arn <arn>"

#!/usr/bin/env bash
set -euo pipefail
REGION="${AWS_REGION:-ap-south-1}"; ACCOUNT="${AWS_ACCOUNT_ID:-852373397151}"
TOPIC="arn:aws:sns:$REGION:$ACCOUNT:streamingapp-deployments"; CLUSTER="streamingapp-eks"
mk(){ aws cloudwatch put-metric-alarm --alarm-name "$1" --namespace ContainerInsights --metric-name "$2" \
  --dimensions Name=ClusterName,Value=$CLUSTER --statistic Average --period 300 --evaluation-periods 2 \
  --threshold "$3" --comparison-operator GreaterThanThreshold --alarm-actions "$TOPIC" --ok-actions "$TOPIC" --region "$REGION"; }
mk streamingapp-node-cpu-high node_cpu_utilization 80
mk streamingapp-pod-cpu-high pod_cpu_utilization 80
mk streamingapp-pod-mem-high pod_memory_utilization 80
mk streamingapp-pod-restarts pod_number_of_container_restarts 5
echo "CloudWatch alarms -> SNS $TOPIC"

#!/usr/bin/env bash
set -euo pipefail
ACCOUNT="${AWS_ACCOUNT_ID:-852373397151}"; REGION="${AWS_REGION:-ap-south-1}"
TAG="${1:-$(git rev-parse --short HEAD 2>/dev/null || echo v1)}"
ECR="$ACCOUNT.dkr.ecr.$REGION.amazonaws.com"
aws ecr get-login-password --region "$REGION" | docker login --username AWS --password-stdin "$ECR"
build(){ docker build -t "$ECR/streamingapp-$1:$TAG" -f "$3" "$2"; docker push "$ECR/streamingapp-$1:$TAG"; }
build auth      backend  backend/authService/Dockerfile
build streaming backend  backend/streamingService/Dockerfile
build admin     backend  backend/adminService/Dockerfile
build chat      backend  backend/chatService/Dockerfile
build frontend  frontend frontend/Dockerfile
echo "All 5 images pushed to $ECR (tag $TAG)"

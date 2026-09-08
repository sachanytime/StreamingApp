# StreamingApp — Deployment Guide

## Step 1 — Fork & sync
```bash
git clone https://github.com/<you>/StreamingApp.git && cd StreamingApp
git remote add upstream https://github.com/UnpredictablePrashant/StreamingApp.git
git fetch upstream && git merge upstream/main
```
## Step 2 — Containerize (Dockerfiles ship in the repo) & test locally
```bash
docker compose build && docker compose up -d
```
## Step 3 — AWS CLI
```bash
aws configure   # ap-south-1
```
## Step 4 — ECR + Jenkins CI (with Trivy gate)
```bash
bash deploy/ecr/create_repos.sh
bash deploy/ecr/build_and_push.sh v1
# Jenkins runs deploy/jenkins/Jenkinsfile: Checkout -> ECR -> Build -> Trivy scan -> Deploy
```
## Step 5 — EKS (IRSA + spot) + Helm
```bash
eksctl create cluster -f deploy/eks/cluster.yaml
aws eks update-kubeconfig --name streamingapp-eks --region ap-south-1
bash deploy/ingress/install_lb_controller.sh
bash deploy/autoscaling/install_autoscaling.sh
helm upgrade --install streamingapp deploy/helm/streamingapp -n streamingapp --create-namespace
```
## Step 5b — GitOps (ArgoCD) — continuous deployment
```bash
bash deploy/gitops/install_argocd.sh          # ArgoCD keeps EKS in sync with Git
```
## Step 6 — Monitoring & logging
```bash
bash deploy/observability/install_observability.sh   # Prometheus + Grafana
bash deploy/monitoring/cloudwatch_alarms.sh          # CloudWatch alarms -> SNS
```
## Step 6b — Security, secrets & backup
```bash
kubectl apply -f deploy/security/networkpolicy.yaml
kubectl apply -f deploy/secrets/external-secrets.yaml   # Secrets Manager via IRSA
bash deploy/backup/install_velero.sh
```
## Step 7 — Documentation
Committed under `docs/` (this guide, ARCHITECTURE.md, architecture.svg) and pushed to GitHub.
## Step 8 — Validation & load test
```bash
kubectl get ingress -n streamingapp
curl -I http://streamingapp.blog4bharat.com/
k6 run -e BASE_URL=http://streamingapp.blog4bharat.com deploy/loadtest/k6-load-test.js
kubectl get hpa -n streamingapp -w        # watch pods scale under load
```
## Step 9 (Bonus) — ChatOps
```bash
bash deploy/chatops/setup_sns_slack.sh    # SNS -> Lambda -> Slack #assignment-herovired
```
## Progressive delivery (canary)
```bash
kubectl argo rollouts get rollout frontend -n streamingapp --watch   # 20 -> 50 -> 100%
```
## Teardown
```bash
helm uninstall streamingapp -n streamingapp
eksctl delete cluster --name streamingapp-eks --region ap-south-1
```

# StreamingApp — Orchestration & Scaling (Enhanced, Production-Grade)

MERN streaming platform (auth, streaming, admin, chat + frontend + MongoDB) delivered to **Amazon
EKS** through a full DevOps pipeline: **GitHub → Jenkins CI (build + Trivy scan) → ECR → ArgoCD
GitOps → Helm → EKS**, behind an **ALB Ingress**, with **HPA + Cluster Autoscaler**, **canary
releases**, **Prometheus/Grafana + CloudWatch**, **External Secrets (Secrets Manager) via IRSA**,
**NetworkPolicies**, **Velero backups**, **k6 load testing**, and **SNS → Slack ChatOps**.

## What's in `deploy/`
| Dir | Purpose |
|-----|---------|
| `ecr/` | create repos (scan-on-push, KMS) + build/push |
| `jenkins/Jenkinsfile` | CI: build → **Trivy scan gate** → Helm deploy → SNS |
| `github-actions/ci.yml` | CI alternative (OIDC, no static keys) |
| `eks/cluster.yaml` | EKS with **OIDC/IRSA**, managed + **spot** nodegroups, Container Insights |
| `helm/streamingapp/` | Chart: Deployments + Services + **HPA + PDB** + IRSA SA + Mongo |
| `ingress/` | **ALB Ingress** + AWS Load Balancer Controller install |
| `autoscaling/` | **Cluster Autoscaler** + metrics-server |
| `gitops/` | **ArgoCD** application (auto-sync, self-heal) |
| `rollouts/` | **Argo Rollouts canary** for the frontend |
| `security/` | **NetworkPolicies** + **Pod Security (restricted)** |
| `secrets/` | **External Secrets** → AWS Secrets Manager |
| `observability/` | **Prometheus + Grafana** (kube-prometheus-stack) + ServiceMonitor |
| `monitoring/` | CloudWatch alarms → SNS |
| `backup/` | **Velero** daily namespace backup to S3 |
| `loadtest/` | **k6** ramp test to validate HPA → Cluster Autoscaler |
| `chatops/` | SNS topic + **Slack** Lambda |

## Enhancements beyond the brief
GitOps CD (ArgoCD) · canary releases (Argo Rollouts) · CI image scanning (Trivy) · Cluster Autoscaler
+ spot nodes · ALB Ingress · External Secrets + IRSA (no static keys) · NetworkPolicies + restricted
Pod Security · Prometheus/Grafana · Velero backups · k6 load testing.

## Quick start
See `docs/DEPLOYMENT.md` for the full step-by-step (Steps 1–9 + GitOps, security, backup, canary).

## Architecture
See `docs/ARCHITECTURE.md` and `docs/architecture.svg`.

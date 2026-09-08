# StreamingApp — System Architecture (Enhanced)

## Flow
Developer push → **GitHub** (fork) → **Jenkins CI** builds 5 images, **scans them with Trivy**
(fails on HIGH/CRITICAL), and pushes to **Amazon ECR** (scan-on-push + KMS). Deployment is
**GitOps**: **ArgoCD** watches the repo and syncs the **Helm** release to **Amazon EKS**. Traffic
enters via an **ALB Ingress** (AWS Load Balancer Controller). The frontend ships through a
**canary rollout** (Argo Rollouts). **HPA** scales pods and the **Cluster Autoscaler** scales nodes
(managed + spot). Secrets come from **AWS Secrets Manager** via the **External Secrets Operator**
(pods authenticate with **IRSA**, no static keys). Observability is **Prometheus + Grafana**
alongside **CloudWatch Container Insights**; alarms and deploy events fan out through **SNS → Slack**
(ChatOps). **Velero** backs the namespace up to S3 daily. **k6** load tests validate autoscaling.

## Layers & capabilities
| Concern | Base (brief) | Enhancement (added) |
|---------|--------------|---------------------|
| CI | Jenkins build + push | + **Trivy image scan gate**, + GitHub Actions (OIDC) alt |
| Registry | ECR repos | + scan-on-push, + KMS encryption |
| CD | Helm via Jenkins | + **ArgoCD GitOps** (auto-sync, self-heal) |
| Ingress | LoadBalancer svc | + **ALB Ingress** + AWS LB Controller, HTTPS/ACM |
| Release | rolling update | + **Argo Rollouts canary** (20→50→100%) |
| Scaling | HPA | + **Cluster Autoscaler**, + **spot nodegroup**, + **PDB** |
| Secrets | k8s Secret | + **External Secrets** → Secrets Manager, + **IRSA** |
| Security | — | + **NetworkPolicies**, + **Pod Security (restricted)** |
| Monitoring | CloudWatch | + **Prometheus + Grafana** + ServiceMonitor |
| Backup/DR | — | + **Velero** daily backups to S3 |
| Load testing | — | + **k6** ramp test to validate HPA/CA |
| ChatOps | SNS→Slack (bonus) | retained |

See `architecture.svg`.

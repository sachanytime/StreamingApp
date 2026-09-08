# Scaling model
- **HPA** (per service) scales pods on CPU 70% / memory 80% between 2 and 8 replicas (Helm chart).
- **Cluster Autoscaler** scales worker nodes within the managed node group (2–6) + a spot pool (0–4).
- **PodDisruptionBudget** keeps ≥1 pod available during voluntary disruptions/upgrades.
- **k6 load test** (deploy/loadtest) drives traffic to validate the HPA → Cluster Autoscaler chain.

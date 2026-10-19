# sample-k8s-gitops

GitOps repository for the Lima vanilla Kubernetes cluster. Managed by ArgoCD — everything pushed here is reconciled automatically.

Part of a three-repo setup:

| Repository | Purpose |
|---|---|
| [sample-k8s-argocd-bootstrap](https://github.com/gek0/sample-k8s-argocd-bootstrap) | Installs ArgoCD; owns projects and the root app |
| [sample-k8s-gitops](https://github.com/gek0/sample-k8s-gitops) (this repo) | Application definitions and workload manifests |
| [sample-k8s-app](https://github.com/gek0/sample-k8s-app) | Nginx sample application manifests |

## Repository structure

```
argocd/        Application and ApplicationSet CRs — one subdirectory per service or team
services/      Helm values and base Kubernetes manifests — referenced by Applications in argocd/
components/    Workload manifests deployed by ApplicationSets — layered as components/{env}/{project}/*.yaml
```

## How it works

The root app in `sample-k8s-argocd-bootstrap` watches `argocd/` recursively. Any Application or ApplicationSet added here is automatically picked up — no manual `kubectl apply` needed after initial bootstrap.

`*-values.yaml` files are excluded from the root app's directory scan (they are not Kubernetes resources) and are referenced directly by the Helm-based Application CRs via the `$values` multi-source pattern.

## ArgoCD projects

| Project | Allowed namespaces | Used by |
|---|---|---|
| `cluster-ops` | all (`*`) | monitoring stack, vault, external-secrets, root app |
| `github-personal` | `github-personal-*` | devops-infra appset, nginx app, vault-webapp |

## Adding a new service

**Helm-based service** (e.g. a new platform tool):
1. Add `services/<service>/` with values files and any base Kubernetes resources
2. Add `argocd/<service>/<service>.yaml` — an Application CR using multi-source (Helm chart + `$values` ref)
3. Push — ArgoCD picks it up automatically

**Environment-scoped workloads** (e.g. Crossplane resources per env):
1. Add manifests under `apps/{env}/{project}/`
2. Add or update an ApplicationSet in `argocd/{project}/` that generates one Application per env with `path: apps/{{env}}/{project}`
3. Push — ApplicationSet creates the child Applications automatically

## Exposed services

| Service | Address | Notes |
|---|---|---|
| Grafana | http://192.168.104.54 | admin / admin — Prometheus & Loki datasources pre-configured |
| Vault | dynamic MetalLB IP, port 8200 | HA Raft (round-robin) — must run `k8s/scripts/vault-post-install.sh` once after first sync to init and unseal |
| Vault active | dynamic MetalLB IP, port 8200 | Always routes to the active Vault node |
| Vault standby | dynamic MetalLB IP, port 8200 | Always routes to standby Vault nodes |
| Vault webapp | http://192.168.104.55 | Demo app reading secrets from Vault (ns: `github-personal-vault-webapp`) — source in `demos/vault-webapp/` |

Prometheus and Alertmanager are ClusterIP only — accessible via Grafana or `kubectl port-forward`.

External Secrets Operator has no external endpoint — it runs as an in-cluster operator. The `vault-cluster-store` ClusterSecretStore connects to Vault via Kubernetes auth. Use `ExternalSecret` CRs in any namespace to sync secrets from Vault into Kubernetes Secrets. For AWS, add a second ClusterSecretStore with an AWS provider block — no additional operator needed.

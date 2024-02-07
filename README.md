# Platform GitOps

This repository has 2 main sections

- `/registry`: the argocd gitops application registry for each of our clusters
- `/terraform`: infrastructure as code & configuration as code for your cloud, git provider, vault, and user resources

## Apps

The bootstrapping process will create the following applications:

| Application              | Namespace        | Description                                 | URL (where applicable)             |
| ------------------------ | ---------------- | ------------------------------------------- | ---------------------------------- |
| Argo CD                  | argocd           | GitOps Continuous Delivery                  | https://argocd.homelab.io               |
| Cert Manager             | cert-manager     | Certificate Automation Utility              |                                    |
| Certificate Issuers      | clusterwide      | Let's Encrypt browser-trusted certificates  |                                    |
| External Secrets         | external-secrets | Syncs Kubernetes secrets with Vault secrets |                                    |
| Contour Ingress Controller | projectcontour    | Ingress Controller                          |                                    |
| Vault                    | vault            | Secrets Management                          | https://vault.homelab.io                |

## Bootstrapping

- Install Argo CD

  ```sh
  argocd-autopilot repo bootstrap \
    --repo https://github.com/malston/platform-gitops \
    --git-token "$(< ./github-token)"
  ```

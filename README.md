# Platform GitOps

This repository has 2 main sections

- `/registry`: the argocd gitops application registry for each of our clusters
- `/terraform`: infrastructure as code & configuration as code for your cloud, git provider, vault, and user resources

## Apps

The bootstrapping process will create the following applications:

| Application              | Namespace        | Description                                 | URL (where applicable)             |
| ------------------------ | ---------------- | ------------------------------------------- | ---------------------------------- |
| ArgoCD                  | argocd           | GitOps Continuous Delivery                  | https://argocd.homelab.io               |
| Cert Manager             | cert-manager     | Certificate Automation Utility              |                                    |
| Certificate Issuers      | clusterwide      | Let's Encrypt browser-trusted certificates  |                                    |
| External Secrets         | external-secrets | Syncs Kubernetes secrets with Vault secrets |                                    |
| Contour Ingress Controller | projectcontour    | Ingress Controller                          |                                    |
| Vault                    | vault            | Secrets Management                          | https://vault.homelab.io                |

## Bootstrapping

- Configure MinIO and Vault

  ```sh
  cd terraform/vault

  terraform init -backend=false

  terraform refresh \
    -var-file=terraform.tfvars

  terraform plan \
    -out=terraform.tfplan \
    -var-file=terraform.tfvars

  terraform apply \
    -parallelism=5 \
    terraform.tfplan

  terraform output --raw stable_config_opsmanager > ../terraform-outputs.yml
  ```

- Install ArgoCD

  ```sh
  export GIT_USER=<git-user>
  export GIT_TOKEN=<personal-access-token>
  export GIT_REPO=https://github.com/$GIT_USER/argocd-bootstrap
  argocd-autopilot repo bootstrap
  ```

- Install Registry

  ```sh
  kubectl apply -f registry/argocd/registry.yaml
  argocd app get registry
  argocd app sync registry
  ```

- Login to ArgoCD

  ```sh
  argocd account update-password --current-password "$(argocd admin initial-password -n argocd | head -1)"
  argocd login argocd.homelab.io --username admin --insecure || argocd login argocd.homelab.io --username admin --insecure --core
  ```

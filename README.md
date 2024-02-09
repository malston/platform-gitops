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

- Login to Vault and configure the root key into shards (referred as key shares, or unseal keys). A certain threshold of shards is required to reconstruct the root key, which is then used to decrypt the Vault's encryption key. Vault is typically initialized with 5 key shares and a key threshold of 3. Refer to the [Seal/Unseal documentation](https://developer.hashicorp.com/vault/docs/concepts/seal#seal-unseal) for further details.

- Add secrets to Vault

  ```sh
  cd terraform/vault

  terraform init -backend=false

  cat > terraform.tfvars <<EOF
  b64_docker_auth="$(echo malston:$GIT_TOKEN | base64)"
  github_token="$GIT_TOKEN"
  vault_address="http://vault.homelab.io"
  vault_token="$VAULT_TOKEN"
  kubernetes_api_endpoint="https://192.168.15.23:6443"
  EOF

  terraform plan -out=terraform.tfplan -var-file=terraform.tfvars

  terraform apply terraform.tfplan
  ```

- Create a secret used by ExternalSecrets Store

  ```sh
  kubectl create secret generic vault-token --from-literal=token=$VAULT_TOKEN --namespace=external-secrets-operator
  ```

## TODO

- [ ] Create cert for [kubelab.app](kubelab.app) domain.
- [ ] Rebuild with [kubelab.app](kubelab.app) domain.
- [ ] Create a CLI app that does all the steps above.

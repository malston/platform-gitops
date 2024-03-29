# Platform GitOps

This repository has 2 main sections

- `/registry`: the argocd gitops application registry for each of our clusters
- `/terraform`: infrastructure as code & configuration as code for your cloud, git provider, vault, and user resources

## Apps

The bootstrapping process will create the following applications:

| Application                | Namespace        | Description                                 | URL (where applicable)             |
| ---------------------------| ---------------- | ------------------------------------------- | ---------------------------------- |
| ArgoCD                     | argocd           | GitOps Continuous Delivery                  | https://argocd.kubelab.app         |
| Cert Manager               | cert-manager     | Certificate Automation Utility              |                                    |
| Certificate Issuers        | clusterwide      | Let's Encrypt browser-trusted certificates  |                                    |
| External Secrets           | external-secrets | Syncs Kubernetes secrets with Vault secrets |                                    |
| Contour Ingress Controller | projectcontour   | Ingress Controller                          |                                    |
| Vault                      | vault            | Secrets Management                          | https://vault.kubelab.app          |

## Bootstrapping

- Install ArgoCD

  ```sh
  export GIT_USER=<git-user>
  export GIT_TOKEN=<personal-access-token>
  export GIT_REPO=https://github.com/$GIT_USER/argocd-bootstrap
  argocd-autopilot repo bootstrap || argocd-autopilot repo bootstrap --recover --app https://github.com/malston/argocd-bootstrap/bootstrap/argo-cd
  ```

  Setup port-forward so we can to connect to argocd on the local interface

  ```sh
  kubectl port-forward svc/argocd-server -n argocd 8000:443 &
  ```
  
- Install Registry

  ```sh
  kubectl apply -f registry/mgmt/registry.yaml
  argocd app get registry-mgmt
  ```

- Login to ArgoCD

  ```sh
  argocd account update-password --current-password "$(argocd admin initial-password -n argocd | head -1)"
  argocd login argocd.kubelab.app --username admin --insecure || argocd login argocd.kubelab.app --username admin --insecure --core
  ```

- Login to Vault and configure the root key into shards (referred as key shares, or unseal keys). A certain threshold of shards is required to reconstruct the root key, which is then used to decrypt the Vault's encryption key. Vault is typically initialized with 5 key shares and a key threshold of 3. Refer to the [Seal/Unseal documentation](https://developer.hashicorp.com/vault/docs/concepts/seal#seal-unseal) for further details.

- Add secrets to Vault

  ```sh
  cd terraform/vault

  terraform init || terraform init -reconfigure

  cat > terraform.tfvars <<EOF
  aws_access_key_id="k-ray"
  aws_secret_access_key="feedkraystars"
  b64_docker_auth="$(echo malston:$GIT_TOKEN | base64)"
  cibot_ssh_private_key="$(sed -z 's/\n/\\n/g' ~/.ssh/github_com_rsa)"
  cibot_ssh_public_key="$(< ~/.ssh/github_com_rsa.pub)"
  github_token="$GIT_TOKEN"
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

## Recover

- If you delete argo cd for any reason and want to restore it.

  ```sh
  argocd-autopilot repo bootstrap --recover --app https://github.com/malston/argocd-bootstrap/bootstrap/argo-cd
  ```

## Download MinIO buckets

  ```sh
  mc alias set kubelab https://minio.kubelab.app $(vault kv get -mount=secret -format=json ci-secrets | jq -r .data.data.accesskey) $(vault kv get -mount=secret -format=json ci-secrets | jq -r .data.data.secretkey)
  mc admin info kubelab
  mc ls kubelab --recursive
  mkdir minio
  mc cp kubelab --recursive minio
  ```

provider "kubernetes" {
  config_path = "/Users/malston/.kube/platform-gitops/kubeconfig"
}

resource "vault_auth_backend" "k8s" {
  type = "kubernetes"
  path = "kubernetes/platform-gitops"
}

resource "vault_kubernetes_auth_backend_config" "k8s" {
  backend         = vault_auth_backend.k8s.path
  kubernetes_host = var.kubernetes_api_endpoint
}

resource "vault_kubernetes_auth_backend_role" "k8s_external_secrets" {
  backend                          = vault_auth_backend.k8s.path
  role_name                        = "external-secrets"
  bound_service_account_names      = ["external-secrets"]
  bound_service_account_namespaces = ["*"]
  token_ttl                        = 86400
  token_policies                   = ["admin", "default"]
}

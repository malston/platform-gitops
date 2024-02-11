resource "vault_identity_oidc_key" "key" {
  name               = "kubelab"
  algorithm          = "RS256"
  allowed_client_ids = ["*"] # todo make explicit list of client ids
  verification_ttl   = 2500  # 41min
}

resource "vault_identity_oidc_provider" "kubelab" {
  name          = "kubelab"
  https_enabled = true
  issuer_host   = "vault.kubelab.app"
  allowed_client_ids = [
    "*" # todo make explicit list of client ids
  ]
  scopes_supported = [
    vault_identity_oidc_scope.group_scope.name,
    vault_identity_oidc_scope.user_scope.name,
    vault_identity_oidc_scope.email_scope.name,
    vault_identity_oidc_scope.profile_scope.name
  ]
}

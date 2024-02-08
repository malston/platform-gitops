resource "random_password" "ci_password" {
  length           = 22
  special          = true
  override_special = "!#$"
}

resource "vault_generic_secret" "docker_config" {
  path = "secret/dockerconfigjson"

  data_json = jsonencode(
    {
      dockerconfig = jsonencode({ "auths" : { "ghcr.io" : { "auth" : "${var.b64_docker_auth}" } } }),
    }
  )

  depends_on = [vault_mount.secret]
}

resource "vault_generic_secret" "registry_auth" {
  path = "secret/registry-auth"

  data_json = jsonencode(
    {
      auth = jsonencode({ "auths" : { "ghcr.io" : { "auth" : "${var.b64_docker_auth}" } } }),
    }
  )

  depends_on = [vault_mount.secret]
}

resource "vault_generic_secret" "minio_creds" {
  path = "secret/minio"

  data_json = jsonencode(
    {
      accesskey = var.aws_access_key_id,
      secretkey = var.aws_secret_access_key,
    }
  )

  depends_on = [vault_mount.secret]
}

resource "vault_generic_secret" "external_secrets_token" {
  path = "secret/external-secrets-store"

  data_json = jsonencode(
    {
      token = var.vault_token
    }
  )

  depends_on = [vault_mount.secret]
}

resource "vault_generic_secret" "ci_secrets" {
  path = "secret/ci-secrets"

  data_json = jsonencode(
    {
      accesskey             = var.aws_access_key_id,
      secretkey             = var.aws_secret_access_key,
      BASIC_AUTH_USER       = "cibot",
      BASIC_AUTH_PASS       = random_password.ci_password.result,
      SSH_PRIVATE_KEY       = var.cibot_ssh_private_key,
      PERSONAL_ACCESS_TOKEN = var.github_token,
    }
  )

  depends_on = [vault_mount.secret]
}

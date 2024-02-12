provider "vault" {
  skip_tls_verify = "true"
}

terraform {
  backend "s3" {
    bucket   = "state-store"
    key      = "terraform/vault/terraform.tfstate"
    endpoint = "https://minio.kubelab.app"

    access_key                  = "k-ray"
    secret_key                  = "feedkraystars"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    force_path_style            = true
  }
}

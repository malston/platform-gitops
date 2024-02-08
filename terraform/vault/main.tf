provider "vault" {
  skip_tls_verify = "true"
}

terraform {
  backend "s3" {
    bucket   = "state-store"
    key      = "terraform/vault/terraform.tfstate"
    endpoint = "http://minio.minio.svc.cluster.local:9000"

    access_key                  = "admin"
    secret_key                  = "admin"
    region                      = "us-west-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

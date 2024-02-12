terraform {
  backend "s3" {
    bucket   = "state-store"
    key      = "terraform/github/terraform.tfstate"
    endpoint = "http://minio.minio.svc.cluster.local:9000"

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

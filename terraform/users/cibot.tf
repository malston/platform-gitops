terraform {
  backend "s3" {
    bucket   = "state-store"
    key      = "terraform/users/terraform.tfstate"
    endpoint = "http://minio.minio.svc.cluster.local:9000"

    access_key                  = "k-ray"
    secret_key                  = "feedkraystars"
    region                      = "main"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.17.0"
    }
  }
}

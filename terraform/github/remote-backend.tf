terraform {
  backend "s3" {
    bucket   = "state-store"
    key      = "terraform/github/terraform.tfstate"
    endpoint = "http://minio.homelab.io:9000

    access_key                  = "admin"
    secret_key                  = "admin"
    region                      = "us-west-1"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}

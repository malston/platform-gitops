variable "aws_access_key_id" {
  default = ""
  type    = string
}

variable "aws_secret_access_key" {
  default = ""
  type    = string
}

variable "b64_docker_auth" {
  type = string
}

variable "github_token" {
  type = string
}

variable "cibot_ssh_private_key" {
  default = ""
  type    = string
}

variable "cibot_ssh_public_key" {
  default = ""
  type    = string
}

variable "vault_token" {
  default = ""
  type    = string
}

variable "kubernetes_api_endpoint" {
  default = ""
  type    = string
}

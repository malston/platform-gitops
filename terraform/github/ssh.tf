resource "github_user_ssh_key" "cibot" {
  count = var.cibot_ssh_public_key == "" ? 0 : 1
  title = "cibot"
  key   = var.cibot_ssh_public_key
}

variable "cibot_ssh_public_key" {
  type    = string
  default = ""
}

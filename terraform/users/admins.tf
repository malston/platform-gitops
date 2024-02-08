data "vault_identity_group" "admins" {
  group_name = "admins"
}

resource "vault_identity_group_member_entity_ids" "admins_membership" {
  member_entity_ids = [
    module.cibot.vault_identity_entity_id
  ]

  group_id = data.vault_identity_group.admins.group_id
}

variable "initial_password" {
  type    = string
  default = ""
}

module "cibot" {
  # cibot is the automation user for all automation
  # on the platform that needs a bot account
  source = "./modules/user/github"

  acl_policies      = ["admin"]
  email             = "marktalston@gmail.com"
  first_name        = "Platform"
  github_username   = "ci"
  last_name         = "GitOps"
  initial_password  = var.initial_password
  username          = "cibot"
  user_disabled     = false
  userpass_accessor = data.vault_auth_backend.userpass.accessor
}

# todo add organization support
module "platform-gitops" {
  source             = "./modules/repository"
  visibility         = "private"
  repo_name          = "platform-gitops"
  archive_on_destroy = false
  auto_init          = false # set to false if importing an existing repository
}

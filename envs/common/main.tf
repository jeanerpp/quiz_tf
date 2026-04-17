provider "aws" {
  region = var.config.region
}

module "deployment" {
  source   = "../../modules/deployment"
  config   = var.config
}

output "app_url" {
  value = "${module.deployment.app_lb_url}"
}
provider "aws" {
  region = var.config.region
}

module "deployment" {
  source   = "../../modules/deployment"
  config   = var.config
}

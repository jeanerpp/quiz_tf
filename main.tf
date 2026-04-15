provider "aws" {
  region = var.config.region
}

module "networking" {
  source = "./modules/networking"
  config = var.config
}

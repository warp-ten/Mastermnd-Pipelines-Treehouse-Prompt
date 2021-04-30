provider "aws" {
  region = var.dev_region
}


module "dev_environment" {
  source         = "../modules/environment"
  region         = var.dev_region
  env            = var.env
  instance_count = var.instance_count
}
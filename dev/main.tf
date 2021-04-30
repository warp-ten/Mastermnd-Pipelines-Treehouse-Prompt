provider "aws" {
  region = var.dev_region
}

module "dev_environment" {
  source     = "../modules/environment"
  region     = var.dev_region
  env        = var.env
  instance   = var.instance
  subnet_one = var.subnet_one
  subnet_two = var.subnet_two
}
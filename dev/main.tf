terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.dev_region
}


module "dev_environment" {
  source   = "../modules/environment"
  region   = var.dev_region
  env      = var.env
  vpc_cidr = var.vpc_cidr
  instance = var.instance
  subnet   = var.subnet
}
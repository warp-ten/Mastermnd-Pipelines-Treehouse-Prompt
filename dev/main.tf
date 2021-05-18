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

###############################################################
#### user_data to install nginx is hardcoded in the module ####
###############################################################
module "dev_environment" {
  source      = "../modules/environment"
  dev_region  = var.dev_region
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  instance    = var.instance
  subnet      = var.subnet
  keyname     = var.keyname
  bucket_name = var.bucket_name
}
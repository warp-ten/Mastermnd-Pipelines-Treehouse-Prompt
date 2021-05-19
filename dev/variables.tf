variable "dev_region" {
  type    = string
  default = "us-east-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr" {
  default = "172.16.0.0/16"
}

variable "subnet" {
  type = map(any)
  default = {
    az       = "us-east-1b"
    cidr     = "172.16.1.0/24"
    publicip = true
    tag      = "-public"
  }
}

variable "instance" {
  type = map(any)
  default = {
    type           = "t2.micro"
    instance_count = 1
    public         = true
  }
}

variable "bucket_name" {
  type = map(string)
  description = "each key and value is used to populate bucket creation"
  default = {
    asset = "assets-treehouse-doge"
    static = "static-treehouse-doge"
  }
}

variable "keyname" {
  type    = string
  default = "terraform"
}
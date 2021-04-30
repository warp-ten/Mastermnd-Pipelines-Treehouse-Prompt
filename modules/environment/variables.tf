variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type = string
}

variable "instance" {
  type = map(any)
  default= {
    type = "t2.micro"
    instance_count = 1
    public = true
  }
}

variable "subnet_one" {
  type = map(any)
  default = {
    az       = "us-east-1a"
    cidr     = "10.0.1.0/24"
    publicip = true
    tag      = "-public-1"
  }
}

variable "subnet_two" {
  type = map(any) 
  default = {
  create = false 
  az = "us-east-2a"
  cidr = "10.0.2.0/24"
  publicip = false
  tag = "-private-2"
  }
}
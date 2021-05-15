variable "dev_region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "subnet" {
  type = map(any)
  default = {
    az       = "us-east-1b"
    cidr     = "10.0.1.0/24"
    publicip = true
    tag      = "-public-subnet"
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
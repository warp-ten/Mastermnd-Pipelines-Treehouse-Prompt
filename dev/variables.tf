variable "dev_region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "instance" {
  type = map(any)
  default = {
    type           = "t2.micro"
    instance_count = 2
    public         = true
  }
}

variable "subnet_one" {
  type = map(any)
  default = {
    az       = "us-east-1b"
    cidr     = "10.0.1.0/24"
    publicip = true
    tag      = "-public-1"
  }
}

variable "subnet_two" {
  type = map(any)
  default = {
    create   = false
    az       = "us-east-2a"
    cidr     = "10.0.2.0/24"
    publicip = false
    tag      = "-private-2"
  }
}
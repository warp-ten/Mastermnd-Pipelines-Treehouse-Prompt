variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type = string
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "instance" {
  type = map(any)
  default = {
    type           = "t2.micro"
    instance_count = 1
    public         = true
  }
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

# variable "subnet_one" {
#   type = map(any)
#   default = {
#     az       = "us-east-1a"
#     cidr     = "10.0.1.0/24"
#     publicip = true
#     tag      = "-public-1"
#   }
# }

# variable "subnet_two" {
#   type = map(any) 
#   default = {
#   create = false 
#   az = "us-east-2a"
#   cidr = "10.0.2.0/24"
#   publicip = false
#   tag = "-private-2"
#   }
# }

# variable "nacl_ingress" {
#   type = list(map(any))
# }

# nacl_ingress = [
#   {
#     description = "port 443"
#     from = 443
#     to = 443
#     portocol = "tcp"
#     cidr = "0.0.0.0/0"
#   },
#   {
#     description = "port 80"
#     from = 80
#     to = 80
#     portocol = "tcp"
#     cidr = "0.0.0.0/0"
#   },
#   {
#     description = "port 22"
#     from = 22
#     to = 22
#     portocol = "tcp"
#     cidr = "0.0.0.0/0"
#   }
# ]

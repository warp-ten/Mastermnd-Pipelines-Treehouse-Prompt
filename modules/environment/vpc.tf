resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr
  # Makes your instances shared on the host server
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.env}-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${var.env}-IGW"
  }
}

resource "aws_subnet" "subnet" {

  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = lookup(var.subnet, "az")
  cidr_block              = lookup(var.subnet, "cidr")
  map_public_ip_on_launch = lookup(var.subnet, "publicip")
  tags = {
    "Name" = "${var.env}${lookup(var.subnet, "tag")}"
  }
}

resource "aws_route_table" "public" {
  # The VPC ID
  vpc_id = aws_vpc.vpc.id
  route {
    # CIDR block of destination
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
  tags = {
    Name = "${var.env}-public-route"
  }
}

resource "aws_route_table_association" "public-route-assoc" {
  # The subnet ID to associate
  subnet_id = aws_subnet.subnet.id
  # Route table ID to associate
  route_table_id = aws_route_table.public.id
}

locals {
  ingress_rules = [{
    description = "Allow TLS"
    port        = 443
    protocol    = "tcp"
    cidr        = ["0.0.0.0/0"]
    },
    {
      name        = "Allow http"
      port        = 80
      description = "Port 80"
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    },
    {
      name        = "Allow tcp"
      port        = 8080
      description = "Port 8080"
      protocol    = "tcp"
      cidr        = ["0.0.0.0/0"]
    },
    {
      name        = "Allow SSH"
      port        = 22
      description = "port 22"
      protocol    = "tcp"
      cidr        = ["${data.external.myipaddr.result.ip}/32"]
  }]
}

#security groups are basically firewalls at the instance level
resource "aws_security_group" "sec_group" {
  #dynamic blocks iterate the creation of blocks that would repeate otherwise
  #instead of repeating blocks for dns,ssh,https dynamic blocks uses one block 
  vpc_id = aws_vpc.vpc.id
  dynamic "ingress" {
    for_each = local.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.port
      to_port     = ingress.value.port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env}-sg"
  }
}








# resource "aws_security_group" "allow_tls" {
#   name        = "allow_tls"
#   description = "Allow TLS inbound traffic"
#   vpc_id      = aws_vpc.vpc.id
#   dynamic "ingress" {
#     for_each = var.nacl_ingress
#     content {
#       description      = ingress.value.description
#       from_port        = ingress.value.from
#       to_port          = ingress.to
#       protocol         = ingress.value.protocol
#       cidr_blocks      = ingress.cidr
#     }
#   }
#   egress {
#     from_port        = 0
#     to_port          = 0
#     protocol         = "-1"
#     cidr_blocks      = ["0.0.0.0/0"]
#     ipv6_cidr_blocks = ["::/0"]
#   }

#   tags = {
#     Name = "allow_tls"
#   }
# }
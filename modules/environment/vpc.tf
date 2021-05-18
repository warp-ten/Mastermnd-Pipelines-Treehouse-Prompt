resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  # Makes your instances shared on the host server
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    "Name" = "${var.environment}-VPC"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "${var.environment}-IGW"
  }
}

resource "aws_subnet" "subnet" {
  vpc_id                  = aws_vpc.main.id
  availability_zone       = lookup(var.subnet, "az")
  cidr_block              = lookup(var.subnet, "cidr")
  map_public_ip_on_launch = lookup(var.subnet, "publicip")
  tags = {
    "Name" = "${var.environment}${lookup(var.subnet, "tag")}"
  }
}

resource "aws_route_table" "public" {
  # The VPC ID
  vpc_id = aws_vpc.main.id
  route {
    # CIDR block of destination
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags = {
    Name = "${var.environment}-public"
  }
}

resource "aws_route_table_association" "public-route-assoc" {
  # The subnet ID to associate
  subnet_id = aws_subnet.subnet.id
  # Route table ID to associate
  route_table_id = aws_route_table.public.id
}

#Security Group ports variables
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
  vpc_id = aws_vpc.main.id
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
    Name = "${var.environment}-sg"
  }
}

resource "aws_network_acl" "allow_all" {
  vpc_id     = aws_vpc.main.id
  subnet_ids = ["${aws_subnet.subnet.id}"]
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  ingress {
    protocol   = "-1"
    rule_no    = 200
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "dev-allowall"
  }
}
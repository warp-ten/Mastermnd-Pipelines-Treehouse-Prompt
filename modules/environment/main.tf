# Not sure why I have to hard code this
provider "aws" {
  region = "us-east-1"
}

resource "aws_vpc" "vpc" {
  cidr_block = "10.0.0.0/16"
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

resource "aws_subnet" "subnet_1" {
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = lookup(var.subnet_one, "az")
  cidr_block              = lookup(var.subnet_one, "cidr")
  map_public_ip_on_launch = lookup(var.subnet_one, "publicip")
  tags = {
    "Name" = "${var.env} ${lookup(var.subnet_one, "tag")}"
  }
}

resource "aws_subnet" "subnet_2" {
  count = lookup(var.subnet_two,"create") ? 1 : 0
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = lookup(var.subnet_one, "az")
  cidr_block              = lookup(var.subnet_one, "cidr")
  map_public_ip_on_launch = lookup(var.subnet_one, "publicip")
  tags = {
    "Name" = "${var.env} ${lookup(var.subnet_one, "tag")}"
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
  subnet_id = aws_subnet.subnet_1.id
  # Route table ID to associate
  route_table_id = aws_route_table.public.id
}

#get latest Amazon Linux 2 ami id 
data "aws_ssm_parameter" "linux2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

resource "aws_instance" "ec2" {
  count         = lookup(var.instance,"instance_count")
  depends_on    = [aws_internet_gateway.gw]
  ami           = data.aws_ssm_parameter.linux2.value
  instance_type = lookup(var.instance,"type")
  subnet_id     = aws_subnet.subnet_1.id
  tags = {
    "Name" = "${var.env}-${count.index}"
  }
}

# Not sure why I have to hard code this
provider "aws" {
  region = "us-east-1"
}

#get latest Amazon Linux 2 ami id 
data "aws_ssm_parameter" "linux2" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

#Get my Public IP 
data "external" "myipaddr" {
  program = ["bash", "-c", "curl -s 'https://ipinfo.io/json'"]
}

resource "aws_instance" "ec2" {
  count                  = lookup(var.instance, "instance_count")
  depends_on             = [aws_internet_gateway.main]
  ami                    = data.aws_ssm_parameter.linux2.value
  instance_type          = lookup(var.instance, "type")
  vpc_security_group_ids = [aws_security_group.sec_group.id]
  subnet_id              = aws_subnet.subnet.id
  key_name               = var.keyname
  # Commands to run at startup
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update
    sudo amazon-linux-extras install nginx1
    sudo yum install nginx -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
  EOF
  tags = {
    "Name" = "${var.environment}-${count.index}"
  }
}

resource "aws_s3_bucket" "s3" {
  for_each = var.bucket_name
  bucket = each.value
  acl    = "private"
  tags = {
    Name        = each.value
    Environment = var.environment
  }
}

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
  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.id
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
#ec2 instances need a profile so they can attach to a role for authentification
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "${var.environment}_ec2_profile"
  role = aws_iam_role.ec2-role.name
}
#roles give temporary programatic authentification, instead of hard coded
resource "aws_iam_role" "ec2-role" {
  name               = "${var.environment}_ec2_role"
  assume_role_policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
              "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
  }
  EOF
  tags = {
    Name = "${var.environment}-ec2-role"
  }
}

#policies allow or deny actions from principals to resources
#EC2 can list buckets in AWS CLI and has all permissions concerning the two associated buckets. 
resource "aws_iam_role_policy" "s3_allow_all" {
  for_each = var.bucket_name
  name   = "${var.environment}-${each.value}-allow-all"
  role   = aws_iam_role.ec2-role.id
  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "s3:ListAllMyBuckets",
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "s3:*",
            "Resource": [
                "arn:aws:s3:::${var.environment}-${each.value}/*",
                "arn:aws:s3:::${var.environment}-${each.value}"
            ]
        }
    ]
  }
  EOF
} 

resource "aws_s3_bucket" "s3" {
  for_each = var.bucket_name
  bucket = "${var.environment}-${each.value}"
  acl    = "private"
  force_destroy = true
  tags = {
    Name        = each.value
    Environment = var.environment
  }
}
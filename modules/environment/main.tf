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
  count         = lookup(var.instance, "instance_count")
  depends_on    = [aws_internet_gateway.gw]
  ami           = data.aws_ssm_parameter.linux2.value
  instance_type = lookup(var.instance, "type")
  subnet_id     = aws_subnet.subnet.id
  # Commands to run on Instance at startup
  user_data = <<-EOF
    #!/bin/bash
    sudo yum update
    sudo yum install nginx -y
    sudo systemctl enable nginx
    sudo systemctl start nginx
  EOF
  tags = {
    "Name" = "${var.env}-${count.index}"
  }
  vpc_security_group_ids = [aws_security_group.sec_group.id]
}

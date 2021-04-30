# Not sure why I have to hard code this
provider "aws" {
  region = "us-east-1"
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

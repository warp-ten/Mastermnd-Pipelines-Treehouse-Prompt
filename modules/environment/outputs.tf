output "publicIP" {
  value     = aws_instance.ec2.*.public_dns
  sensitive = false
}

output "privateIP" {
  value     = aws_instance.ec2.*.private_ip
  sensitive = false
}
output "publicIP" {
  value     = aws_instance.ec2.*.public_ip
  sensitive = false
}

# output "privateIP" {
#   value     = aws_instance.ec2.*.private_ip
#   sensitive = false
# }
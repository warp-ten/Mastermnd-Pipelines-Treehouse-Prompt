output "publicIP" {
  #this is pointing to the module call in the dev main.tf
  value     = module.dev_environment.publicIP.*
  sensitive = false
}

output "privateIP" {
  value     = module.dev_environment.privateIP.*
  sensitive = false
}
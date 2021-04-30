variable "region" {
  type    = string
  default = "us-east-1"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "env" {
  type = string
}

variable "instance_count" {
  type    = number
  default = 1
}

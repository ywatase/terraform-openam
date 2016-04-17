variable "key_name" {
  default = ""
}

variable "key_path" {
  default = ""
}

variable "access_key" {
  default = ""
}
variable "secret_key" {
  default = ""
}

variable "aws_region" {
  default = "eu-west-1"
}

variable "aws_amis" {
  default = {
    eu-west-1 = "ami-2a1fad59"
  }
}

variable "haproxy_version" {
  default = "1.6.4"
}

variable "public_ip" {
  default = ""
}
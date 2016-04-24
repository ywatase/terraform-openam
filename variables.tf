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

variable "ssoadm_path" {
  default = "/opt/openam/ssoadm/openam/bin/ssoadm"
}

variable "openam_server_type" {
  default = {
    master = "master"
    slave = "slave"
  }
}

variable "container-name" {
  default = {
    openam = "openam"
    ssoadm = "ssoadm"
  }
}
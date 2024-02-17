variable "type_instance" {
  type     = string
  nullable = false
  default  = "t2.micro"
}

variable "ami_type" {
  type     = string
  nullable = false
  default  = "amzn2-ami-hvm-*"
}

variable "mysql_endpoint" {
  type     = string
  nullable = false
}

variable "sg_ec2" {
  type     = string
  nullable = false
}

variable "sg_bastion" {
  type     = string
  nullable = false
}

variable "subnets_ids" {
  type     = list(string)
  nullable = false
}

variable "target_group_arn" {
  type     = string
  nullable = false
}

variable "key_name" {
  type      = string
  nullable  = false
  sensitive = true
}
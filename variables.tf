###############  SUBNETS  ##################

variable "cidr_block_subnets" {
  type     = list(string)
  nullable = false
  default  = ["10.0.128.0/20", "10.0.0.0/19", "10.0.32.0/19", "10.0.144.0/20"]
}

#################  VPC  ####################
variable "cidr_block_vpc" {
  type     = string
  nullable = false
  default  = "10.0.0.0/16"
}

#################  AZ  ####################
variable "availability_zone_a" {
  type     = string
  nullable = false
  default  = "eu-west-3a"
}

variable "availability_zone_b" {
  type     = string
  nullable = false
  default  = "eu-west-3b"
}

############## SECRETS #################
variable "access_key" {
  type     = string
  nullable = false
  sensitive = true
}

variable "secret_key" {
  type     = string
  nullable = false
  sensitive = true
}

variable "db_name" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "db_username" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "db_password" {
  type      = string
  nullable  = false
  sensitive = true
}

variable "key_name" {
  type      = string
  nullable  = false
  sensitive = true
}
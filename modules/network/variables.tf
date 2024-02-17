variable "cidr_block_vpc" {
  type     = string
  nullable = false
}

variable "availability_zone_a" {
  type     = string
  nullable = false
}

variable "availability_zone_b" {
  type     = string
  nullable = false
}

variable "cidr_block_subnets" {
  type     = list(string)
  nullable = false
}
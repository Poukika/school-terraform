variable "vpc_id" {
  type     = string
  nullable = false
}

variable "igw_id" {
  type     = string
  nullable = false
}

variable "subnets_ids" {
  type     = list(string)
  nullable = false
}

variable "gw_ids" {
  type     = list(string)
  nullable = false
}

variable "cidr_block_subnets" {
  type     = list(string)
  nullable = false
}
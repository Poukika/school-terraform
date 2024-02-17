variable "vpc_id" {
  type     = string
  nullable = false
}

variable "subnets_ids" {
  type     = list(string)
  nullable = false
}

variable "sg_alb" {
  type     = string
  nullable = false
}
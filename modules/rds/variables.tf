variable "subnets_ids" {
  type     = list(string)
  nullable = false
}

variable "sg_db" {
  type     = string
  nullable = false
}

variable "db_type_instance" {
  type     = string
  nullable = false
  default  = "db.t3.micro"
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

variable "availability_zone_a" {
  type     = string
  nullable = false
}

variable "availability_zone_b" {
  type     = string
  nullable = false
}

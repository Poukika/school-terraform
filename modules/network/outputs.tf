output "vpc_id" {
  value = aws_vpc.vpc.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "subnets_ids" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "eip_ids" {
  value = [for eip in aws_eip.eip_public : eip.id]
}

output "gw_ids" {
  value = [for gw in aws_nat_gateway.gw_public : gw.id]
}

output "cidr_block_subnets" {
  value = var.cidr_block_subnets
}
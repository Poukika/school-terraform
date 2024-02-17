output "sg_alb" {
  value = aws_security_group.sg_alb.id
}

output "sg_db" {
  value = aws_security_group.sg_db.id
}

output "sg_ec2" {
  value = aws_security_group.sg_ec2.id
}

output "sg_bastion" {
  value = aws_security_group.sg_bastion.id
}

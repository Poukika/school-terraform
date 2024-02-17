data "aws_ami" "ami" {     # déclaration de la source de données de type aws_ami (ami aws)
  most_recent = true       # demande à avoir l'image la plus recente disponible
  owners      = ["amazon"] # lorsque le proriétaire de l'image s'appele amazon

  filter {          # on ajoute un filtre
    name   = "name" # on veut filtrer l'image lorsque le nom à comme par amzn2-ami-hvm-, * pour n'importe quoi en suite
    values = [var.ami_type]
  }
}

resource "aws_launch_template" "ec2" {
  name          = "ec2_template"
  image_id      = data.aws_ami.ami.id
  instance_type = var.type_instance
  key_name      = "datacientest_keypair"
  user_data     = base64encode(templatefile("${path.module}/install_nginx.sh", { rds_host = var.mysql_endpoint }))
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.sg_ec2]
  }

  tags = {
    Name = "template_instance"
  }
}

resource "aws_autoscaling_group" "ec2" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.subnets_ids[1], var.subnets_ids[2]]

  launch_template {
    id      = aws_launch_template.ec2.id
    version = "$Latest"
  }
}

resource "aws_autoscaling_attachment" "ec2" {
  autoscaling_group_name = aws_autoscaling_group.ec2.id
  lb_target_group_arn    = var.target_group_arn
}

resource "aws_launch_template" "bastion" {
  name          = "bastion_template"
  image_id      = data.aws_ami.ami.id
  instance_type = var.type_instance
  key_name      = var.key_name
  user_data     = filebase64("${path.module}/install_nginx.sh")

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [var.sg_bastion]
  }

  tags = {
    Name = "template_bastion"
  }
}

resource "aws_autoscaling_group" "bastion" {
  desired_capacity    = 1
  max_size            = 2
  min_size            = 1
  vpc_zone_identifier = [var.subnets_ids[0], var.subnets_ids[3]]

  launch_template {
    id      = aws_launch_template.bastion.id
    version = "$Latest"
  }
}

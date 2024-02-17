########################### IGW ###########################
# Table de routage public subnets
resource "aws_route_table" "rtb_public" {

  vpc_id = var.vpc_id
  tags = {
    Name = "public-routetable"
  }
}

# route Internet gateway
resource "aws_route" "route_igw" {
  route_table_id         = aws_route_table.rtb_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = var.igw_id
}

# Association public subnets -> igw
resource "aws_route_table_association" "igw_subnets_association" {
  count          = 2
  subnet_id      = var.subnets_ids[count.index > 0 ? 3 : 0]
  route_table_id = aws_route_table.rtb_public.id

  depends_on = [aws_route_table.rtb_public]
}

####################### NAT ################################

# Table de routage private subnets
resource "aws_route_table" "rtb_ec2" {
  vpc_id = var.vpc_id
  count  = 2
  tags = {
    Name = "app-routetable-${count.index}"
  }
}

#créer une route vers la passerelle nat
resource "aws_route" "route_ec2_nat" {
  count                  = 2
  route_table_id         = aws_route_table.rtb_ec2[count.index].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = var.gw_ids[count.index]
  depends_on             = [aws_route_table.rtb_ec2]
}

# Association private subnets -> gw
resource "aws_route_table_association" "rta_subnet_association_app" {
  count          = 2
  subnet_id      = var.subnets_ids[count.index + 1]
  route_table_id = aws_route_table.rtb_ec2[count.index].id
  depends_on     = [aws_route.route_ec2_nat]
}

####################### SG ############################
resource "aws_security_group" "sg_bastion" {
  name   = "sg_bastion"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-bastion"
  }
}

resource "aws_security_group" "sg_ec2" {
  name   = "sg_ec2"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = [element(var.cidr_block_subnets, 0), element(var.cidr_block_subnets, 3)]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-ec2"
  }
}

## Création d'un équilibreur de charge d'application pour accéder à l'application
resource "aws_security_group" "sg_alb" {

  name   = "sg_alb"
  vpc_id = var.vpc_id

  ingress {
    from_port = 80
    to_port   = 80
    protocol  = "HTTP"
    # Veuillez limiter votre entrée aux seules adresses IP et ports nécessaires.
    # L'ouverture à 0.0.0.0/0 peut entraîner des failles de sécurité.
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-alb"
  }
}

resource "aws_security_group" "sg_db" {
  name   = "sg_db"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sg-db"
  }
}
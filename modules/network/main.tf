### Creation du vpc
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_block_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "tp-vpc"
  }
}

################ SUBNET ##############

resource "aws_subnet" "public_subnets" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = 4
  cidr_block              = element(var.cidr_block_subnets, count.index)
  map_public_ip_on_launch = "true"
  availability_zone       = count.index < 2 ? var.availability_zone_a : var.availability_zone_b
  tags = {
    Name = "subnet ${count.index}",
  }
  depends_on = [aws_vpc.vpc]
}

# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "igw"
  }

  depends_on = [aws_vpc.vpc]
}

## elastic ip
resource "aws_eip" "eip_public" {
  count      = 2
  domain     = "vpc"
  depends_on = [aws_vpc.vpc]
}

## NAT Gateway
resource "aws_nat_gateway" "gw_public" {
  count         = 2
  allocation_id = aws_eip.eip_public[count.index].id
  subnet_id     = aws_subnet.public_subnets[count.index > 0 ? 3 : 0].id

  tags = {
    Name = "nat-public-${count.index}"
  }
  depends_on = [aws_vpc.vpc]
}

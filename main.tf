terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# la région aws ou nous voulons déployer nos différentes ressources
provider "aws" {
  region     = "eu-west-3"
  access_key = var.access_key # la clé d’accès crée pour l'utilisateur qui sera utilisé par terraform
  secret_key = var.secret_key # la clé sécrète crée pour l'utilisateur qui sera utilisé par terraform
}


module "networking" {
  source              = "./modules/network"
  cidr_block_vpc      = var.cidr_block_vpc
  cidr_block_subnets  = var.cidr_block_subnets
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
}

module "alb" {
  source      = "./modules/alb"
  vpc_id      = module.networking.vpc_id
  subnets_ids = module.networking.subnets_ids
  sg_alb      = module.routing.sg_alb
}

module "ec2" {
  source           = "./modules/ec2"
  mysql_endpoint   = module.rds.mysql_endpoint
  sg_ec2           = module.routing.sg_ec2
  sg_bastion       = module.routing.sg_bastion
  subnets_ids      = module.networking.subnets_ids
  target_group_arn = module.alb.target_group_arn
  key_name         = var.key_name

  depends_on = [module.rds.mysql_endpoint]
}

module "rds" {
  source              = "./modules/rds"
  subnets_ids         = module.networking.subnets_ids
  sg_db               = module.routing.sg_db
  db_name             = var.db_name
  db_username         = var.db_username
  db_password         = var.db_password
  availability_zone_a = var.availability_zone_a
  availability_zone_b = var.availability_zone_b
}

module "routing" {
  source             = "./modules/routing"
  vpc_id             = module.networking.vpc_id
  igw_id             = module.networking.igw_id
  subnets_ids        = module.networking.subnets_ids
  gw_ids             = module.networking.gw_ids
  cidr_block_subnets = var.cidr_block_subnets

  depends_on = [module.networking.vpc_id, module.networking.igw_id, module.networking.eip_ids, module.networking.gw_ids, module.networking.subnets_ids]
}
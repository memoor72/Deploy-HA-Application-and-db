provider "aws" {
  region = "us-east-2"
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "devpro-vpc"
  cidr = var.vpc_cidr_block

  azs             = [var.avail_zone_1, var.avail_zone_2, var.avail_zone_3]
  private_subnets = [var.PrivSub1Cidr, var.PrivSub2Cidr, var.PrivSub3Cidr]
  public_subnets  = [var.PubSub1Cidr, var.PubSub2Cidr, var.PubSub3Cidr]
  private_subnet_tags = {
    "Name-1" = "${var.env_prefix}-prisubnet-1"
    "Name-2" = "${var.env_prefix}-prisubnet-2"
    "Name-3" = "${var.env_prefix}-prisubnet-3"
  }

  public_subnet_tags = {
    "Name-1" = "${var.env_prefix}-pubsubnet-1"
    "Name-2" = "${var.env_prefix}-pubsubnet-2"
    "Name-3" = "${var.env_prefix}-pubsubnet-3"
  }

  enable_nat_gateway   = false
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.env_prefix}-vpc"
    Terraform   = "true"
    Environment = "dev"
  }
}


resource "aws_internet_gateway" "gw" {
  count = 0
  vpc_id = module.vpc.vpc_id
}


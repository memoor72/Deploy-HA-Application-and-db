
locals {
  instances = {
    "nginx-web01"    = "websrvgrp",
    "tomcat-app01"   = "appsrvgrp",
    "memcache-mc01"  = "mcsrvgrp",
    "rabbitmq-rmq01" = "rmqsrvgrp",
    "mysql-db01"     = "dbsrvgrp",

  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  for_each = toset(keys(local.instances))

  name = each.key

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  associate_public_ip_address = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = local.instances[each.key]
  }
}

data "aws_instance" "created_instances" {
  for_each = module.ec2_instance

  instance_id = each.value.id
}

resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg.security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  associate_public_ip_address = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = "bastion"
  }
}

locals {
  bastion_public_ip = aws_instance.bastion.public_ip
}

module "inventory_production" {
  source = "gendall/ansible-inventory/local"

  servers = {
    for key, value in local.instances :
    value => [
      for instance in values(data.aws_instance.created_instances) :
      instance.public_ip if instance.tags["Role"] == value
    ]
  }
  output = "inventory/production"
}





resource "aws_db_subnet_group" "devpro_subnet_group" {
  name       = "devpro-rds-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "subnet group for RDS"
  }
}


resource "aws_elasticache_subnet_group" "devpro-ecache-subgrp" {
  name       = "devpro-ecache-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "subnet group for ECACHE"
  }
}

resource "aws_db_instance" "devpro_rds" {
  allocated_storage      = 20
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = var.instance_class
  username               = var.db_user
  password               = var.db_password
  parameter_group_name   = "default.mysql5.7"
  skip_final_snapshot    = true
  db_subnet_group_name   = aws_db_subnet_group.devpro_subnet_group.name
  vpc_security_group_ids = [module.backend_sg.security_group_id]
}

resource "aws_elasticache_cluster" "devpro-cache" {
  cluster_id           = "devpro-cache"
  engine               = "memcached"
  node_type            = var.node_type
  num_cache_nodes      = 1
  parameter_group_name = "default.memcached1.6"
  port                 = 11211
  security_group_ids   = [module.backend_sg.security_group_id]
  subnet_group_name    = aws_elasticache_subnet_group.devpro-ecache-subgrp.name


}

resource "aws_mq_broker" "devpro-rmq" {
  broker_name = "devpro-rmq"

  engine_type        = "ActiveMQ"
  engine_version     = "5.15.9"
  host_instance_type = var.host_instance_type
  subnet_ids         = [module.vpc.private_subnets[0]]
  security_groups    = [module.backend_sg.security_group_id]

  user {
    username = var.rmq_user
    password = var.rmq_pass
  }
}


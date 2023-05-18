resource "aws_db_subnet_group" "devpro_subnet_group" {
  name       = "devpro-rds-subgrp"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "subnet group for RDS"
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

resource "aws_lb" "wordpress" {
  name               = "wordpress-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.vote_service_sg.security_group_id]
  subnets            = module.vpc.public_subnets

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_target_group" "wordpress" {
  name     = "wordpress-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}

resource "aws_lb_listener" "wordpress" {
  load_balancer_arn = aws_lb.wordpress.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wordpress.arn
  }
}

resource "aws_lb_target_group_attachment" "wordpress1" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = module.ec2_instance["wordpress01"].id

  port             = 80
}

resource "aws_lb_target_group_attachment" "wordpress2" {
  target_group_arn = aws_lb_target_group.wordpress.arn
  target_id        = module.ec2_instance["wordpress02"].id
  port             = 80
}





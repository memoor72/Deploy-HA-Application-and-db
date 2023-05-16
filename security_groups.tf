module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "bastion-host-sg"
  description         = "Security group for bastion host"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "Nginx HTTP"
      cidr_blocks = "0.0.0.0/0"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      description = "Nginx HTTPS"
      cidr_blocks = "0.0.0.0/0"
    },
    # Tomcat
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "Tomcat"
      cidr_blocks = "0.0.0.0/0"
    },
    # Memcache
    {
      from_port   = 11211
      to_port     = 11211
      protocol    = "tcp"
      description = "Memcache"
      cidr_blocks = "0.0.0.0/0"
    },
    # RabbitMQ
    {
      from_port   = 5672
      to_port     = 5672
      protocol    = "tcp"
      description = "RabbitMQ"
      cidr_blocks = "0.0.0.0/0"
    },
    # MySQL
    {
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      description = "MySQL"
      cidr_blocks = "0.0.0.0/0"
    },
    # SSH
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "SSH"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]

}

# Create beanstalk instance security group

module "prod_sg" {
  source              = "terraform-aws-modules/security-group/aws"
  name                = "devpro-prod-sg"
  description         = "Security group for beanstalk instance"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [

    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      description = "elb HTTP"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

# Create Backend-s3 security group
module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "devpro-backend-sg"
  description         = "Security group for RDS, active mq, elastic cache"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [

    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "backend"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

module "bean-elb-sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "devpro-bean-elb-sg"
  description         = "Security group for vprofile-prod-sg"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [

    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "backend"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      description = "Allow all outbound traffic"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

resource "aws_security_group_rule" "sec_group_all_itself" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  security_group_id        = module.backend_sg.security_group_id
  source_security_group_id = module.backend_sg.security_group_id

}

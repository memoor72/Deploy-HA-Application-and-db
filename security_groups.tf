module "vote_service_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "webpress-instances-sg"
  description         = "Security group for webpress-instances,bastion"
  vpc_id              = module.vpc.vpc_id
  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = []
  ingress_with_cidr_blocks = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      description = "wordpress HTTP"
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

# Create Backend-s3 security group
module "backend_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name                = "devpro-backend-sg"
  description         = "Security group for RDS"
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

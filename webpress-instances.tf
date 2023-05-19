locals {
  instances = {
    "0" = "wordpress01",
    "1" = "wordpress02",
  }
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 4.0"

  for_each = local.instances

  name = each.key

  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = module.key_pair.key_pair_name
  monitoring             = true
  vpc_security_group_ids = [module.vote_service_sg.security_group_id]

  // Use modulo to distribute instances across different AZs
  subnet_id = module.vpc.public_subnets[each.key]

  associate_public_ip_address = true
  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = each.value
  }
}

data "aws_instance" "created_instances" {
  for_each = module.ec2_instance

  instance_id = each.value.id
}

resource "aws_instance" "bastion" {
  ami                         = var.ami
  instance_type               = var.instance_type
  key_name                    = module.key_pair.key_pair_name
  monitoring                  = true
  vpc_security_group_ids      = [module.vote_service_sg.security_group_id]
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
    Role        = "bastion"
  }

  connection {
    user        = var.USERNAME
    private_key = file(var.PRIV_KEY_PATH)
    host        = self.public_ip
  }

  depends_on = [aws_db_instance.devpro_rds]
}

locals {
  bastion_public_ip = aws_instance.bastion.public_ip
}

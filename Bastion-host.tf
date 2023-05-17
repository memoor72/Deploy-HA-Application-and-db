data "template_file" "init" {
   template = file("${path.module}/templates/db-deploy.tmpl")

  vars = {
    rds_endpoint = aws_db_instance.devpro_rds.address
    db_user     = var.db_user
    db_password = var.db_password
  }
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

  user_data = data.template_file.init.rendered

  provisioner "file" {
    content     = templatefile("templates/db-deploy.tmpl", { rds_endpoint = aws_db_instance.devpro_rds.address, db_user = var.db_user, db_password = var.db_password })
    destination = "/tmp/devpro_dbdeploy.sh"
  }


  provisioner "remote-exec" {
  inline = [
    "chmod +x /tmp/devpro_dbdeploy.sh",
    "sudo /tmp/devpro_dbdeploy.sh 2>&1"
  ]
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

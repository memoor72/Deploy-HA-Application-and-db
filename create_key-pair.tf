
#module "key_pair" {
  #source     = "terraform-aws-modules/key-pair/aws"
  #key_name   = "devpro-key"
 # public_key = file(var.public_key_location)

  #tags = {
  #  Terraform   = "true"
 #   Environment = "dev"
 # }
#}


resource "tls_private_key" "webpress" {
  algorithm = "RSA"
}

resource "aws_key_pair" "webpress" {
  key_name   = "webpress-key"
  public_key = tls_private_key.webpress.public_key_openssh
}

output "private_key" {
  description = "The private key data in PEM format"
  value       = tls_private_key.webpress.private_key_pem
  sensitive   = true
}

resource "local_file" "private_key" {
  sensitive = tls_private_key.webpress.private_key_pem
  filename          = var.PRIV_KEY_PATH
}

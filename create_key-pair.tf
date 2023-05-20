resource "tls_private_key" "wordpress" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "wordpress" {
  key_name   = "wordpress-key"
  public_key = tls_private_key.wordpress.public_key_openssh
}

output "private_key" {
  description = "The private key data in PEM format"
  value       = tls_private_key.wordpress.private_key_pem
  sensitive   = true
}

resource "local_sensitive_file" "private_key" {
  content  = tls_private_key.wordpress.private_key_pem
  filename = "/Users/memoor/.ssh/wordpress-key.pem"

}


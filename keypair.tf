resource "tls_private_key" "priv_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.priv_key.public_key_openssh

  provisioner "local-exec" {
    command = "rm -f ~/.ssh/'${var.key_name}'.pem"
  }

  provisioner "local-exec" {
    command = "echo '${tls_private_key.priv_key.private_key_pem}' > ~/.ssh/'${var.key_name}'.pem"
  }

  provisioner "local-exec" {
    command = "chmod 400 ~/.ssh/'${var.key_name}'.pem"
  }
}
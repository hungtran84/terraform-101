provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.region
}

resource "aws_default_vpc" "default" {}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow ssh and http port"
  vpc_id      = aws_default_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
    ami                    = "ami-0c2b8ca1dad447f8a"
    instance_type          = "t2.micro"
    key_name               = var.key_name
    vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]
    user_data = <<EOF
        #!/bin/bash
        yum update -y
        yum install -y httpd
        systemctl start httpd
        echo "<h1>Welcome home, Cristiano</h1>" | tee /var/www/html/index.html
    EOF
    tags = {
        Name = "Web-server"	
        Owner = "HungTS"
    }

}

provider "aws" {
  region = "us-east-1"
}

resource "aws_key_pair" "project_key" {
  key_name   = "projectkeyPair"
  public_key = file("${path.module}/projectkeyPair.pub")
}




resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
  description = "Allow HTTP and SSH"

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
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "web" {
  ami                    = "ami-08a6efd148b1f7504"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.project_key.key_name
  vpc_security_group_ids = [aws_security_group.allow_http_ssh.id]

  tags = {
    Name = "DevOpsMiniWeb1"
  }

  provisioner "local-exec" {
    command = "echo ${self.public_ip} > ../instance_ip.txt"
  }
}


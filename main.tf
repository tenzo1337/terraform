provider "aws" {
  profile = "default"
  region  = "eu-west-2"
}

resource "aws_key_pair" "ssh_key" {
  key_name   = "ssh_key"
  public_key = file("~/.ssh/id_rsa_aws.pub")
}

#TODO: Attach mydemo sg to app_server instance.
resource "aws_instance" "app_server" {
  ami           = "ami-0b1b00f4f0d09d131"
  instance_type = "t2.micro"
  user_data     = file("userdata.tpl")
  key_name      = aws_key_pair.ssh_key.key_name

  tags = {
    Name = var.instance_name
  }
}

# Default VPC
resource "aws_default_vpc" "default" {

}

# Security group
resource "aws_security_group" "mydemo" {
  name        = "mydemo"
  description = "allow ssh on 22 & http on port 80"

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


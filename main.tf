# Terraform configuration

provider "aws" {
  region = "ap-south-1"
}
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "172.20.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
  private_subnets = ["172.20.10.0/24"]
  public_subnets  = ["172.20.20.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}
resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow http inbound traffic"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "http from VPC"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [module.vpc.vpc_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_http"
  }
}
resource "aws_instance" "web"{

  count         = 2

  ami                    = "${var.ami}"
  instance_type          = "${var.instance_type}"
  monitoring             = true
  key_name		 = dev
  vpc_security_group_ids = [module.vpc.default_security_group_id]
  subnet_id              = module.vpc.public_subnets[0]

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  provisioner "file" {
    source      = "/root/dev.pem"
}
  connection {
    type = "ssh"
    user        = "ec2-user"
    private_key = "${file("/root/dev.pem")}"
    host = "aws_instance.instance.private_ip"
  }
  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y docker",
      "sudo service docker start",
      "sudo usermod -a -G docker ec2-user",
      "docker pull arvindpathare/springio:latest",
      "docker run -d -p 8082:8080 arvindpathare/springio:latest",
    ]
  }
}


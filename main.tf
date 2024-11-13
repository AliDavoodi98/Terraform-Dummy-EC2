provider "aws" {
  region = "us-east-1"
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true 

  filter {
    name = "name"
    values = [ "ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*" ]
  }

  owners = [ "amazon" ]
}

data "http" "my_ip" {
  url = "https://ifconfig.me/ip"
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"

  tags = {
    "Name" = "Main EC2"
  }
}

resource "aws_security_group" "allow_ssh" {
  name = "sg_allow_ssh"
  description = "This Security Group should allow SSH connection from the main host to the EC2 Instance"
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sg_allow_ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.allow_ssh.id
  cidr_ipv4 = "${data.http.my_ip.body}/32"
  from_port = 22
  ip_protocol = "ssh"
  to_port = 22
}
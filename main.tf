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


resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"

  tags = {
    "Name" = "Main EC2"
  }
}
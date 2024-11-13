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

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
}

resource "aws_instance" "ec2" {
  ami = data.aws_ami.ubuntu_ami.id
  instance_type = "t3.micro"
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.allow_ssh.id]
  key_name = "macbook_air_pair"

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
  ip_protocol = "tcp"
  to_port = 22
}

output "ec2_private_IP" {
  value = aws_instance.ec2.private_ip
}
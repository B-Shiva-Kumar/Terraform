# provider requirements
provider "aws" {
  region = var.region
}

# AWS VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.cidr_vpc
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "tf-vpc"
  }

}

# AWS IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
}

# AWS VPC SUBNET
resource "aws_subnet" "subnet_public" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.cidr_subnet
}


# AWS ROUTE TABLE
resource "aws_route_table" "rtb_public" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = var.cidr_block
    gateway_id = aws_internet_gateway.igw.id
  }
}


# AWS ROUTE TABLE ASSOCIATION WITH SUBNET
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id         = aws_subnet.subnet_public.id
  route_table_id = aws_route_table.rtb_public.id
}


# AWS SECUROTY GROUP
resource "aws_security_group" "sg_22_80" {
  name   = "sg_22"
  vpc_id = aws_vpc.vpc.id

  # SSH access from VPC
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  # port 8080
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  # http port 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [var.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.cidr_block]
  }
}

# aws_ami data source
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# data "template" "user_data" {
#   template = file("../scripts/initial_setup.sh")
# }

# AWS INSTANCE
resource "aws_instance" "tf-practise" {
  # ami                         = var.ami_id
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.subnet_public.id
  vpc_security_group_ids      = [aws_security_group.sg_22_80.id]
  associate_public_ip_address = true
  # user_data                   = file("../scripts/apache_server_script.sh")
  user_data                   = file("../scripts/initial_setup.sh")
  # user_data                   = data.template.user_data.rendered


  tags = {
    Name = "tf-practise"
  }
}
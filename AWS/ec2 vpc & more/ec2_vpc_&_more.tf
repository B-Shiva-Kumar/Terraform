# Configure required details using "aws cli"

# AWS Access Key ID [None]: -
# AWS Secret Access Key [None]: -
# Default region name [None]: -
# Default output format [None]: allowable [text, table, json(default)]

# This template creates EC2 instance within a VPC & other components.
# web server installed already.
# so, you can directly use public IP address to see the output.

# create vpc with defualt tenancy
resource "aws_vpc" "dev_vpc" {
  cidr_block           = "99.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dev-env-vpc"
  }
}

# private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id     = aws_vpc.dev_vpc.id
  cidr_block = "99.0.1.0/24"

  tags = {
    Name = "private_subnet"
  }
}

# public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id = aws_vpc.dev_vpc.id
  # availability_zone = "ap-south-1b"
  cidr_block = "99.0.2.0/24"

  tags = {
    Name = "public_subnet"
  }
}

# internet gateway
resource "aws_internet_gateway" "dev_vpc_igw" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
    Name = "dev_vpc_igw"
  }
}

# elastic IP for NAT gateway
resource "aws_eip" "ip" {
  vpc = true
}

# NAT gateway attached with elastic IP & private subnet
# time creation for NAT_gw is amlost 1m50s
resource "aws_nat_gateway" "NAT_gw" {
  allocation_id = aws_eip.ip.id
  subnet_id     = aws_subnet.private_subnet.id

  tags = {
    Name = "NAT_gw"
  }
}

# custom rt
resource "aws_route_table" "rt1" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    # cidr_block = "99.0.1.0/24"
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.dev_vpc_igw.id
  }

  tags = {
    Name = "custom_rt"
  }
}

# main rt
resource "aws_route_table" "rt2" {
  vpc_id = aws_vpc.dev_vpc.id

  route {
    # cidr_block = "99.0.1.0/24"
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.NAT_gw.id
  }

  tags = {
    Name = "main"
  }
}

# subnet association for rt1
resource "aws_route_table_association" "pub_sbnt_rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.rt1.id
}

# subnet association for rt2
resource "aws_route_table_association" "pri_sbnt_rt" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.rt2.id
}

# security group
resource "aws_security_group" "sg" {
  name        = "first-sg"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.dev_vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.dev-vpc.ipv6_cidr_block]
  }

  ingress {
    description = "TLS from VPC"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = [aws_vpc.dev-vpc.ipv6_cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    # ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "first-sg"
  }
}


# ec2 instance creation

resource "aws_instance" "tf_instance" {
  ami           = "ami-0e6329e222e662a52"
  instance_type = "t2.micro"
  key_name      = aws_key_pair.key.id


  subnet_id                   = aws_subnet.public_subnet.id
  vpc_security_group_ids      = [aws_security_group.sg.id]
  associate_public_ip_address = true

  # $(curl https://api.kanye.rest/?format=text)
  user_data = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install nginx1 -y
  echo "<h1>Hi there, This is SHIVA KUMAR B</h1> 
  <h1>Hello world from $(hostname) $(hostname -i)</h1>" >  /usr/share/nginx/html/index.html 
  systemctl enable nginx
  systemctl start nginx
  EOF

  tags = {
    "Name" : "tf-instance"
  }
}

# to generate public key -> goto power shell -> type "ssh-keygen"
resource "aws_key_pair" "key" {
  key_name   = "tf-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpw1GbI3R5CUPvfufWCB6y2MGmU/V3YE576jQ8Y7peKxdfwcNN12crq9TUGJn+nR2BJAMN4wp2fHTk2VXSKtBJBKrHH8SOcQMIGHa7AabBImcM8cISe3viNJmwTcebpoalR6yysSQrbkbwqQIf8fj7VRLH4SN/CiKbhI6hMyLHeNAj8PJH9mLNCznNADFbEOAqt2txoZOAMVBYPA7KW9o/2AT+GowzJD7/v/6sq5zaojFud6APKk2haw95+RVPKdCLp9+48uRxkxLxkXuDXMkbehdzAG2uuk2ewo/CNWnyL67Y4wlVel71jq/w05/Xoeun44+y3QH0RJuJ10Q5ByWJHNqRFW4E6L+63vbaY94GUmicG+8qLYdFCXqrzj5O4mhxDWnMFWJIf0mvDf8rJk2bdCMB7/uZT/uC3EK/+5sW++afyT/66pI83bSKeamDN+Q/l8IonOFnJK2641Cukht7SpuH1hIYRD4lpx1bbaXQERxQXg72DXLOG5Yo7nJQ5mc= shiva kumar b@DESKTOP-70VC86E"
}

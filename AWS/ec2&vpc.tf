# credits & reference : https://www.sammeechward.com/terraform-vpc-subnets-ec2-and-more

# This will create ce2 within configured custom vpc
# included user data script -> you can access public IP directly & see a webpage
# configure AWS provider
provider "aws" {
  # profile = "default"
  region  = "us-east-1"
  access_key = "AKIAWAPUKA7KQ4R3WSEY"
  secret_key = "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"
}

# 1. Create VPC
resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Some Custom VPC"
  }
}


# 2. Create subnets for different parts of the infrastructure
# This will setup a new VPC with the cidr block 10.0.0.0/16 and the name “Some Custom VPC”.

# This will create two new subnets in az 1a with the cidr blocks 10.0.1.0/24 and 10.0.2.0/24. 
# We need to use the VpcId from the previous step.
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Some Public Subnet"
  }
}

resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Some Private Subnet"
  }
}


# 3. Attach an internet gateway to the VPC
# Resource: aws_internet_gateway

# This creates an internet gateway and attaches it to the custom VPC. 
# Now we need a route table to handle routing to one or more of the subnets.
resource "aws_internet_gateway" "some_ig" {
  vpc_id = aws_vpc.some_custom_vpc.id

  tags = {
    Name = "Some Internet Gateway"
  }
}


# 4. Create a route table for a public subnet
# Resource: aws_route_table

# This will create a new route table on the custom vpc. 
# We can also specify the routes to route internet traffic through the gateway. 
# So the route table and internet gateway are setup on The VPC, 
# now we just need to assiociate any public subnets with the route table.
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.some_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"  // ipv4
    gateway_id = aws_internet_gateway.some_ig.id
  }

  route {
    ipv6_cidr_block = "::/0"  // ipv6
    gateway_id      = aws_internet_gateway.some_ig.id
  }

  tags = {
    Name = "Public Route Table"
  }
}

# Resource: aws_route_table_association
# Now some_public_subnet is accessible over the public internet.
resource "aws_route_table_association" "public_1_rt_a" {
  subnet_id      = aws_subnet.some_public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


# 5. Create security groups to allow specific traffic
# Resource: aws_security_group
# Before we setup a new EC2 instance on the public subnet, 
# we need to create a security group that allows internet traffic on port 80 and 22. 
# We’ll also allow outgoing traffic on all ports.
resource "aws_security_group" "web_sg" {
  name   = "HTTP and SSH"
  vpc_id = aws_vpc.some_custom_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
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


# 6. Create ec2 instances on the subnets
# Time to deploy an EC2 instance. 
# If you already have an ssh keypair setup, you can just use that and skip the next step. 
# If you haven’t, or if you want to setup a new ssh key for this instance, 
# run the following command using the aws cli.
# aws ec2 create-key-pair --key-name MyKeyPair --query 'KeyMaterial' --output text > ~/.ssh/MyKeyPair.pem
# chmod 400  ~/.ssh/MyKeyPair.pem

# Resource: aws_instance
# This sets up a new Amazon Linux 2 ec2 instance with nginx installed. 
# The default home page will display a random Kanye West quote.
resource "aws_instance" "web_instance" {
  ami           = "ami-0533f2ba8a1995cf9"
  instance_type = "t2.micro"
  # key_name      = "MyKeyPair"

  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  
  # $(curl https://api.kanye.rest/?format=text)
  user_data = <<-EOF
  #!/bin/bash -ex

  amazon-linux-extras install nginx1 -y
  echo "<h1>Hi there, This is SHIVA KUMAR B</h1>" >  /usr/share/nginx/html/index.html 
  systemctl enable nginx
  systemctl start nginx
  EOF

  tags = {
    "Name" : "tf-instance"
  }
}
## Terraform basics

# AWS configuring inside tf file
# we can also configure using AWS CLI with aws cinfigure

provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWAPUKA7KYQXNHS2F"
  secret_key = "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"
}


# AWS instance

resource "aws_instance" "my_first_instance" {
  # automatic AMIs provides
    ami           = "Hardcoded AMI value"
    instance_type = "t2.micro"
     tags = {
      Name = "ubuntu-server"
     }
}


# AWS instance with default AMI id

resource "aws_instance" "my_first_instance" {
  # automatic AMIs provides
    ami           = "${data.aws_ami.latest-ubuntu.id}"
    instance_type = "t2.micro"
     tags = {
      Name = "ubuntu-server"
     }
}

data "aws_ami" "latest-ubuntu" {
most_recent = true
owners = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}




S3 bucket creation:

resource "aws_s3_bucket" "demos3" {
    bucket = "bucket-442"
    acl    = "private"
}





Multipile instance creation using count:

resource "aws_instance" "testserver" {
  ami           = "ami-026b57f3c383c2eec"
  instance_type = "t2.micro"
count = 5
}






EBS Volume creation:

resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1b"
  size              = 40


 tags = {
    Name = "HelloWorld"
  }
}




EBS Volume Attachement to EC2:



resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.example.id
  instance_id = aws_instance.web.id
}



resource "aws_instance" "web" {
  ami               = "ami-026b57f3c383c2eec"
  availability_zone = "us-east-1b"
  instance_type     = "t2.micro"



 tags = {
    Name = "HelloWorld"
  }
}



resource "aws_ebs_volume" "example" {
  availability_zone = "us-east-1b"
  size              = 1
}
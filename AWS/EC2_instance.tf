provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWAPUKA7KYQXNHS2F"
  secret_key = "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"
}

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
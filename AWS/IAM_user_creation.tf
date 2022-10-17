provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWAPUKA7KYQXNHS2F"
  secret_key = "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"
}


resource "aws_iam_user" "lb" {
  name = "loadbalancer"
  path = "/system/"

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_user" "lb1" {
  name = "http-balancer"
  path = "/system/"

  tags = {
    email = "softy@softy.gov"
  }
}
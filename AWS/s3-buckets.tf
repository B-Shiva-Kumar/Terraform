# # configure AWS provider
provider "aws" {
  # profile = "default"
  region  = "ap-south-1"
  access_key = "AKIAWAPUKA7KQ4R3WSEY"
  secret_key = "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"
}

# Private bucket with versioning enabled
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "my-s3-bucket-20222324"
  acl    = "private"

  versioning = {
    enabled = true
  }

}
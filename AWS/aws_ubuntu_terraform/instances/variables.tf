# variable "ami_id" {
#   description = "AMI ID -> us-west-2 region"
#   default     = "ami-095413544ce52437d"
# }

variable "cidr_vpc" {
  description = "CIDR block for the VPC"
  default     = "10.1.0.0/16"
}

variable "cidr_subnet" {
  description = "CIDR block for subnet"
  default     = "10.1.0.0/24"
}

variable "cidr_block" {
  description = "CIDR block value"
  default     = "0.0.0.0/0"
}

variable "environment_tag" {
  description = "Environment tag"
  default     = "Learn"
}

variable "region" {
  description = "The region Terraform deploys your instance"
}

variable "instance_type" {
  description = "Type of Instance"
  default     = "t2.micro"
}
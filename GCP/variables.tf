# This file defines four variables within your Terraform configuration. 
# The project and credentials_file variables have an empty block: { }. 
# The region and zone variables set defaults. If a default value is set, the variable is optional. Otherwise, the variable is required. 
# If you run terraform plan now, Terraform will prompt you for the values for project and credentials_file.
# Variables are referenced with the var. prefix in main.tf configuration file.

variable "project" { }

variable "credentials_file" { }

variable "region" {
  default = "us-west4"
}

variable "zone" {
  default = "us-west4-b"
}

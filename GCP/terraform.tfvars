# Terraform automatically loads files called terraform.tfvars 
# or matching *.auto.tfvars in the working directory when running operations.

# Warning: 
# In other configurations, you may store credentials in the terraform.tfvars file. 
# Never commit sensitive values into source control.

project                  = "<project-id>"
credentials_file         = "<key-file-name-created-from-service-account-in-IAM>.json"

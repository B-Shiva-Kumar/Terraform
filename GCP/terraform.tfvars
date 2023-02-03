# Terraform automatically loads files called terraform.tfvars 
# or matching *.auto.tfvars in the working directory when running operations.

# Warning: 
# In other configurations, you may store credentials in the terraform.tfvars file. 
# Never commit sensitive values into source control.

project                  = "hip-fusion-376308"
credentials_file         = "gcp_key_file.json"

# Configuring AWS
provider "aws" {
  region     = "ap-south-1"
  access_key = "AKIAWAPUKA7KYQXNHS2F"
  secret_key = "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"
}

# To create AWS lamda function in terraform
# we need to create following create following resources

# 1. aws_iam_role
# 2. aws_iam_policy
# 3. aws_iam_role_policy_attachment
# 4. data "archive_file"
# 5. aws_lamda function


# 1. aws_iam_role 
resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_role_for_lambda"

  assume_role_policy = <<EOF
  { 
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "lambda.amazonaws.com"
                },

                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF
}

# 2. aws_iam_policy
resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws `iam_for_lambda`"

#   policy = <<EOF
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            
            "Resource": "arn:aws:logs:*:*:*",
            "Effect": "Allow"
        }
    ]
})
# EOF
}


# 3. aws_iam_role_policy_attachment
resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
    role        = aws_iam_role.iam_for_lambda.name
    policy_arn  = aws_iam_policy.iam_policy_for_lambda.arn
}


# 4. data "archive_file"
data "archive_file" "zip_the_python_code" {
    type        = "zip"
    source_dir  = "${path.module}/sample_programs/"
    output_path = "${path.module}/sample_programs/py_function.zip"
}


# 5. aws_lamda function
resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a
  # path.module in the filename.
  filename      = "${path.module}/sample_programs/py_function.zip"
  function_name = "aws_lamda_function_demo"
  role          = aws_iam_role.iam_for_lambda.arn
  handler       = "py_function.lamda_handler"
  # handler - (Optional) Function entrypoint in your code.
  
  runtime       = "python3.8"
  depends_on    = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}
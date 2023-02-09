# OUTPUTS
output "public_ip" {
  value = aws_instance.tf-practise.public_ip
}

output "availability_zone" {
  value = aws_instance.tf-practise.availability_zone
}

output "vpc_name" {
  value = aws_vpc.vpc.tags.Name
}

output "vpc_id" {
  value = aws_vpc.vpc.id  
}
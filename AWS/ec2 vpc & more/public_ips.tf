# output variable
# In terminal we can see output vars -> public ip
output "instance_ip_addr" {
  value = aws_instance.tf_instance.public_ip
}
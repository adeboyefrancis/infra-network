#############################################
# Network Outputs
#############################################
output "main_vpc" {
  value = aws_vpc.main_vpc.id
}

output "public_subnets" {
  value = [for subnet in aws_subnet.public_subnets : subnet.id]
}

output "private_subnets" {
  value = [for subnet in aws_subnet.private_subnets : subnet.id]
}

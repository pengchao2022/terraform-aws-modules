output "vpc_id" {
  value = aws_vpc.main.id 
}

output "vpc_name" {
  value = aws_vpc.main.tags["Name"]
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private[*].id  
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat[*].id 
}


output "nat_gateway_ids" { 
  value = aws_nat_gateway.nat[*].id
}

output "nat_gateway_eips" {
  value = aws_eip.nat[*].public_ip
}

output "endpoint_security_group_id" {
  description = "The ID of the security group for VPC Endpoint"
  value       = aws_security_group.endpoint_sg.id
}

output "private_route_table_ids" {
  description = "The IDs of the private route tables"
  value       = aws_route_table.private[*].id
}

output "public_route_table_ids" {
  value = aws_route_table.public[*].id
}

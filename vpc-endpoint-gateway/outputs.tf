output "endpoint_id" {
  description = "The ID of the Gateway VPC Endpoint"
  value       = aws_vpc_endpoint.gateway.id
}

output "endpoint_prefix_list_id" {
  description = "The prefix list ID of the Gateway endpoint, useful for security group rules"
  value       = aws_vpc_endpoint.gateway.prefix_list_id
}
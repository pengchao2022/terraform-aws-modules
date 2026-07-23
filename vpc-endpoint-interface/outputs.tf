output "endpoint_id" {
  description = "The ID of the Interface VPC Endpoint"
  value       = aws_vpc_endpoint.interface.id
}

output "network_interface_ids" {
  description = "One or more network interface IDs for the Interface VPC Endpoint"
  value       = aws_vpc_endpoint.interface.network_interface_ids
}

output "dns_entries" {
  description = "The DNS entries for the Interface VPC Endpoint"
  value       = aws_vpc_endpoint.interface.dns_entry
}
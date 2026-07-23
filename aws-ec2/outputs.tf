output "instance_ids" {
  value = { for k, v in aws_instance.web_server : k => v.id }
}

output "public_ips" {
  value = { for k, v in aws_instance.web_server : k => v.public_ip }
}

output "private_ips" {
  description = "All the EC2 internal IP"
  value       = { for k, v in aws_instance.web_server : k => v.private_ip }
}

output "s2s_vpn_tunnel1_address" {
  description = "Site-to-Site VPN Tunnel 1 的 AWS 公网 IP"
  value       = var.enable_s2s_vpn ? aws_vpn_connection.s2s_vpn[0].tunnel1_address : null
}

output "s2s_vpn_preshared_key" {
  description = "Site-to-Site VPN Tunnel 1 的预共享密钥 (PSK)"
  value       = var.enable_s2s_vpn ? aws_vpn_connection.s2s_vpn[0].tunnel1_preshared_key : null
  sensitive   = true
}


output "client_vpn_endpoint_id" {
  description = "Client VPN Endpoint ID"
  value       = var.enable_client_vpn ? aws_ec2_client_vpn_endpoint.client_vpn[0].id : null
}

output "client_vpn_dns_name" {
  description = "Client VPN Endpoint DNS Name"
  value       = var.enable_client_vpn ? aws_ec2_client_vpn_endpoint.client_vpn[0].dns_name : null
}

output "client_cert_pem" {
  description = "动态生成的 Client 证书内容"
  value       = var.enable_client_vpn ? tls_locally_signed_cert.client[0].cert_pem : null
  sensitive   = true
}

output "client_key_pem" {
  description = "动态生成的 Client 证书私钥"
  value       = var.enable_client_vpn ? tls_private_key.client[0].private_key_pem : null
  sensitive   = true
}

output "ovpn_config_file_path" {
  description = "自动生成的 .ovpn 配置文件本地路径"
  value       = var.enable_client_vpn ? local_file.ovpn_config[0].filename : null
}
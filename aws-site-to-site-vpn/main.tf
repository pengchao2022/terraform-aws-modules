# AWS Client VPN 配置 (本地电脑远程接入)
# PKI 证书生成
resource "tls_private_key" "ca" {
  count     = var.enable_client_vpn ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_self_signed_cert" "ca" {
  count           = var.enable_client_vpn ? 1 : 0
  private_key_pem = tls_private_key.ca[0].private_key_pem
  subject {
    common_name  = "${var.name_prefix}.vpn.ca"
    organization = var.organization_name
  }
  validity_period_hours = 87600
  is_ca_certificate     = true
  allowed_uses          = ["cert_signing", "crl_signing"]
}

resource "tls_private_key" "server" {
  count     = var.enable_client_vpn ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "server" {
  count           = var.enable_client_vpn ? 1 : 0
  private_key_pem = tls_private_key.server[0].private_key_pem
  subject {
    common_name  = "${var.name_prefix}.vpn.internal"
    organization = var.organization_name
  }
}

resource "tls_locally_signed_cert" "server" {
  count              = var.enable_client_vpn ? 1 : 0
  cert_request_pem   = tls_cert_request.server[0].cert_request_pem
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem
  validity_period_hours = 87600
  allowed_uses       = ["key_encipherment", "digital_signature", "server_auth"]
}

resource "tls_private_key" "client" {
  count     = var.enable_client_vpn ? 1 : 0
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "tls_cert_request" "client" {
  count           = var.enable_client_vpn ? 1 : 0
  private_key_pem = tls_private_key.client[0].private_key_pem
  subject {
    common_name  = var.client_common_name
    organization = var.organization_name
  }
}

resource "tls_locally_signed_cert" "client" {
  count              = var.enable_client_vpn ? 1 : 0
  cert_request_pem   = tls_cert_request.client[0].cert_request_pem
  ca_private_key_pem = tls_private_key.ca[0].private_key_pem
  ca_cert_pem        = tls_self_signed_cert.ca[0].cert_pem
  validity_period_hours = 87600
  allowed_uses       = ["key_encipherment", "digital_signature", "client_auth"]
}

# ACM 导入
resource "aws_acm_certificate" "server_cert" {
  count             = var.enable_client_vpn ? 1 : 0
  private_key       = tls_private_key.server[0].private_key_pem
  certificate_body  = tls_locally_signed_cert.server[0].cert_pem
  certificate_chain = tls_self_signed_cert.ca[0].cert_pem
}

resource "aws_acm_certificate" "client_cert" {
  count             = var.enable_client_vpn ? 1 : 0
  private_key       = tls_private_key.client[0].private_key_pem
  certificate_body  = tls_locally_signed_cert.client[0].cert_pem
  certificate_chain = tls_self_signed_cert.ca[0].cert_pem
}

resource "aws_cloudwatch_log_group" "client_vpn" {
  count             = var.enable_client_vpn ? 1 : 0
  name              = "/aws/client-vpn/${var.name_prefix}-connection-logs"
  retention_in_days = 7
}

resource "aws_ec2_client_vpn_endpoint" "client_vpn" {
  count                  = var.enable_client_vpn ? 1 : 0
  description            = "${var.name_prefix} Client VPN Endpoint"
  client_cidr_block      = var.client_vpn_cidr
  server_certificate_arn = aws_acm_certificate.server_cert[0].arn
  transport_protocol     = "tcp"
  split_tunnel           = true

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = aws_acm_certificate.client_cert[0].arn
  }

  connection_log_options {
    enabled              = true
    cloudwatch_log_group = aws_cloudwatch_log_group.client_vpn[0].name
  }

  tags = merge(var.tags, { Name = "${var.name_prefix}-client-vpn" })
}

# 关联子网
resource "aws_ec2_client_vpn_network_association" "client_vpn_assoc" {
  count                  = var.enable_client_vpn ? length(var.target_subnet_ids) : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[0].id
  subnet_id              = var.target_subnet_ids[count.index]
}

# 授权规则（允许访问目标 VPC 网段）
resource "aws_ec2_client_vpn_authorization_rule" "client_vpn_auth" {
  count                  = var.enable_client_vpn ? 1 : 0
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.client_vpn[0].id
  target_network_cidr    = var.vpc_cidr_block
  authorize_all_groups   = true

  timeouts {
    create = "20m"
  }
}

# 生成客户端 .ovpn 配置文件
resource "local_file" "ovpn_config" {
  count    = var.enable_client_vpn ? 1 : 0
  filename = "${path.root}/${var.name_prefix}-client.ovpn"
  content  = <<EOF
client
dev tun
proto tcp
remote ${replace(aws_ec2_client_vpn_endpoint.client_vpn[0].dns_name, "*.", "${var.name_prefix}.")} 443
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
verb 3
reneg-sec 0

<ca>
${tls_self_signed_cert.ca[0].cert_pem}
</ca>
<cert>
${tls_locally_signed_cert.client[0].cert_pem}
</cert>
<key>
${tls_private_key.client[0].private_key_pem}
</key>
EOF
}

# TGW Site-to-Site VPN 配置 (机房/分支机构互联)
resource "aws_customer_gateway" "cgw" {
  count      = var.enable_s2s_vpn ? 1 : 0
  bgp_asn    = 65000
  ip_address = var.customer_public_ip
  type       = "ipsec.1"
  tags       = merge(var.tags, { Name = "${var.name_prefix}-cgw" })
}

resource "aws_vpn_connection" "s2s_vpn" {
  count               = var.enable_s2s_vpn ? 1 : 0
  transit_gateway_id  = var.transit_gateway_id 
  customer_gateway_id = aws_customer_gateway.cgw[0].id
  type                = "ipsec.1"
  static_routes_only  = true

  tunnel1_startup_action = "add"
  tunnel2_startup_action = "add"

  tags = merge(var.tags, { Name = "${var.name_prefix}-s2s-vpn" })
}

resource "aws_ec2_transit_gateway_route" "s2s_vpn_route" {
  count                          = var.enable_s2s_vpn ? 1 : 0
  destination_cidr_block         = var.s2s_local_subnet_cidr
  transit_gateway_attachment_id  = aws_vpn_connection.s2s_vpn[0].transit_gateway_attachment_id
  transit_gateway_route_table_id = var.tgw_route_table_id
}
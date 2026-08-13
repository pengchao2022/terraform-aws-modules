resource "aws_vpc_endpoint" "interface" {
  vpc_id              = var.vpc_id
  service_name        = var.service_name
  vpc_endpoint_type   = "Interface"

  subnet_ids          = var.subnet_ids
  security_group_ids  = var.security_group_ids
  
  private_dns_enabled = var.private_dns_enabled

  dynamic "dns_options" {
    for_each = var.dns_options != null ? [var.dns_options] : []
    content {
      dns_record_ip_type                            = lookup(dns_options.value, "dns_record_ip_type", null)
      private_dns_only_for_inbound_resolver_endpoint = lookup(dns_options.value, "private_dns_only_for_inbound_resolver_endpoint", null)
    }
  }

  tags = merge(
    {
      Name        = "${var.environment}-vpc-endpoint-${split(".", var.service_name)[3]}"
      Environment = var.environment
    },
    var.tags
  )
}
resource "aws_vpc_endpoint" "gateway" {
  vpc_id              = var.vpc_id
  service_name        = "com.amazonaws.${var.region}.${var.service_name}"
  vpc_endpoint_type   = "Gateway"

  route_table_ids     = var.route_table_ids

  tags = merge(
    {
      Name           = "${var.environment}-vpc-endpoint-${var.service_name}-gateway"
      Environment    = var.environment
    },
    var.additional_tags
  )
}
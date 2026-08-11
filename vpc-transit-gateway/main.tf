# 1. 创建 Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  description                     = "Transit Gateway for ${var.name}"
  amazon_side_asn                 = var.amazon_side_asn
  auto_accept_shared_attachments  = "enable"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tgw"
    }
  )
}

# 2. 创建 VPC Attachments (动态遍历传入的 VPC)
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each = var.vpc_attachments

  transit_gateway_id = aws_ec2_transit_gateway.this.id
  vpc_id             = each.value.vpc_id
  subnet_ids         = each.value.subnet_ids

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tgw-attachment-${each.key}"
    }
  )
}

# 3. 展开路由表与 CIDR 的映射关系，用于创建本地路由
locals {
  vpc_routes = flatten([
    for vpc_key, vpc_config in var.vpc_attachments : [
      for rt_id in vpc_config.route_table_ids : {
        key              = "${vpc_key}-${rt_id}"
        route_table_id   = rt_id
        destination_cidr = vpc_config.destination_cidr
        attachment_key   = vpc_key
      }
    ]
  ])
}

# 4. 在各个 VPC 的路由表中添加指向 TGW 的路由
resource "aws_route" "tgw_routes" {
  for_each = {
    for route in local.vpc_routes : route.key => route
  }

  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination_cidr
  transit_gateway_id     = aws_ec2_transit_gateway.this.id

  depends_on = [
    aws_ec2_transit_gateway_vpc_attachment.this
  ]
}
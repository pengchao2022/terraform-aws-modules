# 创建 Transit Gateway
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

# 创建 VPC Attachments (动态遍历传入的 VPC)
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

# 展开路由表与多个 CIDR 的映射关系，用于创建本地路由
locals {
  vpc_routes = flatten([
    for vpc_key, vpc_config in var.vpc_attachments : [
      for i, rt_id in vpc_config.route_table_ids : [
        for j, cidr in vpc_config.destination_cidrs : {
          # 使用普通的循环计数器 i 和 j 作为后缀，避开解析器误判
          key              = "${vpc_key}-rt${i}-${replace(cidr, "/", "-")}"
          route_table_id   = rt_id
          destination_cidr = cidr
          attachment_key   = vpc_key
        }
      ]
    ]
  ])
}

# 在各个 VPC 的路由表中添加指向 TGW 的路由
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

# 创建 CloudWatch Log Group
resource "aws_cloudwatch_log_group" "tgw_logs" {
  name              = "/aws/transit-gateway/${var.name}-tgw-flow-logs"
  retention_in_days = 7

  tags = var.tags
}

# 创建 IAM 角色，允许 Flow Logs 服务向 CloudWatch 写入日志
resource "aws_iam_role" "tgw_flow_log_role" {
  name = "${var.name}-tgw-flow-log-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "vpc-flow-logs.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}

# 为 IAM 角色附加写入 CloudWatch 的权限策略
resource "aws_iam_role_policy" "tgw_flow_log_policy" {
  name = "${var.name}-tgw-flow-log-policy"
  role = aws_iam_role.tgw_flow_log_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 创建 TGW 级别的 Flow Log，将流量捕获并发送至 CloudWatch
resource "aws_flow_log" "tgw_flow_log" {
  transit_gateway_id       = aws_ec2_transit_gateway.this.id
  log_destination_type     = "cloud-watch-logs"
  log_destination          = aws_cloudwatch_log_group.tgw_logs.arn
  iam_role_arn             = aws_iam_role.tgw_flow_log_role.arn
  traffic_type             = "ALL"
  max_aggregation_interval = 60 # TGW 关联的 flow log 要求必须是 60 秒

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-tgw-flow-log"
    }
  )

  depends_on = [
    aws_iam_role_policy.tgw_flow_log_policy
  ]
}
# 动态获取当前 Requester 所在的 Region
data "aws_region" "current" {}

locals {
  # 判断输入的 accepter_region 是否与当前 Region 不同（不同即为跨区域）
  is_cross_region = var.accepter_region != data.aws_region.current.region
}

# 1. 创建 Peering 连接
resource "aws_vpc_peering_connection" "peer" {
  vpc_id      = var.requester_vpc_id
  peer_vpc_id = var.accepter_vpc_id
  
  # 如果是同 Region，直接请求端自动接受；跨 Region 则不能直接 auto_accept
  peer_region = local.is_cross_region ? var.accepter_region : null
  auto_accept = !local.is_cross_region

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-peering"
    }
  )
}

# 2. 跨区域时接受连接
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  count = local.is_cross_region ? 1 : 0

  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true

  tags = merge(
    var.tags,
    {
      Name = "${var.name}-peering-accepter"
    }
  )
}

# 3. Requester 路由
resource "aws_route" "requester_routes" {
  count = length(var.requester_route_table_ids)

  route_table_id            = var.requester_route_table_ids[count.index]
  destination_cidr_block    = var.accepter_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  depends_on = [
    aws_vpc_peering_connection.peer
  ]
}

# 4. Accepter 路由
resource "aws_route" "accepter_routes" {
  count = length(var.accepter_route_table_ids)

  route_table_id            = var.accepter_route_table_ids[count.index]
  destination_cidr_block    = var.requester_vpc_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id

  depends_on = [
    aws_vpc_peering_connection.peer
  ]
}
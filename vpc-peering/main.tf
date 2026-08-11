locals {
  is_cross_region = var.accepter_region != null ? true : false
}

# 1. 创建 Peering 连接
resource "aws_vpc_peering_connection" "peer" {
  vpc_id        = var.requester_vpc_id
  peer_vpc_id   = var.accepter_vpc_id
  peer_region   = var.accepter_region
  auto_accept   = !local.is_cross_region

  tags = {
    Name = "${var.name}-peering"
  }
}

# 2. 跨区域时接受连接
resource "aws_vpc_peering_connection_accepter" "peer_accepter" {
  count = local.is_cross_region ? 1 : 0
  
  vpc_peering_connection_id = aws_vpc_peering_connection.peer.id
  auto_accept               = true
  
  tags = {
    Name = "${var.name}-peering-accepter"
  }
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
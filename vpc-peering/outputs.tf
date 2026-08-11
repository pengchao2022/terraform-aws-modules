# 暴露 Peering Connection 的 ID，方便外部引用
output "vpc_peering_connection_id" {
  description = "VPC Peering Connection 的唯一 ID"
  value       = aws_vpc_peering_connection.peer.id
}

# 暴露 Accepter 的 ID (如果存在的话)
output "vpc_peering_accepter_id" {
  description = "VPC Peering Connection Accepter 的 ID"
  value       = length(aws_vpc_peering_connection_accepter.peer_accepter) > 0 ? aws_vpc_peering_connection_accepter.peer_accepter[0].id : null
}

# 暴露连接的状态，方便调试
output "vpc_peering_connection_status" {
  description = "VPC Peering Connection 的状态"
  value       = aws_vpc_peering_connection.peer.accept_status
}
resource "aws_security_group" "rabbitmq" {
  name        = "rabbitmq-sg-${var.environment}"
  description = "Security group for RabbitMQ EC2 instance"
  vpc_id      = var.vpc_id
  
  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name        = "rabbitmq-sg-${var.environment}"
    Environment = var.environment
  }
}

# 客户端应用连接端口 (AMQP)
resource "aws_vpc_security_group_ingress_rule" "amqp" {
  security_group_id = aws_security_group.rabbitmq.id
  description       = "AMQP client connection"
  ip_protocol       = "tcp"
  from_port         = 5672
  to_port           = 5672
  cidr_ipv4         = var.allowed_cidr_blocks[0]
}

# Web 管理后台端口 (Management UI)
resource "aws_vpc_security_group_ingress_rule" "management" {
  security_group_id = aws_security_group.rabbitmq.id
  description       = "RabbitMQ Management UI"
  ip_protocol       = "tcp"
  from_port         = 15672
  to_port           = 15672
  cidr_ipv4         = length(var.allowed_admin_cidr_blocks) > 0 ? var.allowed_admin_cidr_blocks[0] : var.allowed_cidr_blocks[0]
}

# 集群节点间通信端口：EPMD (4369)
resource "aws_vpc_security_group_ingress_rule" "cluster_erlang" {
  security_group_id = aws_security_group.rabbitmq.id
  description       = "Erlang distributed node communication"
  ip_protocol       = "tcp"
  from_port         = 4369
  to_port           = 4369
  cidr_ipv4         = var.allowed_cidr_blocks[0]
}

# 集群节点间通信端口：节点互联 (25672)
resource "aws_vpc_security_group_ingress_rule" "cluster_node" {
  security_group_id = aws_security_group.rabbitmq.id
  description       = "RabbitMQ internal cluster traffic"
  ip_protocol       = "tcp"
  from_port         = 25672
  to_port           = 25672
  cidr_ipv4         = var.allowed_cidr_blocks[0]
}

# 出站规则 (Egress)：允许实例访问外部网络
resource "aws_vpc_security_group_egress_rule" "allow_all_outbound" {
  security_group_id = aws_security_group.rabbitmq.id
  description       = "Allow all outbound traffic"
  ip_protocol       = "-1" # 允许所有协议
  cidr_ipv4         = "0.0.0.0/0"
}
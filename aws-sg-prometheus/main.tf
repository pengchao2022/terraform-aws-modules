resource "aws_security_group" "this" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

# rule 1 prometheus UI 9090
resource "aws_security_group_rule" "prometheus_ui" {
  count                   = var.enable_prometheus_ui ? length(var.allowed_security_group_ids) : 0
  type                    = "ingress"
  from_port               = 9090
  to_port                 = 9090
  protocol                = "tcp"
  security_group_id       = aws_security_group.this.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  description              = "Prometheus server UI/API from sg"
}

resource "aws_security_group_rule" "prometheus_ui_cidr" {
  count              = var.enable_prometheus_ui && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  type               = "ingress"
  from_port          = 9090
  to_port            = 9090
  protocol           = "tcp"
  security_group_id  = aws_security_group.this.id
  cidr_blocks        = var.allowed_cidr_blocks
  description        = "Prometheus UI access from CIDR"
}

# rule 2 node exporter 9100
resource "aws_security_group_rule" "node_sg" {
  count                    = var.enable_node_exporter ? length(var.allowed_security_group_ids) : 0
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  description              = "Node Exporter access from sg"
}

resource "aws_security_group_rule" "node_cidr" {
  count                    = var.enable_node_exporter && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  type                     = "ingress"
  from_port                = 9100
  to_port                  = 9100
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  cidr_blocks              = var.allowed_cidr_blocks
  description              = "Node exporter access from CIDR"
}

# rule 3 Pushgateway 9091
resource "aws_security_group_rule" "push_sg" {
  count                    = var.enable_pushgateway ? length(var.allowed_security_group_ids) : 0
  type                     = "ingress"
  from_port                = 9091
  to_port                  = 9091
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  description              = "Pushgateway access from sg"
}

resource "aws_security_group_rule" "push_cidr" {
  count                    = var.enable_pushgateway && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  type                     = "ingress"
  from_port                = 9091
  to_port                  = 9091
  protocol                 = "tcp"
  security_group_id        = aws_security_group.this.id
  cidr_blocks              = var.allowed_cidr_blocks
  description              = "Pushgateway access from CIDR" 
}

# outbound rule
resource "aws_security_group_rule" "egress_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.this.id
}

resource "aws_security_group" "grafana" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id
  tags        = var.tags
}

# allow from special security group ids
resource "aws_security_group_rule" "grafana_sg" {
  count             = length(var.allowed_security_group_ids)
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.grafana.id
  source_security_group_id = var.allowed_security_group_ids[count.index]
  description       = "Grafana access from sg"
}

# rule allow special network cidrs access
resource "aws_security_group_rule" "grafana_cidr" {
  count             = length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  type              = "ingress"
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
  security_group_id = aws_security_group.grafana.id
  cidr_blocks       = var.allowed_cidr_blocks
  description       = "Grafana access from CIDR"
}

# outbound rule
resource "aws_security_group_rule" "egress_rule" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.grafana.id
}
# 1. 定义 NLB（支持通过 is_internal 切换内网或互联网）
resource "aws_lb" "rabbitmq_nlb" {
  name               = var.is_internal ? "rabbitmq-internal-nlb" : "rabbitmq-internet-nlb"
  internal           = var.is_internal 
  load_balancer_type = "network"
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.tags,
    {
      Name = var.is_internal ? "rabbitmq-internal-nlb" : "rabbitmq-internet-nlb"
    }
  )
}

# 2. 定义 AMQP 业务端口监听 (5672)
resource "aws_lb_listener" "amqp" {
  load_balancer_arn = aws_lb.rabbitmq_nlb.arn
  port              = "5672"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.amqp.arn
  }
}

# 3. 定义 RabbitMQ 管理后台端口监听 (15672)
resource "aws_lb_listener" "management" {
  load_balancer_arn = aws_lb.rabbitmq_nlb.arn
  port              = "15672"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.management.arn
  }
}

# 4. 目标组：5672 (AMQP)
resource "aws_lb_target_group" "amqp" {
  name        = "rabbitmq-amqp-tg"
  port        = 5672
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    port                = "5672"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

# 5. 目标组：15672 (Management)
resource "aws_lb_target_group" "management" {
  name        = "rabbitmq-mgmt-tg"
  port        = 15672
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    protocol            = "TCP"
    port                = "15672"
    interval            = 30
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = var.tags
}

# 6. 将你的 3 台 EC2 注册到 AMQP 目标组
resource "aws_lb_target_group_attachment" "amqp_attach" {
  count            = length(var.rabbitmq_instance_ids)
  target_group_arn = aws_lb_target_group.amqp.arn
  target_id        = var.rabbitmq_instance_ids[count.index]
  port             = 5672
}

# 7. 将你的 3 台 EC2 注册到 Management 目标组
resource "aws_lb_target_group_attachment" "mgmt_attach" {
  count            = length(var.rabbitmq_instance_ids)
  target_group_arn = aws_lb_target_group.management.arn
  target_id        = var.rabbitmq_instance_ids[count.index]
  port             = 15672
}
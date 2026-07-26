# create alb security group for the public internet
resource "aws_security_group" "alb" {
  name        = "${var.project_name}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  ingress {
    description = "Allow HTTP from anywhere"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  ingress {
    description = "Allow HTTPS from anywhere"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  tags = merge(var.tags, {Name = "${var.project_name}-alb-sg"})
  
}

# create application load balancer
resource "aws_lb" "this" {
  name               = "${var.project_name}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(var.tags, {Name = "${var.project_name}-alb"})

}

# create target group specially for EC2 instance
resource "aws_lb_target_group" "this" {
  name         = "${var.project_name}-tg"
  port         = var.target_port
  protocol     = "HTTP"
  vpc_id       = var.vpc_id
  target_type  = "instance"

  health_check {
    enabled                 = true
    path                    = var.health_check_path
    protocol                = "HTTP"
    port                    = "traffic-port"
    interval                = 30
    timeout                 = 5
    healthy_threshold       = 2
    unhealthy_threshold     = 3
    matcher                 = "200-299"
  }
  
  tags = merge(var.tags, {Name = "${var.project_name}-tg"})
}

# create HTTP listener
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "redirect"
    
    redirect {
      port          = "443"
      protocol      = "HTTPS"
      status_code   = "HTTP_301"    # redirect forever
    }
  }
}

# create HTTPS listener
resource "aws_lb_listener" "https" {
  load_balancer_arn   = aws_lb.this.arn
  port                = 443
  protocol            = "HTTPS"
  ssl_policy          = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn     = var.acm_certificate_arn

  default_action {
    type              = "forward"
    target_group_arn  = aws_lb_target_group.this.arn
  }
  
}

# attach EC2 to target group
resource "aws_lb_target_group_attachment" "this" {
  for_each            = var.ec2_targets
  target_group_arn    = aws_lb_target_group.this.arn
  target_id           = each.value
  port                = var.target_port
}
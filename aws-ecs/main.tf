data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "this" {
  name   = var.cluster_name
}

# create task execution role
# let fargate can pull image from ECR
resource "aws_iam_role" "task_exec_role" {
  name   = "${var.service_name}-exec-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "task_exec_role" {
  role        = aws_iam_role.task_exec_role.name
  policy_arn  = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# create policy for cloudwatch
resource "aws_iam_role_policy" "ecs_logs_policy" {
  name = "${var.service_name}-logs-policy"
  role = aws_iam_role.task_exec_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:log-group:/ecs/*"
      }
    ]
  })
}

resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = var.log_retention_days
}


# create task role for containers 
resource "aws_iam_role" "task_role" {
  name = "${var.service_name}-task-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = { Service = "ecs-tasks.amazonaws.com" }
    }]
  })
}

# give the role to connect RDS (Only created if rds_instance_id and db_iam_user are provided)
resource "aws_iam_role_policy" "rds_auth_policy" {
  count  = (var.rds_instance_id != null && var.db_iam_user != null) ? 1 : 0
  name   = "${var.service_name}-rds-auth-policy"
  role   = aws_iam_role.task_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["rds-db:connect"]
      Resource = "arn:aws:rds-db:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:dbuser:${var.rds_instance_id}/${var.db_iam_user}"
    }]
  })
}
  
# task definition
resource "aws_ecs_task_definition" "this" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = [ "FARGATE" ]
  cpu                      = var.cpu
  memory                   = var.memory
  execution_role_arn       = aws_iam_role.task_exec_role.arn
  task_role_arn            = aws_iam_role.task_role.arn

  container_definitions    = jsonencode([{
    name    = var.container_name
    image   = var.container_image
    environment = var.environment_variables
    # container health check
    healthCheck = {
      command     = ["CMD-SHELL", "curl -f http://localhost:${var.health_check_port}/health || exit 1"]
      interval    = 30
      timeout     = 5
      retries     = 3
      startPeriod = 60
    }

    portMappings = [{
      containerPort  = var.container_port
      hostPort       = var.container_port
      protocol       = "tcp"
    }]
    logConfiguration = {
      logDriver  = "awslogs"
      options = {
        "awslogs-group"           = "/ecs/${var.service_name}"
        "awslogs-region"          = data.aws_region.current.region
        "awslogs-stream-prefix"   = "ecs"
        "awslogs-create-group"    = "true"
      }
    }
  }])
}

# create ECS sg
resource "aws_security_group" "ecs_sg" {
  name   = "${var.service_name}-sg"
  vpc_id = var.vpc_id

  # allow the alb sg to access the container port
  ingress {
    from_port          = var.container_port
    to_port            = var.container_port
    protocol           = "tcp"
    security_groups    = [var.lb_security_group_id]
  }

  # allow the container to access internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

# create ECS service
resource "aws_ecs_service" "this" {
  name             = var.service_name
  cluster          = aws_ecs_cluster.this.id
  task_definition  = aws_ecs_task_definition.this.arn
  desired_count    = null
  launch_type      = var.launch_type

  network_configuration {
    subnets           = var.subnet_ids
    security_groups   = [aws_security_group.ecs_sg.id]
    assign_public_ip  = var.assign_public_ip
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [desired_count]
  }

  depends_on = [ aws_ecs_task_definition.this ]
}

# monitoring elastic scaling
resource "aws_appautoscaling_target" "this" {
  max_capacity       = 5  
  min_capacity       = 1  
  resource_id        = "service/${aws_ecs_cluster.this.name}/${aws_ecs_service.this.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# scale based on CPU usage
resource "aws_appautoscaling_policy" "this" {
  name               = "${var.service_name}-cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.this.resource_id
  scalable_dimension = aws_appautoscaling_target.this.scalable_dimension
  service_namespace  = aws_appautoscaling_target.this.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0 # when CPU used to 70%
    scale_in_cooldown  = 300
    scale_out_cooldown = 60
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
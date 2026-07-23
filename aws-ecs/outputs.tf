output "cluster_id" {
  description = "The arn of ECS cluster"
  value       = aws_ecs_cluster.this.arn
}

output "service_name" {
  description = "The name of ECS service"
  value       = aws_ecs_cluster.this.name
}

output "security_group_id" {
  description = "The security group which ECS using"
  value       = aws_security_group.ecs_sg.id
}

output "task_definition_arn" {
  description = "The latest taks arn"
  value       = aws_ecs_task_definition.this.arn
}


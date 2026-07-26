output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.this.dns_name
}

output "target_group_arn" {
  description = "The ARN of the target group"
  value       = aws_lb_target_group.this.arn
}

output "alb_security_group_id" {
  description = "The security Group ID of the ALB used for EC2 inbound rule"
  value       = aws_security_group.alb.id
}

output "alb_zone_id" {
  description = "The Zone ID of the ALB"
  value       = aws_lb.this.zone_id
}
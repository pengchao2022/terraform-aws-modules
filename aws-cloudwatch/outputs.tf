output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.this.arn
}

output "flow_log_id" {
  description = "ID of the VPC flow log"
  value       = aws_flow_log.this.id
}

output "flow_log_arn" {
  description = "ARN of the VPC flow log"
  value       = aws_flow_log.this.arn
}

output "firehose_arn" {
  description = "ARN of the Kinesis Firehose delivery stream (if enabled)"
  value       = try(aws_kinesis_firehose_delivery_stream.archive[0].arn, null)
}

output "firehose_name" {
  description = "Name of the Kinesis Firehose delivery stream (if enabled)"
  value       = try(aws_kinesis_firehose_delivery_stream.archive[0].name, null)
}

output "subscription_filter_name" {
  description = "Name of the subscription filter (if enabled)"
  value       = try(aws_cloudwatch_log_subscription_filter.this[0].name, null)
}
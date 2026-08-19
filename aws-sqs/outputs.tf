output "queue_id" {
  description = "SQS 队列的 ID also the URL"
  value       = aws_sqs_queue.this.id
}

output "queue_url" {
  description = "SQS queue URL"
  value = aws_sqs_queue.this.url
}

output "queue_arn" {
  description = "SQS 队列的 ARN"
  value       = aws_sqs_queue.this.arn
}

output "queue_name" {
  description = "SQS 队列的名称"
  value       = aws_sqs_queue.this.name
}

output "dlq_id" {
  description = "死信队列的 URL (如果启用)"
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].id : null
}

output "dlq_arn" {
  description = "死信队列的 ARN (如果启用)"
  value       = var.enable_dlq ? aws_sqs_queue.dlq[0].arn : null
}
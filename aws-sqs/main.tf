resource "aws_sqs_queue" "dlq" {
  count = var.enable_dlq ? 1 : 0

  name                        = "${var.queue_name}-dlq"
  message_retention_seconds   = var.dlq_message_retention_seconds
  kms_master_key_id           = var.kms_master_key_id
  sqs_managed_sse_enabled     = var.sqs_managed_sse_enabled
  tags                        = var.tags
}

resource "aws_sqs_queue" "this" {
  name                              = var.queue_name
  delay_seconds                     = var.delay_seconds
  max_message_size                  = var.max_message_size
  message_retention_seconds         = var.message_retention_seconds
  receive_wait_time_seconds         = var.receive_wait_time_seconds
  visibility_timeout_seconds        = var.visibility_timeout_seconds
  fifo_queue                        = var.fifo_queue
  content_based_deduplication       = var.fifo_queue ? var.content_based_deduplication : null
  deduplication_scope               = var.fifo_queue ? var.deduplication_scope : null
  fifo_throughput_limit             = var.fifo_queue ? var.fifo_throughput_limit : null

  # 死信队列（DLQ）配置
  redrive_policy = var.enable_dlq ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null

  # 加密配置
  kms_master_key_id                 = var.kms_master_key_id
  kms_data_key_reuse_period_seconds = var.kms_data_key_reuse_period_seconds
  sqs_managed_sse_enabled           = var.sqs_managed_sse_enabled

  tags = var.tags
}
variable "queue_name" {
  description = "SQS 队列名称（如果是 FIFO 队列，必须以 .fifo 结尾）"
  type        = string
}

variable "fifo_queue" {
  description = "是否为 FIFO 队列"
  type        = bool
  default     = false
}

variable "delay_seconds" {
  description = "消息投递延迟时间 (0-900 秒)"
  type        = number
  default     = 0
}

variable "max_message_size" {
  description = "单条消息最大字节数 (1055 到 262144 字节，即 256KB)"
  type        = number
  default     = 262144
}

variable "message_retention_seconds" {
  description = "消息在队列中保留的时间 (60 到 1209600 秒，默认 4 天)"
  type        = number
  default     = 345600 
}

variable "receive_wait_time_seconds" {
  description = "长轮询等待时间 (0 到 20 秒，推荐设置为大于 0 以减少空轮询)"
  type        = number
  default     = 10
}

variable "visibility_timeout_seconds" {
  description = "消息可见性超时时间 (0 到 43200 秒)"
  type        = number
  default     = 30
}

# --- 死信队列 (DLQ) 相关配置 ---
variable "enable_dlq" {
  description = "是否启用死信队列"
  type        = bool
  default     = true
}

variable "max_receive_count" {
  description = "消息被重试消费多少次后转入死信队列"
  type        = number
  default     = 3
}

variable "dlq_message_retention_seconds" {
  description = "死信队列中消息的保留时间 (默认 14 天)"
  type        = number
  default     = 1209600
}

# --- 加密配置 ---
variable "sqs_managed_sse_enabled" {
  description = "是否使用 SQS 托管密钥 (SSE-SQS) 进行加密"
  type        = bool
  default     = true
}

variable "kms_master_key_id" {
  description = "自定义 KMS 密钥 ID 或 ARN (如果使用 KMS 加密)"
  type        = string
  default     = null
}

variable "kms_data_key_reuse_period_seconds" {
  description = "KMS 数据密钥重用周期"
  type        = number
  default     = 300
}

# --- FIFO 特有属性 ---
variable "content_based_deduplication" {
  description = "是否启用基于内容的去重 (仅限 FIFO)"
  type        = bool
  default     = false
}

variable "deduplication_scope" {
  description = "去重范围: queue 或 messageGroup"
  type        = string
  default     = "queue"
}

variable "fifo_throughput_limit" {
  description = "吞吐量限制: perQueue 或 perMessageGroupId"
  type        = string
  default     = "perQueue"
}

variable "tags" {
  description = "附加到资源的标签"
  type        = map(string)
  default     = {}
}
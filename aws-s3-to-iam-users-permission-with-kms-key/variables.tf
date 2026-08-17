variable "bucket_name" {
  type        = string
  description = "The name of the existing S3 bucket to grant access to."
}

variable "iam_user_arns" {
  type        = list(string)
  description = "A list of IAM user ARNs that need access to the S3 bucket and CMK."
  default     = []
}

variable "kms_key_arn" {
  type        = string
  description = "The ARN of the Customer Managed KMS Key (CMK) used to encrypt/decrypt the S3 bucket objects."
}
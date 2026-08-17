output "key_id" {
  description = "The globally unique identifier for the KMS key."
  value       = aws_kms_key.this.id
}

output "key_arn" {
  description = "The Amazon Resource Name (ARN) of the key. (通常传给其他模块使用)"
  value       = aws_kms_key.this.arn
}

output "alias_name" {
  description = "The display alias name of the KMS key."
  value       = aws_kms_alias.this.name
}
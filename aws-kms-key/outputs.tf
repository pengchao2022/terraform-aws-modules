output "key_id" {
  description = "The globally unique identifier for this key"
  value = aws_kms_key.this.key_id
}

output "key_arn" {
  description = "The Amazon Resource Name ARN of the key"
  value       = aws_kms_key.this.arn
}

output "key_alias_arn" {
  description = "The arn for this kms key"
  value       = aws_kms_alias.this.arn
}

output "key_alias_name" {
  description = "The alias name of the key e.g., alias/gopay-key"
  value       = aws_kms_alias.this.name
}




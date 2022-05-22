output "arn" {
  description = "AWS CMK ARN"
  value       = try(aws_kms_key.this[0].arn, null)
}

output "id" {
  description = "Globally unique ID for CMK"
  value       = try(aws_kms_key.this[0].key_id, null)
}
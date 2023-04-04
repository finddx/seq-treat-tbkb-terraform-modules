output "role_mapping" {
  value       = aws_iam_role_policy_attachment.policy_mapping
  description = "Generated role mapping"
}

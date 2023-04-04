output "policy_name" {
  value = {
    for name, list in aws_iam_policy.tf_iam_policy :
    name => list.name
  }
  description = "IAM policy name"
}

output "policy_arn" {
  value = {
    for name, list in aws_iam_policy.tf_iam_policy :
    name => list.arn
  }
  description = "IAM policy arn"
}

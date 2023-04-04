output "role_name" {
  value = {
    for name, list in aws_iam_role.tf_iam_role :
    name => list.name
  }
  description = "IAM role name"
}

output "role_arn" {
  value = {
    for name, list in aws_iam_role.tf_iam_role :
    name => list.arn
  }
  description = "IAM role arn"
}

output "instance_profile_name" {
  value = {
    for name, list in aws_iam_instance_profile.tf_instance_profile :
    name => list.name
  }
  description = "IAM role instance profile name"
}
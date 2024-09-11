output "ecr_repositories" {
  value      = try({ for k, v in aws_ecr_repository.default : k => v.repository_url })
  depends_on = [aws_ecr_repository.default]
}

output "ecr_arns" {
  value      = try({ for k, v in aws_ecr_repository.default : k => v.arn })
  depends_on = [aws_ecr_repository.default]
}

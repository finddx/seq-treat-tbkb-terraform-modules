output "batch_job_fargate_definition_arn" {
  value = {
    for name, list in aws_batch_job_definition.this :
    name => list.arn
  }
  description = "Name of batch job definition"
}


output "sqs_queue_arn" {
  description = "The arn off SQS queue."
  value      = try({for k, v in aws_sqs_queue.queue : k => v.arn})
}

output "sqs_queue_name" {
  description = "The arn off SQS queue."
  value      = try({for k, v in aws_sqs_queue.queue : k => v.name})
}
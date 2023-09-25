output "sqs_queue_arn" {
  description = "The arn off SQS queue."
  value       = aws_sqs_queue.queue.arn
}

output "sqs_queue_name" {
  description = "The arn off SQS queue."
  value       = aws_sqs_queue.queue.name
}


output "sqs_queue_url" {
  description = "The URL of SQS queue."
  value       = aws_sqs_queue.queue.url
}

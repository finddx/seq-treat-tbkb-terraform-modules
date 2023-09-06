locals {
  prefix = "${var.project_name}-${var.module_name}-${var.environment}"
}

resource "aws_sqs_queue" "queue" {
  name = "${local.prefix}-${var.name}"
  tags = var.tags
}

resource "aws_sqs_queue_policy" "policy" {
  policy    = var.policy
  queue_url = aws_sqs_queue.queue.id
  depends_on = [
    var.queue_policy_dependencies,
    aws_sqs_queue.queue
  ]
}
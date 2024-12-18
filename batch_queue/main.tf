resource "aws_batch_job_queue" "this" {
  name     = var.queue_name
  state    = "ENABLED"
  priority = 1
  compute_environment_order {
    order               = 1
    compute_environment = var.compute_environments
  }
  tags = {
    Name = var.queue_name
  }
}

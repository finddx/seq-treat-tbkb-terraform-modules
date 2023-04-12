resource "aws_batch_job_queue" "ec2" {
  name     = "${var.environment}-${var.type}"
  state    = "ENABLED"
  priority = 1
  compute_environments = [
    var.compute_environments
  ]
  tags = {
    Name = var.batch_name
  }
}

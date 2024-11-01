resource "aws_batch_compute_environment" "this" {
  compute_environment_name = var.compute_env_name
  compute_resources {

    type               = "FARGATE"
    min_vcpus          = 0
    max_vcpus          = 5000
    desired_vcpus      = 0
    security_group_ids = [var.security_group_id]
    subnets            = var.subnet_ids
  }

  service_role = var.service_role_arn
  type         = "MANAGED"
  state        = "ENABLED"
  depends_on   = [var.service_role_name]

  tags = {
    Name = var.compute_env_name
  }
  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_batch_compute_environment" "this" {
  compute_environment_name = var.compute_env_name
  compute_resources {

    type               = var.type
    min_vcpus          = 0
    max_vcpus          = 5000
    desired_vcpus      = 0
    security_group_ids = [data.aws_security_group.default.id]
    subnets            = [data.aws_subnet.private_subnet.id]
  }

  service_role = var.role_arn
  type         = "MANAGED"
  state        = "ENABLED"
  depends_on   = [var.role]

  tags = {
    Name = var.batch_name
  }
  lifecycle {
    create_before_destroy = true
  }
}


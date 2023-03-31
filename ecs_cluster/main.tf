locals {
  prefix    = "${var.project_name}-${var.module_name}-${var.environment}"
}

resource "aws_ecs_cluster" "ecs" {
  for_each = var.ecs_clusters
  name = "${local.prefix}-${each.key}"

}

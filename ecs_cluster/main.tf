locals {
  prefix    = "${var.project_name}-${var.module_name}-${var.environment}"
}

resource "aws_ecs_cluster" "ecs" {
  for_each = var.ecs_clusters
  name = "${local.prefix}-${each.key}"

}
resource "aws_ecs_cluster_capacity_providers" "providers" {
  for_each = var.ecs_clusters
  cluster_name = aws_ecs_cluster.ecs[each.key].name
  capacity_providers = lookup(each.value, "capacity_providers",[])
  default_capacity_provider_strategy {
      capacity_provider = lookup(each.value,"capacity_provider", "FARGATE")
  }
}
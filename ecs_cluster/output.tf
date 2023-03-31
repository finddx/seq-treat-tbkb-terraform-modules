output "aws_ecs_cluster_id" {
  value      = try({for k, v in aws_ecs_cluster.ecs : k => v.name})
  depends_on = [aws_ecs_cluster.ecs]
}
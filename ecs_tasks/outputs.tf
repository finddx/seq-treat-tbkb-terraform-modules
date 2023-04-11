output "task_definition_id" {
  value = {
    for name, list in aws_ecs_task_definition.task_definition :
    name => list.id
  }
  description = "List of task definition IDs"
}

output "task_definition_arn" {
  value = {
    for name, list in aws_ecs_task_definition.task_definition :
    name => list.arn
  }
  description = "List of task definition ARNs"
}

output "ecs_service_id" {
  value = {
    for name, list in aws_ecs_service.ecs_service :
    name => list.id
  }
  description = "Ecs Service ID"
}

output "ecs_service_name" {
  value = {
    for name, list in aws_ecs_service.ecs_service :
    name => list.name
  }
  description = "Ecs service name"
}


output "locals" {
  value = local.deployment_circuit_breaker
}

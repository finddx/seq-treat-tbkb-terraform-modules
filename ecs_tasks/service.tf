locals {
  deployment_circuit_breaker = {for k, v in var.services: k => lookup(v, "deployment_circuit_breakers", {})}
}

resource "aws_ecs_service" "ecs_service" {
  for_each        = var.services
  name            = each.key
  cluster         = each.value["cluster"]
  desired_count   = each.value["desired_count"]
  task_definition = aws_ecs_task_definition.task_definition[each.value["task_definition"]].arn
  launch_type     = lookup(each.value, "launch_type", "FARGATE")
  iam_role        = lookup(each.value, "iam_role", null)

  deployment_maximum_percent         = lookup(each.value, "deployment_maximum_percent", 200)
  deployment_minimum_healthy_percent = lookup(each.value, "deployment_minimum_healthy_percent", 100)
  deployment_controller {
    type = "ECS"
  }

  network_configuration {
    subnets          = each.value["subnets"]
    security_groups  = each.value["security_groups"]
    assign_public_ip = lookup(each.value, "assign_public_ip", false)
  }

  dynamic "ordered_placement_strategy" {
    for_each = lookup(each.value, "ordered_placement_strategy", {})
    iterator = ordered_placement_strategy
    content {
      type  = ordered_placement_strategy.value["type"]
      field = lookup(ordered_placement_strategy.value, "field", null)
    }
  }

  dynamic "load_balancer" {
    for_each = lookup(each.value, "load_balancers", {})
    iterator = lb
    content {
      target_group_arn = lb.value["target_group_arn"]
      container_name   = lb.value["container_name"]
      container_port   = lb.value["container_port"]
    }
  }

  dynamic "service_registries" {
    for_each = lookup(each.value, "service_registries", {})
    iterator = sr
    content {

      registry_arn   = sr.value["registry_arn"]
    }
  }
  deployment_circuit_breaker {
    enable   = false
    rollback = false
  }

  health_check_grace_period_seconds = lookup(each.value, "load_balancers", null) == null ? null : lookup(each.value, "health_check_grace_period_seconds", 0)

  propagate_tags = "NONE"
  tags           =  var.tags

  depends_on = [var.dependencies]
}


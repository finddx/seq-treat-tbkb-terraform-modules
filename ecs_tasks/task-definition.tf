resource "aws_ecs_task_definition" "task_definition" {
  for_each                 = var.task_definitions
  family                   = each.key
  requires_compatibilities = lookup(each.value, "requires_compatibilities", ["FARGATE"])
  network_mode             = "awsvpc"
  cpu                      = lookup(each.value, "cpu")
  memory                   = lookup(each.value, "memory")
  execution_role_arn       = lookup(each.value, "execution_role_arn")
  task_role_arn            = each.value["task_role_arn"]

  dynamic "placement_constraints" {
    for_each = lookup(each.value, "placement_constraints", {})
    iterator = placement_constraints
    content {
      type       = placement_constraints.value["type"]
      expression = placement_constraints.value["expression"]
    }
  }

  dynamic "volume" {
    for_each = lookup(each.value, "volume", {})
    iterator = volume
    content {
      name = volume.value.name

      host_path = lookup(volume.value, "host_path", null)

      dynamic "docker_volume_configuration" {
        for_each = lookup(volume.value, "docker_volume_configuration", [])
        content {
          autoprovision = lookup(docker_volume_configuration.value, "autoprovision", null)
          driver        = lookup(docker_volume_configuration.value, "driver", null)
          driver_opts   = lookup(docker_volume_configuration.value, "driver_opts", null)
          labels        = lookup(docker_volume_configuration.value, "labels", null)
          scope         = lookup(docker_volume_configuration.value, "scope", null)
        }
      }

      dynamic "efs_volume_configuration" {
        for_each = lookup(volume.value, "efs_volume_configuration", [])
        content {
          file_system_id          = lookup(efs_volume_configuration.value, "file_system_id", null)
          root_directory          = lookup(efs_volume_configuration.value, "root_directory", null)
          transit_encryption      = lookup(efs_volume_configuration.value, "transit_encryption", null)
          transit_encryption_port = lookup(efs_volume_configuration.value, "transit_encryption_port", null)
          dynamic "authorization_config" {
            for_each = lookup(efs_volume_configuration.value, "authorization_config", [])
            content {
              access_point_id = lookup(authorization_config.value, "access_point_id", null)
              iam             = lookup(authorization_config.value, "iam", null)
            }
          }
        }
      }
    }
  }

  tags = {
    Name = each.key
  }
  container_definitions = jsonencode(concat(
    [{
      portMappings   = lookup(each.value, "port_mappings", [])
      cpu            = lookup(each.value, "cpu")
      memory         = lookup(each.value, "memory")
      image          = "${each.value["container_repo"]}:${each.value["container_tag"]}"
      essential      = true
      name           = each.key
      mountPoints    = lookup(each.value, "mountPoints", [])
      volumesFrom    = []
      entryPoint     = lookup(each.value, "entryPoint", [])
      command        = lookup(each.value, "command", [])
      healthCheck    = lookup(each.value, "health_check", null)
      environment    = lookup(each.value, "environment_variables", null)
      secrets        = lookup(each.value, "secret_environment_variables", [])
      ulimits        = lookup(each.value, "ulimits", [])
      systemControls = lookup(each.value, "system_controls", [])
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "${each.value["log-group"]}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = lookup(each.value, "awslogs-stream-prefix", "task")
        }
      }
    }]
  ))
  depends_on = [var.dependencies]
}

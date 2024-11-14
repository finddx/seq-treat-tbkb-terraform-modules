resource "aws_batch_job_definition" "this" {
  for_each = var.batch_job_fargate_definitions
  name     = each.key
  type     = lookup(each.value, "type", "container")
  platform_capabilities = [
    "FARGATE",
  ]
  container_properties = jsonencode({
    image            = lookup(each.value, "image")
    command          = lookup(each.value, "command")
    jobRoleArn       = lookup(each.value, "taskRoleArn")
    executionRoleArn = lookup(each.value, "executionRoleArn")
    resourceRequirements = [
      {
        type  = "VCPU",
        value = tostring(lookup(each.value, "container_vcpu"))
      },
      {
        type  = "MEMORY",
        value = tostring(lookup(each.value, "container_memory"))
      }
    ]
    networkConfiguration = {
      assignPublicIp = lookup(each.value, "assignPublicIp", "DISABLED")
    }
    logConfiguration = {
      logDriver = "awslogs"
      options = {
        "awslogs-group" = format("/aws/batch/job/%s", each.key)
      }
    }
  })

  tags = {
    Name = each.key
  }
}

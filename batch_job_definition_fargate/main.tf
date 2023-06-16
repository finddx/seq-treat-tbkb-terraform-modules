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
    jobRoleArn       = lookup(each.value, "jobRoleArn")
    executionRoleArn = lookup(each.value, "jobRoleArn")
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
  })

  tags = {
    Name = each.key
  }
}

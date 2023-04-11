resource "aws_batch_job_definition" "this" {
  for_each = var.batch_job_definitions
  name     = each.key
  type     = lookup(each.value, "type", "container")
  platform_capabilities = [
    "EC2",
  ]
  container_properties = jsonencode({
    image   = lookup(each.value, "image")
    command = lookup(each.value, "command")
    volumes = [
      {
        host = {
          sourcePath = "/scratch/working"
        },
        name = "working"
      }
    ]
    mountPoints = [
      {
        sourceVolume  = "working",
        containerPath = "/scratch",
        readOnly      = false
      }
    ]
    resourceRequirements = [
      {
        type  = "VCPU",
        value = tostring(lookup(each.value, "container_vcpu"))
      },
      {
        type = "MEMORY",
        value = tostring(lookup(each.value, "container_memory"))
      }
    ]
  })

  tags = {
    Name = each.key
  }
}

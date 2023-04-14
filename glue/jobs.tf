resource "aws_glue_job" "this" {
  for_each = var.glue_jobs
  name     = each.key
  role_arn = lookup(each.value, "role_arn")
  connections = lookup(each.value, "connections",[])
  description = lookup(each.value, "description","")
  glue_version = lookup(each.value, "glue_version")
  number_of_workers = lookup(each.value, "number_of_workers")
  worker_type = lookup(each.value, "worker_type")
  default_arguments = lookup(each.value, "default_arguments",{})
  command {
    script_location = lookup(each.value, "script_location")
  }
  tags = lookup(each.value, "tags", {})
}

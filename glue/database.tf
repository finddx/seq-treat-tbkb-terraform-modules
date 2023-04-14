resource "aws_glue_catalog_database" "this" {
  for_each    = var.glue_databases
  name        = each.key
  catalog_id  = data.aws_caller_identity.current.id
  description = lookup(each.value, "description")
}

data "aws_caller_identity" "current" {}
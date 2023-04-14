resource "aws_glue_crawler" "example" {
  for_each = var.aws_glue_crawlers
  database_name = lookup(each.value, "database_name")
  name          = each.key
  role          = lookup(each.value, "role")
  classifiers = lookup(each.value, "classifiers", [])
  description = lookup(each.value, "description", "")


  dynamic "jdbc_target" {
    for_each = lookup(each.value, "jdbc_target", {})
    content {
      connection_name = each.value.jdbc_target.connection_name
      path            = each.value.jdbc_target.path
    }
  }

  dynamic "s3_target" {
    for_each = lookup(each.value, "s3", {})

    content {
      path =  each.value.s3.s3_path
    }
  }

  configuration =  lookup(each.value, "configuration" , jsonencode(
    {
      Version = 1.0,
      Grouping = {
        TableGroupingPolicy = "CombineCompatibleSchemas"
      }
    }
  ))
  tags = lookup(each.value, "tags",{})
}

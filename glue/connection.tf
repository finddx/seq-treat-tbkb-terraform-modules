resource "aws_glue_connection" "this" {
  for_each        = var.glue_connection
  name            = each.key
  catalog_id      = data.aws_caller_identity.current.id
  connection_type = lookup(each.value, "connection_type", "JDBC")
  connection_properties = {
    JDBC_CONNECTION_URL = lookup(each.value, "jdbc_connection_url")
    PASSWORD            = lookup(each.value, "password", "")
    USERNAME            = lookup(each.value, "username", "")
  }

  physical_connection_requirements {
    availability_zone      = lookup(each.value, "availability_zone")
    security_group_id_list = lookup(each.value, "security_group_id_list", [])
    subnet_id              = lookup(each.value, "subnet_id")
  }
  tags = lookup(each.value, "tags",{})
}

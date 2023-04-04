locals {
  prefix = "${var.project_name}-${var.module_name}-${var.environment}"
}


resource "aws_iam_role" "tf_iam_role" {
  for_each = var.enable == true ? { for o in var.roles : o.name => o } : {}
  # name is used in 2 cases: if we have full_name_override = true or disable_name_suffix = true. In second case we also add a prefix to the role name and in first case we use exact name as provided in the module caller. Otherwise we use name_prefix option.
  name               = lookup(each.value, "role_name", null) == null ? "${local.prefix}-${each.key}" : lookup(each.value, "role_name")
  assume_role_policy = lookup(each.value, "custom_trust_policy", null) == null ? file("${path.module}/${each.value.trust_policy}.json") : each.value.custom_trust_policy
  description        = lookup(each.value, "description", null)

}

resource "aws_iam_instance_profile" "tf_instance_profile" {
  for_each = {
    for o in var.roles : o.name => o
    if o.instance_profile_enable == true
  }



  name     =  lookup(each.value, "instance_profile_name", "${local.prefix}-${each.key}")
  role     =  lookup(each.value, "instance_profile", aws_iam_role.tf_iam_role[each.key].name)

  lifecycle {
    create_before_destroy = true
  }
}

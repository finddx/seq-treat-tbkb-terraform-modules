locals {
  prefix = "${var.project_name}-${var.module_name}-${var.environment}"
}

resource "aws_iam_policy" "tf_iam_policy" {
  for_each    = var.enable == true ? { for o in var.policies : o.name => o } : {}
  name        = "${local.prefix}-${each.key}"
  description = lookup(each.value, "description", null)
  policy      = each.value["policy"]

  lifecycle {
    create_before_destroy = true
  }
}

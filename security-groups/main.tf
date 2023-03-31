locals {
  prefix = "${var.project_name}-${var.module_name}-${var.environment}"
}
resource "aws_security_group" "default" {
  for_each = { for o in var.security_groups : o.name => o }

  description = each.value.description
  vpc_id      = var.vpc_id
  tags = {
    Name        = "${local.prefix}-${each.value.name}"
    Label       = "${local.prefix}-${each.value.name}"
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

locals {
  security_groups = aws_security_group.default
}

resource "aws_security_group_rule" "default" {
  for_each = var.sg_rules

  security_group_id        = each.value.security_group_id
  source_security_group_id = each.value.self == null ? each.value.source_security_group_id : null

  type        = each.value.type
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.self == null ? each.value.cidr_blocks : null
  description = each.value.description
  self        = each.value.self != null ? each.value.self : null

  depends_on       = [aws_security_group.default]
  ipv6_cidr_blocks = each.value.self == null ? null : null
  prefix_list_ids  = []

}

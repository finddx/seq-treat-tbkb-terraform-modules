locals {
  prefix = "${var.project_name}-${var.module_name}-${var.environment}"
}
resource "aws_security_group" "default" {
  for_each = { for o in var.security_groups : o.name => o }

  description = each.value.description
  vpc_id      = var.vpc_id
  tags = merge(var.default_tags, {
    Name  = "${local.prefix}-${each.value.name}"
    Label = "${local.prefix}-${each.value.name}"
  })

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_vpc_security_group_ingress_rule" "default" {
  for_each = var.sg_rules_ingress

  security_group_id            = each.value.security_group_id
  referenced_security_group_id = each.value.source_security_group_id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_blocks
  description = each.value.description

  depends_on = [aws_security_group.default]
  cidr_ipv6  = null
}


resource "aws_vpc_security_group_egress_rule" "default" {
  for_each = var.sg_rules_egress

  security_group_id            = each.value.security_group_id
  referenced_security_group_id = each.value.destination_security_group_id

  from_port   = each.value.from_port
  to_port     = each.value.to_port
  ip_protocol = each.value.protocol
  cidr_ipv4   = each.value.cidr_blocks
  description = each.value.description

  depends_on = [aws_security_group.default]
  cidr_ipv6  = null
}

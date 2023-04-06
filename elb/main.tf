data "aws_caller_identity" "current_account_id" {}

resource "aws_lb" "tf_lb" {
  for_each                         = var.load_balancers
  name                             = lookup(each.value, "name", false)
  internal                         = lookup(each.value, "internal", false)
  load_balancer_type               = lower(each.value["type"])
  subnets                          = each.value["subnets"]
  security_groups                  = lower(each.value["type"]) == "application" ? each.value["security_groups"] : null
  idle_timeout                     = lookup(each.value, "idle_timeout", 60)
  enable_cross_zone_load_balancing = lookup(each.value, "cross_zone_load_balancing", true)

  enable_deletion_protection = false

  dynamic "subnet_mapping" {
    for_each = lookup(each.value, "elastic_ip_association", {})
    content {
      subnet_id     = subnet_mapping.key
      allocation_id = subnet_mapping.value
    }
  }

  dynamic "access_logs" {
    for_each = var.enable_access_logs == true ? [1] : []
    iterator = access_logs
    content {
      enabled = var.enable_access_logs
      bucket  = var.access_logs_bucket
      prefix  = lower(lookup(each.value, "access_logs_prefix", "${var.environment}-${each.key}"))
    }
  }

  tags = {
    Name = lower("${local.prefix}-${each.key}")
  }

  lifecycle {
    create_before_destroy = true
  }

  timeouts {
    create = "20m"
  }

}

resource "aws_lb_target_group" "tf_target_group" {
  for_each           = var.target_groups
  name               = lookup(each.value, "name", false)
  target_type        = lower(lookup(each.value, "target_type", "instance"))
  protocol           = lower(lookup(each.value, "target_type", "instance")) == "lambda" ? null : upper(lookup(each.value, "protocol", "HTTP"))
  port               = lower(lookup(each.value, "target_type", "instance")) == "lambda" ? null : lookup(each.value, "port", 80)
  vpc_id             = lookup(each.value, "vpc_id", null)
  preserve_client_ip = contains(["TCP", "TLS"], upper(lookup(each.value, "protocol", "HTTP"))) == true ? lookup(each.value, "preserve_client_ip", true) : null
  proxy_protocol_v2  = lookup(each.value, "proxy_protocol_v2", null)

  dynamic "stickiness" {
    for_each = lookup(each.value, "stickiness_enable", false) ? [1] : []
    content {
      enabled         = true
      type            = "lb_cookie"
      cookie_duration = lookup(each.value, "stickiness_duration", 86400)
    }
  }

  deregistration_delay = lookup(each.value, "deregistration_delay", 300)
  slow_start           = lookup(each.value, "slow_start", 0)

  dynamic "health_check" {
    for_each = lower(lookup(each.value, "target_type", "instance")) == "lambda" ? [] : [1]
    content {
      enabled             = lookup(each.value, "hc_enabled", true)
      interval            = lookup(each.value, "hc_interval", null)
      path                = lookup(each.value, "hc_path", null)
      port                = lookup(each.value, "hc_port", null)
      protocol            = upper(lookup(each.value, "hc_protocol", "HTTP"))
      timeout             = lookup(each.value, "hc_timeout", null)
      healthy_threshold   = lookup(each.value, "hc_healthy_threshold", null)
      unhealthy_threshold = lookup(each.value, "hc_unhealthy_threshold", null)
      matcher             = lookup(each.value, "hc_matcher", null)
    }
  }

  tags = {
    Name = lower("${local.prefix}-${each.key}")
  }

  lifecycle {
    create_before_destroy = true
  }
}

#redirect load balancer from HTTP to HTTPS
resource "aws_lb_listener" "listener_http_to_https" {
  for_each          = toset(var.http_to_https)
  load_balancer_arn = aws_lb.tf_lb[each.key].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_lb.tf_lb]
}

resource "aws_lb_listener" "listeners" {
  for_each          = var.load_balancer_listeners
  load_balancer_arn = aws_lb.tf_lb[each.value["load_balancer"]].arn
  port              = each.value["port"]
  protocol          = upper(each.value["protocol"])
  ssl_policy        = contains(["HTTPS", "TLS"], lookup(each.value, "protocol", "null")) ? lookup(each.value, "ssl_policy", "ELBSecurityPolicy-TLS-1-2-2017-01") : null
  certificate_arn   = contains(["HTTPS", "TLS"], lookup(each.value, "protocol", "null")) ? each.value["certificate_arn"] : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tf_target_group[each.value["default_target_group"]].arn
  }
}

resource "aws_lb_listener_rule" "tf_lb_listener_forward_rule" {
  for_each     = var.listener_rules
  listener_arn = aws_lb_listener.listeners[each.value["listener"]].arn
  priority     = each.value["priority"]

  action {
    type = lookup(each.value, "action_type", "forward")

    // forward type
    target_group_arn = lookup(each.value, "action_type", "forward") == "forward" ? aws_lb_target_group.tf_target_group[each.value["target_group"]].arn : null
    // fixed-response type
    dynamic "fixed_response" {
      for_each = lookup(each.value, "action_type", "forward") == "fixed-response" ? [1] : []
      content {
        content_type = each.value["fixed_response"]["content_type"]
        message_body = lookup(each.value["fixed_response"], "message_body", null)
        status_code  = each.value["fixed_response"]["status_code"]
      }
    }
    // redirect type
    dynamic "redirect" {
      for_each = lookup(each.value, "action_type", "forward") == "redirect" ? [1] : []
      content {
        host        = lookup(each.value["redirect"], "host", null)
        path        = lookup(each.value["redirect"], "path", null)
        port        = lookup(each.value["redirect"], "port", null)
        protocol    = lookup(each.value["redirect"], "protocol", null)
        query       = lookup(each.value["redirect"], "query", null)
        status_code = each.value["redirect"]["status_code"]
      }
    }
  }

  dynamic "condition" {
    for_each = each.value["conditions"]
    iterator = condition
    content {
      dynamic "host_header" {
        for_each = condition.value["type"] == "host_header" ? [1] : []
        content {
          values = condition.value["values"]
        }
      }
      dynamic "http_header" {
        for_each = condition.value["type"] == "http_header" ? [1] : []
        content {
          http_header_name = condition.value["http_header_name"]
          values           = condition.value["values"]
        }
      }
      dynamic "http_request_method" {
        for_each = condition.value["type"] == "http_request_method" ? [1] : []
        content {
          values = condition.value["values"]
        }
      }
      dynamic "path_pattern" {
        for_each = condition.value["type"] == "path_pattern" ? [1] : []
        content {
          values = condition.value["values"]
        }
      }
      dynamic "query_string" {
        for_each = condition.value["type"] == "query_string" ? condition.value["values"] : []
        iterator = query_string
        content {
          key   = lookup(query_string.value, "key", null)
          value = query_string.value["value"]
        }
      }
      dynamic "source_ip" {
        for_each = condition.value["type"] == "source_ip" ? [1] : []
        content {
          values = condition.value["values"]
        }
      }
    }
  }

  depends_on = [aws_lb_listener.listeners]
}

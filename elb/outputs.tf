output "load_balancer_name" {
  value = {
    for name, list in aws_lb.tf_lb :
    name => list.name
  }
  description = "Name of load balancer"
}

output "load_balancer_arn" {
  value = {
    for name, list in aws_lb.tf_lb :
    name => list.arn
  }
  description = "ARN of load balancer"
}

output "load_balancer_arn_suffix" {
  value = {
    for name, list in aws_lb.tf_lb :
    name => list.arn_suffix
  }
  description = "ARN suffix of load balancer"
}

output "load_balancer_dns_name" {
  value = {
    for name, list in aws_lb.tf_lb :
    name => list.dns_name
  }
  description = "DNS name of load balancer"
}

output "load_balancer_id" {
  value = {
    for name, list in aws_lb.tf_lb :
    name => list.id
  }
  description = "ID of load balancer"
}

output "target_group_name" {
  value = {
    for name, list in aws_lb_target_group.tf_target_group :
    name => list.name
  }
  description = "Name of target group"
}

output "target_group_arn" {
  value = {
    for name, list in aws_lb_target_group.tf_target_group :
    name => list.arn
  }
  description = "ARN of target group"
}

output "target_group_id" {
  value = {
    for name, list in aws_lb_target_group.tf_target_group :
    name => list.id
  }
  description = "ID of target group"
}

output "listener_arn" {
  value = {
    for name, list in aws_lb_listener.listeners :
    name => list.arn
  }
  description = "ARN of created listener"
}


output "load_balancer_zone_id" {
  value = {
    for name, list in aws_lb.tf_lb :
    name => list.zone_id
  }
  description = "ARN suffix of load balancer"
}

output "security_group_id" {
  value = {
    for name, list in aws_security_group.default :
    name => list.id
  }
  description = "List of security groups id's"
}

output "security_group_name" {
  value = {
    for name, list in aws_security_group.default :
    name => list.name
  }
  description = "List of security groups names"
}

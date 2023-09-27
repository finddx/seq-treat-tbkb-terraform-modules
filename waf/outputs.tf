output "web_acl_arn" {
  value       = aws_wafv2_web_acl.waf_acl_cf.arn
  description = "ACL of the WAF"
}


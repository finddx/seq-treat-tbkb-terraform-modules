variable "https_certificate_arn" {}
variable "dns_name" {}
variable "elb_dns_name" {}
variable "frontend_port" {}
variable "frontend_ssl_port" {}
variable "waf_web_acl_id" {}
variable "restrictions" {
  type    = any
  default = {}
}
variable "project_name" {}
variable "environment" {}
variable "module_name" {}

variable "custom_header_value" {}

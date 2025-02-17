variable "static_bucket_name" {}
variable "logs_bucket_name" {}
variable "django_static_bucket_name" {}
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

variable "custom_header_value" {}

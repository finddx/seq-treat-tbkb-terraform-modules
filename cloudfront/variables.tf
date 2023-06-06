variable "static_bucket_name" {}
variable "logs_bucket_name" {}
variable "django_static_bucket_name" {}
variable "https_certificate_arn" {}
variable "dns_name" {}
variable "elb_dns_name" {}
variable "frontend_port" {}
variable "frontend_ssl_port" {}
variable "restrictions" {
  type    = any
  default = {}
}

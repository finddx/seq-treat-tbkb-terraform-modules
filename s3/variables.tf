variable "name" {
  type    = string
  default = "bucket"
}
variable "acl" {
  type        = string
  default     = "private"
  description = "Defines is the bucket public or private"
}
variable "tags" {}

variable "s3_bucket_encryption" {
  default = "true"
}

variable "server_side_encryption_configuration" {
  description = "Map containing server-side encryption configuration."
  type        = any
  default     = {}
}

variable "website" {
  description = "Map containing website hosting configuration."
  type        = any
  default     = {}
}
variable "s3_buckets" {
  type = map(object({
    enable_versioning   = bool,
    bucket_acl          = bool,
    enable_cors         = bool,
    cors_rule           = any,
    enable_notification = bool,
    notification_rule   = any,
    enable_policy       = bool,
    bucket_owner_acl    = bool,
    policy              = string
  }))
  default = {}
}

variable "project_name" {}
variable "environment" {}
variable "module_name" {}

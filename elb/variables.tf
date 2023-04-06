variable "aws_region" {
  type        = string
  default     = "eu-west-1"
  description = "AWS region to use for project"
}

variable "project_name" {
  type        = string
  default     = null
  description = "Project name. Used for tagging resources"
}

variable "module_name" {
  type        = string
  description = "Infrastructure module name"
}

variable "environment" {
  type        = string
  description = "Environment (stage, beta etc)"
}

variable "owner" {
  type        = string
  default     = null
  description = "Owner of the environment"
}

variable "squad" {
  type        = string
  default     = null
  description = "Squad which created the environment"
}

variable "load_balancers" {
  default = {}
}

variable "target_groups" {
  default = {}
}

variable "load_balancer_listeners" {
  default = {}
}

variable "listener_rules" {
  default = {}
}

variable "http_to_https" {
  default = []
}

variable "enable_access_logs" {
  type        = bool
  default     = false
  description = "Set to true to enable load balancer access logs. Applies to all load balancers created with this module"
}

variable "access_logs_bucket" {
  type        = string
  default     = null
  description = "Bucket to store access logs. Must be set if enable_access_logs=true"
}

variable "aws_region" {
  default     = "eu-west-1"
  description = "AWS region to use for project"
}

variable "enable" {
  type        = bool
  default     = true
  description = "Enable or disable creation of module"
}

variable "roles" {
#  type = list(object({
#    roles = string
#    role_name =string
#    custom_trust_policy = any
#    description = string
#    instance_profile_name = string
#    instance_profile_enable = bool
#    instance_profile = string
#  }))
  default = []
}

variable "environment" {
  default = "tf"
  type    = string
}

variable "project_name" {
  type        = string
  default     = null
  description = "Project name. Used for tagging resources"
}

variable "module_name" {
  type = string
  default = null
  description = "Module name for Policy"
}
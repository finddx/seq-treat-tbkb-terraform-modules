variable "compute_env_name" {}
variable "service_role_arn" {}
variable "service_role_name" {}
variable "subnet_ids" {
  type = list(any)
}

variable "security_group_id" {
  type = string
}

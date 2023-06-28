variable "environment" {}
variable "batch_name" {}
variable "launch_template_name" {}
variable "compute_env_name" {}
variable "service_role_name" {}
variable "service_role_arn" {}
variable "instance_profile" {}
variable "desired_vcpus" {
  default = 0
}

variable "subnet_ids" {
  type = list(any)
}

variable "security_group_id" {
  type = string
}

variable "batch_name" {}
variable "launch_template_name" {}
variable "environment" {}
variable "compute_env_name" {}
variable "role" {}
variable "role_arn" {}
variable "instance_profile" {}
variable "type" {}
variable "desired_vcpus" {
  default = 0
}

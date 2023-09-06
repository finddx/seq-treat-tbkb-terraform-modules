variable "project_name" {}
variable "environment" {}
variable "module_name" {}

variable "name" {}
variable "policy" {}
variable "tags" {
  type = any
  description = "tags of the module"
  default = {}
}
variable "queue_policy_dependencies" {

}
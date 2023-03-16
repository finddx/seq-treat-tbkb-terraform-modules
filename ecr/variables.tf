variable "ecr_app_repo_names" {
  type = set(string)
}
variable "project_name" {}
variable "ecr_image_tag_mutability" {
  default = "MUTABLE"
}
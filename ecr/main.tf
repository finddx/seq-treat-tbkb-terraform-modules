resource "aws_ecr_repository" "default" {
  for_each             = var.ecr_app_repo_names
  name                 = "${var.project_name}-${each.value}"
  image_tag_mutability = var.ecr_image_tag_mutability
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

data "aws_caller_identity" "current" {}


locals {
  prefix   = "${var.project_name}-${var.module_name}-${var.environment}"

  project_name = var.project_name
  current_aws_account_id = data.aws_caller_identity.current.account_id
}

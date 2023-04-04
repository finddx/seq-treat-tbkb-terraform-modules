resource "aws_iam_role_policy_attachment" "policy_mapping" {
  for_each   = var.roles
  role       = each.value["role"]
  policy_arn = each.value["policy"]
}

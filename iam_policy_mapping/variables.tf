variable "aws_region" {

}

variable "roles" {
  type        = map(any)
  description = "List of policies"
}

variable "aws_account" {
  description = "AWS account to use"
  type        = string
}
# variable "environment" {
#   type        = string
#   description = "the name of your environment (dev, uat, prod)"
# }
variable "bucket_name" {
  type        = string
  description = "Bucket name"
}

variable "policy" {

}

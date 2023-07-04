variable "region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS region to use for project"
}


variable "environment" {
  type        = string
  default     = "dev"
  description = "Environment (stage, beta etc)"
}

variable "project_name" {}

variable "module_name" {}

variable "security_groups" {
  type        = list(any)
  default     = []
  description = "List of security group names"
}

variable "vpc_id" {
  type        = string
  default     = null
  description = "Id of VPC in which Security groups should be createds"

}

variable "sg_rules_ingress" {
  type = map(object({
    security_group_id        = string,
    source_security_group_id = string,
    protocol                 = string,
    from_port                = number,
    to_port                  = number,
    description              = string,
    cidr_blocks              = string,
  }))
}

variable "sg_rules_egress" {
  type = map(object({
    security_group_id             = string,
    destination_security_group_id = string,
    protocol                      = string,
    from_port                     = number,
    to_port                       = number,
    description                   = string,
    cidr_blocks                   = string,
  }))
}

variable "default_tags" {
  type = map(any)
}

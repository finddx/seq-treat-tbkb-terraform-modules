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

variable "sg_rules" {
  type = map(object({
    security_group_id        = string,
    source_security_group_id = string,
    type                     = string,
    protocol                 = string,
    from_port                = number,
    to_port                  = number,
    self                     = bool,
    description              = string,
    cidr_blocks              = list(string),
  }))
}

variable "default_tags" {
  type = map(any)
}
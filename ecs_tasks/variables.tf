variable "aws_region" {
  type        = string
  default     = "eu-west-2"
  description = "AWS region to use for project"
}

variable "project_name" {
  type        = string
  description = "Project name. Used for tagging resources"
}

variable "module_name" {
  type        = string
  description = "Module name. Used for tagging resources"
}

variable "services" {
  default     = {}
  description = "ECS services configuration map"
}



variable "task_definitions" {
  description = "ECS task definition configuration map"
  # Fargate memory validation
  validation {
    condition = alltrue([
      for o in var.task_definitions : tonumber(trim(o.cpu, "vCPU")) * 1024 * 2 <= tonumber(trim(o.memory, "GB")) * 1024 && tonumber(trim(o.memory, "GB")) * 1024 <= tonumber(trim(o.cpu, "vCPU")) * 1024 * 8 && lookup(o, "requires_compatibilities", ["FARGATE"]) == ["FARGATE"] if o.cpu != "0vCPU"
    ])
    error_message = "If any vCPU or FARGATE type is selected, memory can be up to 8x times higher than CPU and must be at least 2x higher than cpu."
  }
  # EC2 0vCPU memory validation
  validation {
    condition = alltrue([
      for o in var.task_definitions : 512 <= tonumber(trim(o.memory, "GB")) * 1024 && lookup(o, "requires_compatibilities", ["FARGATE"]) != ["FARGATE"] if o.cpu == "0vCPU"
    ])
    error_message = "If 0vCPU or EC2 type is selected, memory can be unlimited starting from 0.5GB then 1GB and then incrementing with 1GB but needs to have requires_compatibilities set to EC2."
  }
}

variable "environment" {
  type        = string
  description = "Environment (stage, beta etc)"
}

variable "tags" {
  default     = {}
  description = "Additional tags to add to resources"
}

variable "dependencies" {
  default     = null
  description = "External dependencies for module"
}

variable "one_time_run" {
  default     = {}
  description = "ECS one time tasks configuration map"
}

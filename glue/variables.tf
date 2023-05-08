variable "glue_classifier" {
  type = any
  default = {}
}

variable "glue_connection" {
  type = any
  default = {}
}

variable "region" {
  default = "us-east-1"
}

variable "glue_databases" {
  type = any
  default = {}
}

variable "glue_crawlers" {
  type = any
  default = {}
}

variable "glue_jobs" {
  type = any
  default = {}
}
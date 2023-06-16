terraform {
  required_version = ">= 1.0"

# Requiring 4.61 and higher for managed password option implementation
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.61"
    }

    random = {
      source  = "hashicorp/random"
      version = ">= 3.1"
    }
  }
}

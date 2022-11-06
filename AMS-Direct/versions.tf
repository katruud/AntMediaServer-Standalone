terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.37.0"
    }

    http = {
      source  = "hashicorp/http"
      version = ">=1.2.0"
    }
  }

  required_version = ">= 1.3.3"
}

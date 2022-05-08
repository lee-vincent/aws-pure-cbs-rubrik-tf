terraform {
  cloud {
    organization = "vinnielee-io"

    workspaces {
      name = "AWS-SSH-TF-Demo"
    }
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.43.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.0.0"
    }
  }

  required_version = ">= 0.14.0"
}

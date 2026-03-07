terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }


backend "s3" {
    bucket = "daws-dev.cyou"
    key    = "roboshop-dev-catalogue-statefile"
    region = "us-east-1"
    encrypt        = true
    use_lockfile = true
  }
}


provider "aws" {
  # Configuration options
  region = "us-east-1"
}
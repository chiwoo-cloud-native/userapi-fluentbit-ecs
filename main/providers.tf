terraform {
  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.4"
    }
  }

}

# AWS_PROFILE=<your_aws_profile>
provider "aws" {
  region  = var.context.region
}

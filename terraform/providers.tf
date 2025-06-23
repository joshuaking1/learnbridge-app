# Specifies the required provider (AWS) and its version.
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configures the AWS provider, setting the default region for all resources.
provider "aws" {
  region = "eu-west-1" # IMPORTANT: Use the same region as your AWS CLI config and Supabase project.
}
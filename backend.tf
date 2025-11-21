# Local backend - state file will be stored locally as terraform.tfstate
# For production, consider using S3 backend for remote state storage
terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
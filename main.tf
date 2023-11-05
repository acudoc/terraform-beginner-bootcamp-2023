terraform {
  cloud {
    organization = "AV_learning2023"

    workspaces {
      name = "terra-house-av1"
    }
  }
  
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.5.1"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.24.0"
    }
  }
}

provider "random" {
  # Configuration options
}
provider "aws" {
  # Configuration options
}

resource "random_string" "bucket_name" {
  lower            = true
  upper           = false
  length           = 32
  special          = false
}
resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
}

output "random_bucket_name" {
  value = random_string.bucket_name.result 
}
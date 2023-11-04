terraform {
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

output "random_bucket_name" {
  value = random_string.bucket_name.result 
}
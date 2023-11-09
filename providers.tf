terraform {
#  cloud {
#    organization = "AV_learning2023"
#
#    workspaces {
#      name = "terra-house-av1"
#    }
#  }
  
  required_providers {
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
  region = "us-west-2"
}
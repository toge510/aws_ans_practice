terraform {
  backend "s3" {
    bucket  = "tfstate--20250721182240"
    key     = "terraform.tfstate"
    region  = "ap-northeast-1"
    encrypt = true
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.3.0"
    }
  }
  required_version = "1.12.2"
}

provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      Name = "handson"
    }
  }
}

data "aws_caller_identity" "current" {}
terraform {
  backend "s3" {
    bucket  = "tfstate--20250726145146"
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

provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

data "aws_caller_identity" "current" {}
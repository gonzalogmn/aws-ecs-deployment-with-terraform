terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "2.70.0"
    }
  }

  backend "s3" {
    bucket                  = "terraform-state-bucket-demo-api"
    key                     = "state/terraform.tfstate"
    region                  = "us-east-1"
    encrypt                 = true
    kms_key_id              = "alias/terraform-bucket-key"
    dynamodb_table          = "terraform-state"
    shared_credentials_file = "$HOME/.aws/credentials"
    profile                 = "admin-ecs-deployment-demo"
  }
}

provider "aws" {
  region                  = var.aws_default_region
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "admin-ecs-deployment-demo"
}

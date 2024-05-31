terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }
  backend "s3" {
    bucket         = "step-into-iot-workspacecloud"
    key            = "step-into-iot-workspace-cloud-vpn-001"
    region         = "us-east-1"
    dynamodb_table = "cloud-tbl-001"
  }
}

provider "aws" {
  region = "us-east-1"
}
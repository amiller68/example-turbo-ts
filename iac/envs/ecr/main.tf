provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type        = string
  description = "AWS region for ECR repositories"
  default     = "us-east-1" # Default if not explicitly set
}

# TODO (service-deploy): add your new services to this list in order to ensure
#  its ECR repository is created. This must match the service name in turborepo
locals {
  services = ["example"]
}

module "ecr" {
  source = "../../modules/aws/ecr"

  repository_names = local.services

  lifecycle_policies = {
    for service in local.services :
    "${service}" => var.default_lifecycle_policy
  }

  tags = {}
}

provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  type        = string
  description = "AWS region for ECR repositories"
  default     = "us-east-1" # Default if not explicitly set
}

module "ecr" {
  source = "../../modules/aws/ecr"

  repository_names = var.services

  lifecycle_policies = {
    for service in var.services :
    "${service}" => var.default_lifecycle_policy
  }

  tags = var.tags
}

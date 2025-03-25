# AWS Infrastructure Module
module "aws" {
  source = "../../modules/aws"
  count  = var.aws_config != null ? 1 : 0

  # Core configuration from common
  environment = var.environment
  aws_region  = var.aws_config.aws_region
  vpc_cidr    = var.aws_config.vpc_cidr

  # Service configurations for this environment
  service_configurations = var.aws_config.service_configurations

  tags = {
    Environment = var.environment
    ManagedBy   = "terraform"
    Project     = locals.project_name
  }
}

# AWS Infrastructure Module

locals {
  # TODO (infra-setup): this must be setup in the route53 zone before running this playbook
  #  I set this up in my AWS account under a domain i control 
  hosted_zone_dns_name = "aws.krondor.org"

  # Map service policies to the format expected by the security module
  service_policies = flatten([
    for name, service in module.services.services :
    service.policy != null ? [{
      service_name = name
      role_id      = split("/", module.services_ecs.service_task_roles[name])[1]
      policy = {
        name = "${name}-permissions"
        type = "service"
        definition = {
          Version   = service.policy.Version
          Statement = service.policy.Statement
        }
      }
    }] : []
  ])
}

data "aws_route53_zone" "domain" {
  name = "${local.hosted_zone_dns_name}." # Note the trailing dot - this is required for exact zone name matching
}

# Networking
module "networking" {
  source = "./networking"

  environment        = var.environment
  aws_region         = var.aws_region
  vpc_cidr           = var.vpc_cidr
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b", "${var.aws_region}c"]

  tags = var.tags
}

# Load Balancer
module "loadbalancer" {
  source = "./loadbalancer"

  environment          = var.environment
  hosted_zone_dns_name = local.hosted_zone_dns_name
  vpc_id               = module.networking.vpc_id
  public_subnet_ids    = module.networking.public_subnet_ids
  route53_zone_id      = data.aws_route53_zone.domain.zone_id

  tags = var.tags
}

# Services module - manages all ECS services
module "services" {
  source = "./services"

  environment = var.environment
  service_configurations = var.service_configurations
}

# Backend API services ECS cluster
module "services_ecs" {
  source = "./ecs"

  environment        = var.environment
  aws_region         = var.aws_region
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids

  alb_security_group_id = module.loadbalancer.security_group_id
  lb_listener_arn       = module.loadbalancer.https_listener_arn

  ecs_cluster = {
    name                      = "services"
    capacity_providers        = ["FARGATE"]
    default_capacity_provider = "FARGATE"
  }

  # Pass the processed services to ECS module
  services = module.services.services

  tags = var.tags
}

# Keep security module for backward compatibility during transition
module "security" {
  source        = "./security"
  environment   = var.environment
  role_policies = local.service_policies
  tags          = var.tags
}

variable "environment" {
  description = "Environment name (staging, production)"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID for the ALB"
  type        = string
}

variable "lb_listener_arn" {
  description = "Load balancer listener ARN"
  type        = string
}

variable "ecs_cluster" {
  description = "ECS cluster configuration"
  type = object({
    name                      = string
    capacity_providers        = list(string)
    default_capacity_provider = string
  })
  default = {
    name                      = "default-cluster"
    capacity_providers        = ["FARGATE"]
    default_capacity_provider = "FARGATE"
  }
}

variable "services" {
  description = "Map of services to deploy on the ECS cluster"
  type = map(object({
    container = object({
      name         = string
      port         = number
      cpu          = number
      memory       = number
      repository   = string
      tag          = string
      health_check = optional(string)
      environment = list(object({
        name  = string
        value = string
      }))
      secrets = optional(list(object({
        name      = string
        valueFrom = string
      })))
      mount_points = optional(list(object({
        sourceVolume  = string
        containerPath = string
        readOnly      = optional(bool)
      })))
    })

    volumes = optional(list(object({
      name = string
      efs = optional(object({
        creation_token   = string
        encrypted        = bool
        performance_mode = string
        throughput_mode  = string
        root_directory   = string
        owner_uid        = string
        owner_gid        = string
        permissions      = string
      }))
    })))

    desired_count         = optional(number, 1)
    auto_scaling          = optional(bool, false)
    min_capacity          = optional(number, 1)
    max_capacity          = optional(number, 10)
    scaling_cpu_threshold = optional(number, 70)

    lb_listener_rule = optional(object({
      priority     = number
      path_pattern = list(string)
    }))

    policy = object({
      Version = string
      Statement = list(object({
        Effect   = string
        Action   = list(string)
        Resource = list(string)
      }))
    })
  }))
  default = {}
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

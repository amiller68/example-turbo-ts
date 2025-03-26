locals {
  # Project-wide constants
  project_name = "example-turbo"
}

variable "environment" {
  description = "Environment name (staging, production, etc.)"
  type        = string
  validation {
    # supported environments
    # TODO: support more environments
    condition     = contains(["production"], var.environment)
    error_message = "Environment must be one of: production"
  }
}

# AWS configuration
variable "aws_config" {
  description = "Configuration for AWS infrastructure"
  type = object({
    aws_region = string
    vpc_cidr   = string

    # Optional per-environment service configuration overrides
    #  NOTE: this is optional, and if not provided, the service will use the defaults +
    #  the service module's own defaults.
    service_configurations = optional(map(object({
      # Container configuration
      container = optional(object({
        cpu    = optional(number)
        memory = optional(number)
        environment = optional(list(object({
          name  = string
          value = string
        })))
        # NOTE: secrets are not supported, since they require a real secret manager value
        #  with an associated arn, which we would feasibly never pass in through here.
        #  If you need to pass in a secret, the current workaround for now is to pass it through
        #  the environment
      }))

      # Service configuration
      desired_count = optional(number)
      auto_scaling = optional(object({
        enabled       = optional(bool)
        min_capacity  = optional(number)
        max_capacity  = optional(number)
        cpu_threshold = optional(number)
      }))
      }))
    )

    tags = optional(map(string), {})
  })
  default = null
}

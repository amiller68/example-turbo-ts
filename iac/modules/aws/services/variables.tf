variable "environment" {
  description = "Environment name"
  type        = string
}

# Optional per-environment service configuration overrides
#  NOTE: this is optional, and if not provided, the service will use the defaults +
#  the service module's own defaults.
variable "service_configurations" {
  description = "Optional per-environment service configuration overrides"
  type = map(object({
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
  default = {}
}

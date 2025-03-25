variable "name" {
  description = "Name of the service"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "service" {
  description = "Base service configuration from each services respective module"
  type = object({
    # Container configuration
    container = object({
      cpu    = optional(number)
      memory = optional(number)
      # NOTE: name is just whatever we call this service in the service module map.
      #  It SHOULD respect the convention described in ../main.tf
      #   name   = optional(string)

      # NOTE: we don't support port override at the service level
      #  because it's not a service concern, and _defaults implements a pretty opinionated
      #  standard for how to handle it that should work for 99% of cases.
      # port         = optional(number)

      # NOTE: we don't support repository or tag override at the service level
      #  because it's not a service concern, and _defaults implements config that
      #  respects:
      #   - our lifecylce for ECRs (created outside of any given environment)
      #   - our naming strategy for ECRs (cannonical service name)
      #   - our standard tagging strategy (latest for production, otherwise latest-<env>)
      #   repository   = optional(string)
      #   tag          = optional(string)

      # NOTE: we don't support health check override at the service level (yet, at least, I can see
      #  some cases where it might be nice to have). For now, it's not necessary, and all services
      #  should use $BASE_PATH/_status/readyz as their health check.
      # health_check = optional(string)

      environment = optional(list(object({
        name  = string
        value = string
      })))
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

    # Service configuration
    desired_count = optional(number)
    auto_scaling = optional(object({
      enabled       = bool
      min_capacity  = number
      max_capacity  = number
      cpu_threshold = number
    }))

    # NOTE: we don't support load balancer configuration override at the service level
    #  because it's not a service concern, and _defaults implements a pretty opinionated
    #  standard for how to handle it that should work for 99% of cases.
    # lb_listener_rule = optional(object({
    #   priority     = number
    #   path_pattern = list(string)
    # }))

    # Infrastructure configuration (not overridable)
    volumes = optional(list(object({
      name = string
      efs = optional(object({
        creation_token   = string
        encrypted        = bool
        performance_mode = string
        throughput_mode  = string
        owner_uid        = string
        owner_gid        = string
        permissions      = string
        root_directory   = string
      }))
    })))

    # NOTE: each service should have a policy that is a list of statements.
    #  even if the statement list is empty.
    # policy = any
    policy = object({
      Version = string
      Statement = list(object({
        Effect   = string
        Action   = list(string)
        Resource = list(string)
      }))
    })
  })
}

# NOTE: see notes in ../variables.tf for what exactly we support here and why.
variable "override" {
  description = "Environment-specific overrides"
  type = object({
    # Container configuration
    container = optional(object({
      cpu    = optional(number)
      memory = optional(number)
      environment = optional(list(object({
        name  = string
        value = string
      })))
    }))

    # Service configuration
    desired_count = optional(number)
    auto_scaling = optional(object({
      enabled       = optional(bool)
      min_capacity  = optional(number)
      max_capacity  = optional(number)
      cpu_threshold = optional(number)
    }))
  })
  default = null
}

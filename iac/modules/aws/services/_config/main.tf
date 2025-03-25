# Get defaults for this specific service
module "defaults" {
  source      = "../_defaults"
  name        = var.name
  environment = var.environment
}

locals {
  # Start with service-specific config and apply defaults
  service_with_defaults = {
    # Container configuration with proper merge order
    container = {
      # Start with required fields that must exist
      name       = var.name
      repository = module.defaults.container.repository
      port       = module.defaults.container.port
      tag        = module.defaults.container.tag

      # CPU and memory must exist and can't be null 
      cpu    = coalesce(var.service.container.cpu, module.defaults.container.cpu)
      memory = coalesce(var.service.container.memory, module.defaults.container.memory)

      # Optional fields that can be null
      environment  = concat(coalesce(var.service.container.environment, []), module.defaults.container.environment)
      secrets      = var.service.container.secrets
      mount_points = var.service.container.mount_points
      health_check = module.defaults.container.health_check
    }

    # Service configuration (from defaults unless overridden)
    desired_count = coalesce(var.service.desired_count, module.defaults.service.desired_count)

    # Auto scaling - ECS module expects auto_scaling to be a bool and separate min/max/threshold fields
    auto_scaling          = coalesce(try(var.service.auto_scaling.enabled, null), module.defaults.service.auto_scaling)
    min_capacity          = coalesce(try(var.service.auto_scaling.min_capacity, null), module.defaults.service.min_capacity)
    max_capacity          = coalesce(try(var.service.auto_scaling.max_capacity, null), module.defaults.service.max_capacity)
    scaling_cpu_threshold = coalesce(try(var.service.auto_scaling.cpu_threshold, null), module.defaults.service.scaling_cpu_threshold)

    # Load balancer configuration
    lb_listener_rule = module.defaults.service.lb_listener_rule

    # Infrastructure configuration
    volumes = var.service.volumes

    policy = var.service.policy
  }

  # Apply any environment-specific overrides
  config = {
    container = {
      # Keep required fields
      name       = local.service_with_defaults.container.name
      repository = local.service_with_defaults.container.repository
      port       = local.service_with_defaults.container.port
      tag        = local.service_with_defaults.container.tag

      # CPU and memory overrides, falling back to service values
      cpu    = coalesce(try(var.override.container.cpu, null), local.service_with_defaults.container.cpu)
      memory = coalesce(try(var.override.container.memory, null), local.service_with_defaults.container.memory)

      # Optional fields
      environment  = concat(local.service_with_defaults.container.environment, coalesce(var.override.container.environment, []))
      secrets      = local.service_with_defaults.container.secrets
      mount_points = local.service_with_defaults.container.mount_points
      health_check = local.service_with_defaults.container.health_check
    },
    # Auto scaling overrides - keep flat structure for ECS module
    auto_scaling          = coalesce(try(var.override.auto_scaling.enabled, null), local.service_with_defaults.auto_scaling),
    min_capacity          = coalesce(try(var.override.auto_scaling.min_capacity, null), local.service_with_defaults.min_capacity),
    max_capacity          = coalesce(try(var.override.auto_scaling.max_capacity, null), local.service_with_defaults.max_capacity),
    scaling_cpu_threshold = coalesce(try(var.override.auto_scaling.cpu_threshold, null), local.service_with_defaults.scaling_cpu_threshold)

    volumes = local.service_with_defaults.volumes

    lb_listener_rule = local.service_with_defaults.lb_listener_rule

    policy = local.service_with_defaults.policy
  }
}

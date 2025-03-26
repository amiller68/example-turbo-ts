# Container configuration defaults for all services
output "container" {
  description = "Default container configuration"
  value = {
    port   = 3000
    cpu    = 256
    memory = 512
    # NOTE: as stated in ../main.tf, we use the service name for the repository name.
    #  It is very important that this repo exists before we try to use it here!
    repository   = var.name
    tag          = var.environment == "production" ? "latest" : "staging-latest"
    health_check = "/${var.name}/_status/readyz"
    # NOTE: you could override these, but these should be fine for all services.
    environment = [
      {
        name  = "ENV"
        value = var.environment
      },
      {
        name  = "BASE_PATH"
        value = "/${var.name}"
      }
    ]
  }
}

# Service configuration defaults for all services
output "service" {
  description = "Default service configuration"
  value = {
    description           = "${var.name} service"
    desired_count         = 1
    auto_scaling          = true
    min_capacity          = 1
    max_capacity          = 3
    scaling_cpu_threshold = 70
    lb_listener_rule = {
      path_pattern = ["/${var.name}/*"]
    }
  }
}

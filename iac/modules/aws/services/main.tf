# -----------------------------------------------------
# STEP 1: Declare service modules
# -----------------------------------------------------
# To add a new service:
# 1. Create a new directory under services/ with your service name
# 2. Add the module declaration here with standard inputs
# All services would require the following inputs:
# - aws_region
# - environment
# - tags
# but the rest is specific to each service! for convenience, we kinda just bundle
#  everything else in shared_resources, which can be passed through to each service.
# NOTE: it is VERY important that the service name we use is the same across:
#  - its directory name under /apps at the root of the repo
#  - the name for its ECR repo
#  - the name we use for it in the service_modules map below
# -----------------------------------------------------

# TODO (service-deploy): include your new service as a module here
module "example" {
  source = "./example"
}

# -----------------------------------------------------
# STEP 2: Register services and apply configuration
# -----------------------------------------------------
locals {
  # Map raw service outputs
  service_modules = {
    # TODO (service-deploy): include your new service as a module here
    "example" = module.example.service
  }
}

# -----------------------------------------------------
# STEP 3: Done! The following merges your service configs with:
# - defaults (from _defaults)
# - overrides (from environment specific config)
# -----------------------------------------------------

module "service_config" {
  source   = "./_config"
  for_each = local.service_modules

  name        = each.key
  service     = each.value
  environment = var.environment
  override    = try(var.service_configurations[each.key], null)
}

locals {
  services = {
    for name, config in module.service_config : name => config.config
  }
}

# TODO (service-deploy): implement your service here -- copy this directory to a
#  new directory with its same name under services/ and then add it to the
#  service_modules map in main.tf
#  #
locals {
  service = {
    # TODO (service-deploy): fill in your service configuration here
    #  This will set up your service with the defaults in _defaults, and
    #  whatever overrides you apply in the environment specific config.
    container = {}
    # TODO (service-deploy): If you need to define any policies, do so here.
    # policy = {
    #   Version = "2012-10-17"
    #   Statement = [
    #     ...
    #   ]
    # }
  }
}

output "service" {
  value = local.service
}

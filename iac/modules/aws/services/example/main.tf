# TODO (service-deploy): implement your service here -- copy this directory to a
#  new directory with its same name under services/ and then add it to the
#  service_modules map in main.tf
# TODO (service-deploy): fill in your required modules here. this is an example
#  using our example service. Container defaults are fine as is.
locals {
  service = { }
}

output "service" {
  value = local.service
}

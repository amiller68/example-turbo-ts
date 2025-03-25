# Import common variables
module "common" {
  source = "../common"

  # Only need to specify environment now
  environment = "production"

  # AWS configuration directly inline
  aws_config = {
    aws_region = var.aws_region
    vpc_cidr   = "10.0.0.0/16"

    # Service configurations
    service_configurations = {
      #  This is an example of setting a service's environment variable,
      #  but you can override alot of defaults as well. See ./iac/modules/aws/services/variables.tf
      #  for more details. For the example we'll just rely on the default auth key. 
      #  This is also where you'd set your logtail token if you wanted to use one
      # "example" = {
      #   container = {
      #     environment = [
      #       {
      #         name  = "EXAMPLE_AUTH_KEY"
      #         value = var.example_auth_key
      #       }
      #     ]
      #   }
      # }
    }
  }
}

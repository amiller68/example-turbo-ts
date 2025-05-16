# Import common variables
# module "common" {
#   source = "../common"
# 
#   # Only need to specify environment now
#   environment = "production"
# 
#   # AWS configuration directly inline
#   aws_config = {
#     aws_region = var.aws_region
#     vpc_cidr   = "10.0.0.0/16"
# 
#     # Service configurations
#     service_configurations = {
#       "example" = {
#         container = {
#           cpu    = 256
#           memory = 512
#         }
#       }
#     }
#   }
# }

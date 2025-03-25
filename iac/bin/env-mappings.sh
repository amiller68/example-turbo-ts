#!/bin/bash

# Map Infisical environment variables to Terraform variables
# Format: <INFISICAL_VAR_NAME>:<TF_VAR_<variable_name>>
MAPPINGS=(
  # Neon
  "NEON_ORGANIZATION_ID:TF_VAR_neon_organization_id"
  # Infisical
  "TERRAFORM_INFISICAL_CLIENT_ID:INFISICAL_UNIVERSAL_AUTH_CLIENT_ID"
  "TERRAFORM_INFISICAL_CLIENT_SECRET:INFISICAL_UNIVERSAL_AUTH_CLIENT_SECRET"
  "TERRAFORM_INFISICAL_PROJECT_ID:TF_VAR_infisical_project_id"
  # AWS
  # NOTE: we assume that access key and secret are set in infisical (or otherwise
  #  provided via other means), but don't require mapping them here.
  "AWS_REGION:TF_VAR_aws_region"
  # Image renderer secrets
  "IMAGE_RENDERER_AUTH_KEY:TF_VAR_image_renderer_auth_key"
  "IMAGE_RENDERER_LOG_TAIL_TOKEN:TF_VAR_image_renderer_log_tail_token"
  # TODO (service-deploy): add your new production service variables here
  # "YOUR_SERVICE_NAME_AUTH_KEY:TF_VAR_your_service_name_auth_key"
  # "YOUR_SERVICE_NAME_URL:TF_VAR_your_service_name_url"
)

# Environment name mappings
map_to_infisical_env() {
    local env=$1
    case $env in
        "staging")
            echo "staging"
            ;;
        "production")
            echo "prod"
            ;;
        "geo")
            echo "prod"
            ;;
        "development")
            echo "dev"
            ;;
        *)
            echo "$env"
            ;;
    esac
}

# Validate environment name
validate_env() {
    local env=$1
    case $env in
        staging|production|geo|development)
            return 0
            ;;
        *)
            echo "Error: Invalid environment '$env'"
            echo "Valid environments are: staging, production, geo, development"
            exit 1
            ;;
    esac
}
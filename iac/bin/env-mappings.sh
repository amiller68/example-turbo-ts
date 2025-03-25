#!/bin/bash

# Map environment variables to Terraform variables
# Format: <ENV_VAR_NAME>:<TF_VAR_<variable_name>>
MAPPINGS=(
    # AWS
    # NOTE: we assume that access key and secret are set in your hcp secrets (or otherwise
    #  provided via other means), but don't require mapping them here.
    "AWS_REGION:TF_VAR_aws_region"
)

# Validate environment name
validate_env() {
    local env=$1
    case $env in
    # TODO: support more envs
    production)
        return 0
        ;;
    *)
        echo "Error: Invalid environment '$env'"
        echo "Valid environments are: production"
        exit 1
        ;;
    esac
}


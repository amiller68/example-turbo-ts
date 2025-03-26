#!/bin/bash
set -e

# Get the directory where the script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../../../" && pwd)"

# Validate environment name
validate_env() {
    local env=$1
    case $env in
    production)
        return 0
        ;;
    *)
        echo "Error: Invalid environment '$env'"
        echo "Valid environments are: staging, production, geo, development"
        exit 1
        ;;
    esac
}

# Function to show usage
usage() {
    echo "Run integration tests against the image-renderer service"
    echo "Usage: $0 <stage>"
    echo "Supported environments: staging, production, development"
    echo ""
    echo "Examples:"
    echo "  $0 production"
    exit 1
}

if [ "$#" -lt 1 ]; then
    usage
fi

STAGE=$1

# Validate stage
validate_env "$STAGE"

echo "Running Examples tests in $STAGE environment"

# Export directory paths so they're available in the subshell
export SCRIPT_DIR
export PROJECT_ROOT

# Run tests with environment variables from Infisical
ENVIRONMENT="$STAGE"
SCRIPT_DIR=$SCRIPT_DIR
PROJECT_ROOT=$PROJECT_ROOT

# Source test utilities first
source "$SCRIPT_DIR/utils/test_utils.sh" || {
    echo "Error: Failed to source test_utils.sh"
    exit 1
}

# Run all test suites
source "$SCRIPT_DIR/suites/health.sh" || {
    echo "Error: Failed to run health tests"
    exit 1
}

source "$SCRIPT_DIR/suites/echo.sh" || {
    echo "Error: Failed to run echo tests"
    exit 1
}

echo "✅ All test suites completed!"


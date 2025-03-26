#!/bin/bash

# TODO (service-setup): setup the service integration tests here

# Utility functions for testing

# Assert equals
assert_equals() {
    local actual="$1"
    local expected="$2"
    local message="$3"

    if [ "$actual" == "$expected" ]; then
        echo "✅ $message"
    else
        echo "❌ $message"
        echo "Expected: $expected"
        echo "Actual: $actual"
        exit 1
    fi
}

# Assert contains
assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="$3"

    if [[ "$haystack" == *"$needle"* ]]; then
        echo "✅ $message"
    else
        echo "❌ $message"
        echo "Expected to find: $needle"
        echo "In: $haystack"
        exit 1
    fi
}

# Print test header
print_test_header() {
    local name="$1"
    echo ""
    echo "Running test: $name"
    echo "----------------------------------------"
}

# Verify required environment variables
verify_env() {
    if [ -z "$ENVIRONMENT" ]; then
        echo "Error: ENVIRONMENT variable is required"
        exit 1
    fi
}

# Get base URL for the service
get_base_url() {
    if [ "$ENVIRONMENT" == "production" ]; then
        echo "https://production.aws.krondor.org/example"
    elif [ "$ENVIRONMENT" == "development" ]; then
        echo "http://localhost:3000"
    else
        echo "http://localhost:3000"
    fi
}


#!/bin/bash

print_test_header "Health Check Tests"

# Verify environment setup
verify_env
BASE_URL=$(get_base_url)

# Test health check endpoint
test_name="Livez endpoint"
URL="$BASE_URL/_status/livez"
response=$(curl -s -w "%{http_code}" \
    -X GET \
    -H "Content-Type: application/json" \
    "$URL")
http_code=${response: -3}
body=${response:0:${#response}-3}

assert_equals "$http_code" "200" "$test_name - HTTP Status"
assert_contains "$body" "ok" "$test_name - Response body" 

test_name="Readyz endpoint"
URL="$BASE_URL/_status/readyz"
response=$(curl -s -w "%{http_code}" \
    -X GET \
    -H "Content-Type: application/json" \
    "$URL")
http_code=${response: -3}
body=${response:0:${#response}-3}

assert_equals "$http_code" "200" "$test_name - HTTP Status"
assert_contains "$body" "ok" "$test_name - Response body" 

test_name="Versionz endpoint"
URL="$BASE_URL/_status/versionz"
response=$(curl -s -w "%{http_code}" \
    -X GET \
    -H "Content-Type: application/json" \
    "$URL")
http_code=${response: -3}
body=${response:0:${#response}-3}

assert_equals "$http_code" "200" "$test_name - HTTP Status"
assert_contains "$body" "ok" "$test_name - Response body" 
#!/bin/bash

print_test_header "Echo API Tests"

# Verify environment setup
verify_env
BASE_URL=$(get_base_url)

fake_asset_id="tests::example::echo"

# Test basic echo
test_name="Basic echo"
response=$(curl -s -w "%{http_code}" \
    -X POST \
    -H "Content-Type: application/json" \
    -H "x-api-key: $EXAMPLE_AUTH_KEY" \
    "$BASE_URL/api/v0/echo" \
    -d "{
        \"message\": \"Hello, world!\"
    }")
http_code=${response: -3}
body=${response:0:${#response}-3}

assert_equals "$http_code" "200" "$test_name - HTTP Status"
assert_contains "$body" "message" "$test_name - Response contains message"
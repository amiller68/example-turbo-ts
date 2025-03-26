# Create IAM policies based on explicit service bindings
resource "aws_iam_role_policy" "service_policies" {
  # One IAM policy for each service-policy binding
  for_each = {
    for idx, binding in var.role_policies :
    "${binding.policy.name}" => binding
  }

  name   = "${var.environment}-${replace(each.value.policy.name, ":", "-")}"
  role   = each.value.role_id # Now receiving just the role name, not ARN
  policy = jsonencode(each.value.policy.definition)
}

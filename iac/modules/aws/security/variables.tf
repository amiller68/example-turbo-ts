variable "environment" {
  description = "Environment name"
  type        = string
}

# Simplified policy bindings - focus on the role and policy
variable "role_policies" {
  description = "Policies to attach to IAM roles"
  type = list(object({
    service_name = string
    role_id      = string
    policy = object({
      name = string
      type = string
      definition = object({
        Version   = string
        Statement = list(any)
      })
    })
  }))
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

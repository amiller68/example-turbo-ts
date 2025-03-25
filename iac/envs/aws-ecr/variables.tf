variable "services" {
  description = "List of service names to create repositories for"
  type        = list(string)
  # TODO (service-deploy): add your new services to this list in order to ensure
  #  its ECR repository is created. This must match the service name in turborepo
  default = ["image-renderer"] #, "example"
}

variable "default_lifecycle_policy" {
  description = "Default lifecycle policy to apply to all repositories"
  type        = string
  default     = <<EOF
{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last 10 images",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": 10
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}
EOF
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

# ECR Registry module
# Creates and manages ECR repositories
# #

resource "aws_ecr_repository" "repository" {
  for_each = toset(var.repository_names)

  name                 = each.key
  image_tag_mutability = var.image_tag_mutability

  image_scanning_configuration {
    scan_on_push = var.scan_on_push
  }

  encryption_configuration {
    encryption_type = var.encryption_type
    kms_key         = var.encryption_type == "KMS" ? var.kms_key_id : null
  }

  tags = merge(
    var.tags,
    {
      Name = each.key
    }
  )
}

# Create repository policy if provided
resource "aws_ecr_repository_policy" "policy" {
  for_each = {
    for name, policy in var.repository_policies : name => policy
    if contains(var.repository_names, name) && policy != ""
  }

  repository = aws_ecr_repository.repository[each.key].name
  policy     = each.value
}

# Lifecycle policy for repositories
resource "aws_ecr_lifecycle_policy" "lifecycle_policy" {
  for_each = {
    for name, policy in var.lifecycle_policies : name => policy
    if contains(var.repository_names, name) && policy != ""
  }

  repository = aws_ecr_repository.repository[each.key].name
  policy     = each.value
} 

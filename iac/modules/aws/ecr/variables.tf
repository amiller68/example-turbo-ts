variable "repository_names" {
  description = "List of ECR repository names to create"
  type        = list(string)
}

variable "image_tag_mutability" {
  description = "Image tag mutability setting for the repositories"
  type        = string
  default     = "MUTABLE"
  validation {
    condition     = contains(["MUTABLE", "IMMUTABLE"], var.image_tag_mutability)
    error_message = "Image tag mutability must be either MUTABLE or IMMUTABLE"
  }
}

variable "scan_on_push" {
  description = "Whether to scan images on push"
  type        = bool
  default     = true
}

variable "encryption_type" {
  description = "Encryption type for the repositories"
  type        = string
  default     = "AES256"
  validation {
    condition     = contains(["AES256", "KMS"], var.encryption_type)
    error_message = "Encryption type must be either AES256 or KMS"
  }
}

variable "kms_key_id" {
  description = "KMS key ID to use for encryption if encryption_type is KMS"
  type        = string
  default     = null
}

variable "repository_policies" {
  description = "Map of repository names to repository policies"
  type        = map(string)
  default     = {}
}

variable "lifecycle_policies" {
  description = "Map of repository names to lifecycle policies"
  type        = map(string)
  default     = {}
}

variable "tags" {
  description = "Tags to apply to all repositories"
  type        = map(string)
  default     = {}
}

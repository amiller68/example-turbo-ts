terraform {
  backend "s3" {
    bucket         = "example-turbo-ts-tf-state"
    key            = "ecr/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "example-turbo-ts-tf-state-lock"
  }
}

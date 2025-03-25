terraform {
  backend "remote" {
    organization = "example-turbo"

    workspaces {
      name = "production"
    }
  }
}

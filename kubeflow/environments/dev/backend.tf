# Terraform State Backend for Dev Environment

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}

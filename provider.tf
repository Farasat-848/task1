
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.18.1"
    }
  }
}

// Given the "Access Key" & "Secret Access Key" using the environment variables from terminal.
provider "aws" {

}



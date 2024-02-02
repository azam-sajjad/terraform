terraform {
  backend "s3" {
    bucket = "jenkins-server-statefile"
    key = "ami-statefile/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region                   = "us-east-1"
  shared_credentials_files = ["/home/azams/.aws/credentials"]
}
terraform {
  backend "s3" {
    bucket = "terra-devpro-state1"
    key    = "terraform/backend"
    region = "us-east-2"
  }
}
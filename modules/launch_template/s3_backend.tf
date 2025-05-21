terraform {
  backend "s3" {
    bucket         = "zaggle-s3-backend-terraform-bucket"
    key            = "launch_configuration/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "zaggle-terraform-state-locking"
    encrypt        = true
  }
}

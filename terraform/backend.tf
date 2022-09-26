#Backend for State File (S3)
terraform {
  backend "s3" {
    encrypt = true
    bucket  = "tf-state-go-project"
    key     = "terraform.tfstate"
    region  = "eu-west-1"
  }
}

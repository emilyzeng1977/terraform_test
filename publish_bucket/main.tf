provider "aws" {
  region        = "ap-southeast-2"
}

variable "name" {}

resource "aws_s3_bucket" "example" {
  bucket = "tom.niu14.example"
}

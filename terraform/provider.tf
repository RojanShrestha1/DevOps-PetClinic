terraform {
  backend "s3" {
    bucket = "gradle-state-129718466065-ap-south-1-an"
    key    = "dev/terraform.tfstate"
    region = "ap-south-1"

  }
}



terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"

}

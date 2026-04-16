provider "aws" {
    region = ""
}

module "my-vpc" {
  source = "./module/vpc"

  vpc-config = {
    cidr_block = "10.0.0.0/16"
    name = "test-vpc"
  }

  subnet-config = {
    "private-subnet" = {
        cidr_block = "10.0.0.0/24"
        name = "private-subnet"
        az = "eu-north-1a"
    }
    "public-subnet-1" = {
        cidr_block = "10.0.2.0/24"
        name = "public-subnet"
        public = true 
        az = "eu-north-1a"
    }
    "public-subnet-2" = {
        cidr_block = "10.0.1.0/24"
        name = "public-subnet"
        public = true 
        az = "eu-north-1a"
    }
  }

}
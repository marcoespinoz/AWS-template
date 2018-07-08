provider "aws" {
  region                  = "${var.region}"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"

  assume_role {
    role_arn = "arn:aws:iam::${var.cuenta}:role/CrossAccountSeidorTech"

    #role_arn = "arn:aws:iam::116332599801:role/CrossAccountSeidorTech"
  }
}

module "vpc" {
  source = "networking/"

  name = "${var.cliente}"

  cidr = "${var.cidr}"

  azs             = ["${var.azs}"]
  private_subnets = ["${var.private_subnets}"]
  public_subnets  = ["${var.public_subnets}"]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

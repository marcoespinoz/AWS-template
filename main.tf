provider "aws" {
  #Especificar region
  region                  = "sa-east-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

#setup remote terraform.state
terraform {
 backend "s3" {
 encrypt          = true
 bucket           = "terraform-remote-state-inka"
 region           = "sa-east-1"
 key              = "terraform.tfstate"
 }
}

module "vpc" {
  source          = "network/"
  name            = "CI"
  cidr            = "10.1.0.0/16"
  azs             = ["sa-east-1a", "sa-east-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24",  "10.1.4.0/24"]
  public_subnets  = ["10.1.5.0/24", "10.1.6.0/24"]
}

module "services" {
  source          = "services/"
  num_instancias  = 2
  ami             = "ami-0b04450959586da29"
  tipo_instancia  = "t2.micro"
  vpc_id = "${module.vpc.vpc_id}"
  sub_id = ["${module.vpc.sub_id}"]
}

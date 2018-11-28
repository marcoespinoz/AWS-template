#Esta es una prueba de git v3
provider "aws" {
  #CAMBIAR LA REGION#
  region = "us-east-1"

  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}

module "vpc" {
  source = "network/"

  #NOMBRE DE LA VPC
  name = "BASIS-DEMO"

  #BLOQUE DE IP PARA LA VPC
  cidr = "10.1.0.0/16"

  #ZONAS DE LA VPC Y REDES PRIVADAS Y PUBLICAS
  azs             = ["us-east-1a", "us-east-1b", "us-east-1c"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
  public_subnets  = ["10.1.4.0/24", "10.1.5.0/24"]
}

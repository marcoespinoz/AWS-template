#Esta es una prueba de git v2
provider "aws" {
  #CAMBIAR LA REGION#
  region = "us-east-1"

  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"

  assume_role {
    #CAMBIAR EL NUMERO CON EL CODIGO DE LA CUENTA AWS DEL CLIENTE DONDE SE DESEA DESPLEGAR LA NUEVA VPC
    role_arn = "arn:aws:iam::116332599801:role/CrossAccountSeidorTech"
  }
}

module "vpc" {
  source = "network/"

  #NOMBRE DE LA VPC
  name = "BASIS-DEMO"

  #BLOQUE DE IP PARA LA VPC
  cidr = "10.1.0.0/16"

  #ZONAS DE LA VPC Y REDES PRIVADAS Y PUBLICAS
  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.1.1.0/24", "10.1.2.0/24"]
  public_subnets  = ["10.1.3.0/24", "10.1.4.0/24"]

  tags = {
    Owner       = "user"
    Environment = "dev"
  }
}

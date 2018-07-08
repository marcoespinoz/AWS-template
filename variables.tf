#VALOR DE REGION Y ZONAS
variable "region" {
  default = "us-east-1"
}

variable "azs" {
  default = ["us-east-1a", "us-east-1b"]
}

#NUMERO DE LA CUENTA AWS DEL CLIENTE DONDE SE VA A DESPLEGAR LA VPC
variable "cuenta" {
  default = "116332599801"
}

#NOMBRE DEL CLINETE, ESTE NOMBRE SE USARA PARA NOMBRAR LA VPC
variable "cliente" {
  default = "BASIS-DEMO"
}

#BLOQUE DE DIRECCIONES IP A USAR EN LA VPC JUNTO A LAS REDES PRIVADAS Y PUBLICAS
variable "cidr" {
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "publicsubnets" {
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

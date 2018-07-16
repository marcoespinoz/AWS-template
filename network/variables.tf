variable "name" {
  description = "Nombre de los recursos creados en el VPC para su distincion"
  default     = ""
}

variable "cidr" {
  description = "Segmento de red de la VPC"
  default     = ""
}

variable "tags" {
  description = "Tags para variables"
  default     = {}
}

variable "azs" {
  description = "zonas AWS por region"
  default     = []
}

variable "map_public_ip_on_launch" {
  description = "Debe ser falso si no se quiere que AWS asigne una ip publica automaticamente al lanzar una instancia en una red publica"
  default     = true
}

variable "public_subnets" {
  default = []
}

variable "private_subnets" {
  default = []
}

variable "ami" {
  default = "ami-01623d7b"
}

variable "customerip" {
  default = ""
}

variable "static_routes" {
  default = []
}

variable "crear_vpn" {
  default = ""
}

variable "gateway_cliente" {
  default = []
}

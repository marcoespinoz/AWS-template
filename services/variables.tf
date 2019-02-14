variable "num_instancias" {
  default = 0
}

variable "tipo_instancia" {
  description = "Tipo de instancia a usar"
  default     = ""
}

variable "ami" {
  description = "Codigo de ami"
  default     = ""
}
variable "vpc_id" {
  default = ""
}

variable "sub_id" {
  default = []
}
variable "azs" {
  description = "zonas AWS por region"
  default     = ["sa-east-1a", "sa-east-1c"]
}

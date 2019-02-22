variable "num_instancias_front" {
  default = 0
}

variable "num_instancias_back" {
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

variable "azs" {
  description = "zonas AWS por region"
  default     = ["sa-east-1a", "sa-east-1c"]
}

variable "subprivate_id" {
  default = []
}

variable "subpublic_id" {
  default = []
}

variable "sec_backend_id" {
  default = []
}

variable "sec_frontend_id" {
  default = []
}
variable "sec_internal_id" {
  default = []
}

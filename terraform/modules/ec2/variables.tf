variable "vpc_id" {
  description = "ID de la VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID de la Subred publica"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia"
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "Nombre del proyecto"
  type        = string
  default     = "evaluacion-devops"
}

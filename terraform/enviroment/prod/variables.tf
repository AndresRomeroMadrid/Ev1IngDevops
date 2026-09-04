variable "vpc_cidr" {
  description = "CIDR block for the production VPC"
  type        = string
  default     = "10.1.0.0/16"
}

variable "vpc_name" {
  description = "Name tag for the production VPC"
  type        = string
  default     = "prod-vcp"
}

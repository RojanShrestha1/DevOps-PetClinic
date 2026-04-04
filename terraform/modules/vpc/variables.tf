variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_1a_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "public_subnet_1b_cidr" {
  type    = string
  default = "10.0.2.0/24"
}
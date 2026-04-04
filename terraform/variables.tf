variable "aws_region" {
  type    = string
  default = "ap-south-1"
}

variable "vpc_cidr_root" {
  type = string
}

variable "pub_sub_1a_cidr" {
  type = string
}

variable "pub_sub_1b_cidr" {
  type = string
}

variable "project_name" {
  description = "The name of our Gradle project"
  type        = string
  default     = "gradle-project"
}
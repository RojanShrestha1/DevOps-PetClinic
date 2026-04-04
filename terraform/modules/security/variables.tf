variable "vpc_id" {
  description = "The ID of the VPC from our VPC module"
  type        = string
}

variable "project_name" {
  type    = string
  default = "Gradle-Project"
}

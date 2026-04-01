# The Region where everything lives
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-1"
}

# The Main VPC Network Block
variable "vpc_cidr" {
  description = "Main VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

# The Availability Zones
variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}
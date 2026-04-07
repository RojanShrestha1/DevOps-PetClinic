variable "project_name" {}
variable "ec2_sg_id" {
  description = "The SG ID that allows 8080 from the ALB"
}
variable "public_subnets" {
  type = list(string)
}

variable "target_group_arns" {
  type        = list(string)
  description = "The ARN of the Target Group from the ALB module"
}


variable "ami_id" {
  description = "The AMI ID passed from the root module"
  type        = string
}
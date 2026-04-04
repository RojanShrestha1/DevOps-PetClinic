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
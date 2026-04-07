variable "project_name" {
  type        = string
  description = "Project name for resource tagging"
}

variable "ami_id" {
  type        = string
  description = "Ubuntu AMI ID passed from the root module"
}

variable "subnet_id" {
  type        = string
  description = "The Public Subnet ID where the monitor will live"
}

variable "monitoring_sg_id" {
  type        = string
  description = "The Security Group ID for Prometheus/Grafana"
}

variable "key_name" {
  type        = string
  description = "The SSH key pair name (e.g., My_cloud)"
}


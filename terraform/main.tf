data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Official Canonical ID

  filter {
    name   = "name"
    # This matches the standard 64-bit Ubuntu 22.04 LTS
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}


module "vpc" {
  source = "./modules/vpc"


  vpc_cidr              = var.vpc_cidr_root
  public_subnet_1a_cidr = var.pub_sub_1a_cidr
  public_subnet_1b_cidr = var.pub_sub_1b_cidr
}

module "security" {
  source = "./modules/security"

  # We take the OUTPUT from the VPC module and plug it into Security
  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}


# 4. Compute Module (Update this to use the ALB output)
module "compute" {
  source            = "./modules/compute"
  project_name      = var.project_name
  ec2_sg_id         = module.security.ec2_sg_id
  ami_id            = data.aws_ami.ubuntu.id
  public_subnets    = module.vpc.public_subnet_ids
  target_group_arns = [module.alb.tg_arn] # Now this 'alb' module exists!
}

# 3. ALB (The Missing Piece!)
module "alb" {
  source         = "./modules/alb"
  project_name   = var.project_name
  vpc_id         = module.vpc.vpc_id
  alb_sg_id      = module.security.alb_sg_id
  public_subnets = module.vpc.public_subnet_ids
}


# 6. Monitoring (The New Addition)
module "monitoring" {
  source                    = "./modules/monitoring"
  project_name              = var.project_name
  ami_id                    = data.aws_ami.ubuntu.id
  subnet_id                 = module.vpc.public_subnet_ids[0]
  monitoring_sg_id          = module.security.monitoring_sg_id
  key_name                  = "My_cloud"
}

# Also add this to your ROOT outputs.tf to see the IP in your terminal
output "monitoring_url" {
  value = "http://${module.monitoring.monitoring_public_ip}:3000"
}
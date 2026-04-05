
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
output "vpc_id_from_root" {
  value = module.vpc.vpc_id
}

output "subnet_ids_from_root" {
  value = module.vpc.public_subnet_ids
}
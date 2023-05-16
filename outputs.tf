output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = module.vpc.private_subnets
}

output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = module.vpc.public_subnets
}


output "vote_service_sg_id" {
  value = module.vote_service_sg.security_group_id
}

output "bean-elb-sg_id" {
  value = module.bean-elb-sg.security_group_id
}

output "backend_sg" {
  value = module.backend_sg.security_group_id
}

output "prod_sg" {
  value = module.prod_sg.security_group_id
}

output "key_pair_name" {
  description = "The key pair name"
  value       = module.key_pair.key_pair_name
}


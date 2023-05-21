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

output "backend_sg" {
  value = module.backend_sg.security_group_id
}

output "key_pair_name" {
  description = "The key pair name"
  value       = aws_key_pair.webpress.key_name
}

output "bastion_host_ip" {
  value = aws_instance.bastion.public_ip
  description = "Public IP of the bastion host."
}

output "app_instance_ips" {
  value = [for inst in module.ec2_instance : data.aws_instance.created_instances[inst.id].public_ip]
  description = "Public IPs of the app instances."
}


provider "aws" {
  region = "us-east-1"
}

module "vcp" {
  source   = "../../modules/vcp"
  
  vpc_cidr = var.vpc_cidr
  vpc_name = var.vpc_name
}

module "ec2" {
  source    = "../../modules/ec2"
  vpc_id    = module.vcp.vpc_id
  subnet_id = module.vcp.public_subnet_id
}

output "ec2_public_ip" {
  value = module.ec2.public_ip
}

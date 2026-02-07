# Configure the AWS provider
provider "aws" {
  region = "ap-northeast-1"
}

# Set Local Variables for Availability Zones
locals {
  az1 = "ap-northeast-1a"
  az2 = "ap-northeast-1c"
}

# Create the VPC Network Setup
module "Network-Setup" {
  source = "./modules/Network-Setup"

  az1                    = local.az1
  az2                    = local.az2
  vpc_cidr_addr          = "10.0.0.0/16"
  private_subnet_cidr_01 = "10.0.1.0/24"
  private_subnet_cidr_02 = "10.0.2.0/24"
  private_subnet_cidr_03 = "10.0.3.0/24"
  private_subnet_cidr_04 = "10.0.4.0/24"
}

# Create the EC2 for RDS Access and TABLE Management
module "EC2-Setup" {
  source                = "./modules/EC2-Setup"
  az1                   = local.az1 
  private_subnet_id_01  = module.Network-Setup.private_subnet_id_01
  ec2_sg_id             = module.Network-Setup.ec2_sg_id

  depends_on = [module.Network-Setup]
}

# Create the RDS for postgresql
module "RDS-Setup" {
  source          = "./modules/RDS-Setup"

  private_subnet_id_03 = module.Network-Setup.private_subnet_id_03
  private_subnet_id_04 = module.Network-Setup.private_subnet_id_04
  rds_sg_id            = module.Network-Setup.rds_sg_id
  az1                  = local.az1
  az2                  = local.az2

  depends_on = [module.Network-Setup]
}   

# Create the Lambda Function
module "Lambda-Setup" {
  source           = "./modules/Lambda-Setup"
  
  private_subnet_id_01  = module.Network-Setup.private_subnet_id_01
  private_subnet_id_02  = module.Network-Setup.private_subnet_id_02
  lambda_sg_id          = module.Network-Setup.lambda_sg_id 

  secret_ARN        = module.RDS-Setup.secret_ARN
  secret_Name       = module.RDS-Setup.secret_name
  dbname            = module.RDS-Setup.dbname
  dbhost            = module.RDS-Setup.dbhost
  port_number       = module.RDS-Setup.port

  depends_on = [module.RDS-Setup]
}

module "ALB-Setup" {
  source           = "./modules/ALB-Setup"

  private_subnet_id_01   = module.Network-Setup.private_subnet_id_01
  private_subnet_id_02   = module.Network-Setup.private_subnet_id_02
  alb_sg_id              = module.Network-Setup.alb_sg_id
  lambda_arn             = module.Lambda-Setup.lambda_arn
  lambda_function_name   = module.Lambda-Setup.lambda_function_name

  depends_on = [module.Lambda-Setup]

}

module "Route53-Setup"{
  source = "./modules/Route53-Setup"

  vpc_id       = module.Network-Setup.vpc_id
  alb_dns_name = module.ALB-Setup.alb-dns
  alb_zone_id  = module.ALB-Setup.alb-zone-id

  depends_on = [module.ALB-Setup]
}

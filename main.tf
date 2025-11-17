
# VPC Module
module "vpc" {
  source      = "./modules/vpc"
  name        = var.name
  environment = var.environment
  vpc_cidr    = var.vpc_cidr
  azs         = var.azs
  region      = var.region
}


# Security Module
module "security" {
  source = "./modules/security"
  name        = var.name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  rds_port    = 5432
  redis_port  = 6379
  kafka_port  = 9092

  allowed_rds_sg_ids   = [module.ecs.ecs_sg_id]
  allowed_redis_sg_ids = [module.ecs.ecs_sg_id]
  allowed_msk_sg_ids   = [module.ecs.ecs_sg_id]
}


# IAM Module
module "iam" {
  source = "./modules/iam"
  name        = var.name
  environment = var.environment
}


# ECS Module
module "ecs" {
  source = "./modules/ecs"
  cluster_name = var.name
  environment  = var.environment
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  private_subnets = module.vpc.private_subnets
  alb_sg_id    = module.security.alb_sg_id
  services     = var.services
  execution_role_arn = module.iam.ecs_task_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
}

# RDS Module
module "rds" {
  source = "./modules/rds"
  name        = var.name
  environment = var.environment
  private_subnets     = module.vpc.private_subnets
  security_group_ids  = [module.security.rds_sg_id]
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password
}


# Redis Module
module "redis" {
  source = "./modules/redis"
  name        = var.name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  allowed_sg_ids  = [module.security.ecs_sg_id]
}


# MSK Module
module "msk" {
  source = "./modules/msk"
  name        = var.name
  environment = var.environment
  vpc_id      = module.vpc.vpc_id
  private_subnets = module.vpc.private_subnets
  allowed_sg_ids  = [module.security.ecs_sg_id]
  cloudwatch_log_group = var.msk_log_group
}

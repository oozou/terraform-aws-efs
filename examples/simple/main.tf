module "efs" {
  source = "../.."

  # Generics
  prefix      = "customer"
  environment = "dev"
  name        = "demo"

  vpc_id    = "vpc-xxxxxxxx"
  subnets   = ["subnet-xxxxxx","subnet-xxxxxx"]


  enabled_backup = true
  efs_backup_policy_enabled = true


  tags = {
    "Workspace" = "custom-workspace"
  }
}
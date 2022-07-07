module "efs" {
  source = "../.."

  # Generics
  prefix      = "complete"
  environment = "dev"
  name        = "demo"

  vpc_id    = "vpc-xxxxxxxx"
  subnets   = ["subnet-xxxxxxxx","subnet-xxxxxxxx"]


  performance_mode = "maxIO"
  encrypted = true
  enabled_backup = true
  efs_backup_policy_enabled = true
  transition_to_ia = ["AFTER_7_DAYS"]
  transition_to_primary_storage_class = ["AFTER_1_ACCESS"]

  access_points = {
    "data" = {
      posix_user = {
        gid            = "1001"
        uid            = "5000"
        secondary_gids = "1002,1003"
      }
      creation_info = {
        gid         = "1001"
        uid         = "5000"
        permissions = "0755"
      }
    }
  }
  additional_cluster_security_group_ingress_rules = [{
    from_port                = 2049
    to_port                  = 2049
    protocol                 = "tcp"
    cidr_blocks              = ["10.105.0.0/16"]
    description              = "test"
  }]


  tags = {
    "Workspace" = "custom-workspace"
  }
}
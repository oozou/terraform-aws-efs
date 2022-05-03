locals {
  enabled        = var.is_created_efs
  enabled_backup = var.enabled_backup
  service_name   = "${var.prefix}-${var.environment}-${var.name}"

  # Returning null in the lookup function gives type errors and is not omitting the parameter.
  # This work around ensures null is returned.
  posix_users = {
    for k, v in var.access_points :
    k => lookup(var.access_points[k], "posix_user", {})
  }
  secondary_gids = {
    for k, v in var.access_points :
    k => lookup(local.posix_users[k], "secondary_gids", null)
  }

  tags = merge(
    {
      "Environment" = var.environment,
      "Terraform"   = "true"
    },
    var.tags
  )
}

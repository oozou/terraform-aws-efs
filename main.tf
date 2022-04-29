/* -------------------------------------------------------------------------- */
/*                                   Volume                                   */
/* -------------------------------------------------------------------------- */
resource "aws_efs_file_system" "default" {
  count                           = var.enabled ? 1 : 0
  availability_zone_name          = var.availability_zone_name
  encrypted                       = var.encrypted
  kms_key_id                      = var.kms_key_id
  performance_mode                = var.performance_mode
  provisioned_throughput_in_mibps = var.provisioned_throughput_in_mibps
  throughput_mode                 = var.throughput_mode

  tags = merge({
    Name = "${local.service_name}-efs"
  }, local.tags)

  dynamic "lifecycle_policy" {
    for_each = length(var.transition_to_ia) > 0 ? [1] : []
    content {
      transition_to_ia = try(var.transition_to_ia[0], null)
    }
  }

  dynamic "lifecycle_policy" {
    for_each = length(var.transition_to_primary_storage_class) > 0 ? [1] : []
    content {
      transition_to_primary_storage_class = try(var.transition_to_primary_storage_class[0], null)
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                        Mount Target and Access Point                       */
/* -------------------------------------------------------------------------- */
resource "aws_efs_mount_target" "default" {
  count          = local.enabled && length(var.subnets) > 0 ? length(var.subnets) : 0
  file_system_id = join("", aws_efs_file_system.default.*.id)
  ip_address     = var.mount_target_ip_address
  subnet_id      = var.subnets[count.index]
  security_groups = compact(
    (concat(
      [aws_security_group.efs.id],
      var.associated_security_group_ids
    ))
  )
}

resource "aws_efs_access_point" "default" {
  for_each = local.enabled ? var.access_points : {}

  file_system_id = join("", aws_efs_file_system.default.*.id)

  dynamic "posix_user" {
    for_each = local.posix_users[each.key] != null ? ["true"] : []

    content {
      gid            = local.posix_users[each.key]["gid"]
      uid            = local.posix_users[each.key]["uid"]
      secondary_gids = local.secondary_gids[each.key] != null ? split(",", local.secondary_gids[each.key]) : null
    }
  }

  root_directory {
    path = "/${each.key}"

    dynamic "creation_info" {
      for_each = try(var.access_points[each.key]["creation_info"]["gid"], "") != "" ? ["true"] : []

      content {
        owner_gid   = var.access_points[each.key]["creation_info"]["gid"]
        owner_uid   = var.access_points[each.key]["creation_info"]["uid"]
        permissions = var.access_points[each.key]["creation_info"]["permissions"]
      }
    }
  }

  tags = merge({
    Name = "${local.service_name}-efs-ap"
  }, local.tags)
}

/* -------------------------------------------------------------------------- */
/*                                Backup Policy                               */
/* -------------------------------------------------------------------------- */
resource "aws_efs_backup_policy" "policy" {
  count = local.enabled_backup ? 1 : 0

  file_system_id = join("", aws_efs_file_system.default.*.id)

  backup_policy {
    status = var.efs_backup_policy_enabled ? "ENABLED" : "DISABLED"
  }
}
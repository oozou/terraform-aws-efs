output "access_point_arns" {
  value       = local.enabled ? { for arn in sort(keys(var.access_points)) : arn => aws_efs_access_point.default[arn].arn } : null
  description = "EFS AP ARNs"
}

output "access_point_ids" {
  value       = local.enabled ? { for id in sort(keys(var.access_points)) : id => aws_efs_access_point.default[id].id } : null
  description = "EFS AP ids"
}

output "arn" {
  value       = local.enabled ? join("", aws_efs_file_system.default.*.arn) : null
  description = "EFS ARN"
}

output "id" {
  value       = local.enabled ? join("", aws_efs_file_system.default.*.id) : null
  description = "EFS ID"
}

output "dns_name" {
  value       = local.enabled ? join("", aws_efs_file_system.default.*.dns_name) : null
  description = "The DNS name for the filesystem"
}

output "mount_target_dns_names" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.mount_target_dns_name, [""]) : null
  description = "List of EFS mount target DNS names"
}

output "mount_target_ids" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.id, [""]) : null
  description = "List of EFS mount target IDs (one per Availability Zone)"
}

output "mount_target_ips" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.ip_address, [""]) : null
  description = "List of EFS mount target IPs (one per Availability Zone)"
}

output "network_interface_ids" {
  value       = local.enabled ? coalescelist(aws_efs_mount_target.default.*.network_interface_id, [""]) : null
  description = "List of mount target network interface IDs"
}

output "security_group_id" {
  value       = aws_security_group.efs.id
  description = "EFS Security GroupID"
}

output "security_group_client_id" {
  value       = aws_security_group.client.id
  description = "EFS Security Group Client ID"
}

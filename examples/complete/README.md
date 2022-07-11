<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_efs"></a> [efs](#module\_efs) | ../.. | n/a |

## Resources

No resources.

## Inputs

No inputs.

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_efs_arn"></a> [efs\_arn](#output\_efs\_arn) | EFS ARN |
| <a name="output_efs_id"></a> [efs\_id](#output\_efs\_id) | EFS ID |
| <a name="output_efs_mount_target_dns_names"></a> [efs\_mount\_target\_dns\_names](#output\_efs\_mount\_target\_dns\_names) | List of EFS mount target DNS names |
| <a name="output_efs_mount_target_ids"></a> [efs\_mount\_target\_ids](#output\_efs\_mount\_target\_ids) | List of EFS mount target IDs (one per Availability Zone) |
| <a name="output_efs_mount_target_ips"></a> [efs\_mount\_target\_ips](#output\_efs\_mount\_target\_ips) | List of EFS mount target IPs (one per Availability Zone) |
| <a name="output_efs_network_interface_ids"></a> [efs\_network\_interface\_ids](#output\_efs\_network\_interface\_ids) | List of mount target network interface IDs |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | EFS Security Group ID |
<!-- END_TF_DOCS -->
# terraform-aws-efs

```terraform
module "efs_storage" {
  source = "./modules/efs"

  # Generics
  prefix      = "customer"
  environment = "dev"
  name        = "demo"

  vpc_id    = var.vpc_id
  subnets   = var.database_subnet_ids

  associated_security_group_ids = ["sg-0049e34f3dbd35286"]
  
  enabled_backup = true
  efs_backup_policy_enabled = true

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

  tags = {
    "Workspace" = "custom-workspace"
  }
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.00 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >= 2.3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 4.11.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_efs_access_point.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point) | resource |
| [aws_efs_backup_policy.policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_backup_policy) | resource |
| [aws_efs_file_system.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_file_system) | resource |
| [aws_efs_mount_target.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_mount_target) | resource |
| [aws_security_group.client](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.efs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.egress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_environment"></a> [environment](#input\_environment) | Environment Variable used as a prefix | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the EFS cluster to create | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix name of customer to be displayed in AWS console and resource | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | Subnet IDs | `list(string)` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID | `string` | n/a | yes |
| <a name="input_access_points"></a> [access\_points](#input\_access\_points) | A map of the access points you would like in your EFS volume<br>See [examples/complete] for an example on how to set this up.<br>All keys are strings. The primary keys are the names of access points.<br>The secondary keys are `posix_user` and `creation_info`.<br>The secondary\_gids key should be a comma separated value.<br>More information can be found in the terraform resource [efs\_access\_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point). | `map(map(map(any)))` | `{}` | no |
| <a name="input_associated_security_group_ids"></a> [associated\_security\_group\_ids](#input\_associated\_security\_group\_ids) | A list of IDs of Security Groups to associate the EFS Mount Targets with, in addition to the created security group.<br>These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access. | `list(string)` | `[]` | no |
| <a name="input_availability_zone_name"></a> [availability\_zone\_name](#input\_availability\_zone\_name) | AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes. If set, a single subnet in the same availability zone should be provided to `subnets` | `string` | `null` | no |
| <a name="input_efs_backup_policy_enabled"></a> [efs\_backup\_policy\_enabled](#input\_efs\_backup\_policy\_enabled) | If `true`, it will turn on automatic backups. | `bool` | `false` | no |
| <a name="input_enabled"></a> [enabled](#input\_enabled) | Enable EFS | `bool` | `true` | no |
| <a name="input_enabled_backup"></a> [enabled\_backup](#input\_enabled\_backup) | Enable Backup EFS | `bool` | `false` | no |
| <a name="input_encrypted"></a> [encrypted](#input\_encrypted) | If true, the file system will be encrypted | `bool` | `true` | no |
| <a name="input_kms_key_id"></a> [kms\_key\_id](#input\_kms\_key\_id) | If set, use a specific KMS key | `string` | `null` | no |
| <a name="input_mount_target_ip_address"></a> [mount\_target\_ip\_address](#input\_mount\_target\_ip\_address) | The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target | `string` | `null` | no |
| <a name="input_performance_mode"></a> [performance\_mode](#input\_performance\_mode) | The file system performance mode. Can be either `generalPurpose` or `maxIO` | `string` | `"generalPurpose"` | no |
| <a name="input_provisioned_throughput_in_mibps"></a> [provisioned\_throughput\_in\_mibps](#input\_provisioned\_throughput\_in\_mibps) | The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned | `number` | `0` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys | `map(any)` | `{}` | no |
| <a name="input_throughput_mode"></a> [throughput\_mode](#input\_throughput\_mode) | Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps` | `string` | `"bursting"` | no |
| <a name="input_transition_to_ia"></a> [transition\_to\_ia](#input\_transition\_to\_ia) | Indicates how long it takes to transition files to the Infrequent Access (IA) storage class. Valid values: AFTER\_7\_DAYS, AFTER\_14\_DAYS, AFTER\_30\_DAYS, AFTER\_60\_DAYS and AFTER\_90\_DAYS. Default (no value) means "never". | `list(string)` | `[]` | no |
| <a name="input_transition_to_primary_storage_class"></a> [transition\_to\_primary\_storage\_class](#input\_transition\_to\_primary\_storage\_class) | Describes the policy used to transition a file from Infrequent Access (IA) storage to primary storage. Valid values: AFTER\_1\_ACCESS. | `list(string)` | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

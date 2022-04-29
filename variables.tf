

/* -------------------------------------------------------------------------- */
/*                                   Generic                                  */
/* -------------------------------------------------------------------------- */
variable "name" {
  description = "Name of the EFS cluster to create"
  type        = string
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
}

variable "prefix" {
  description = "The prefix name of customer to be displayed in AWS console and resource"
  type        = string
}

variable "tags" {
  description = "Custom tags which can be passed on to the AWS resources. They should be key value pairs having distinct keys"
  type        = map(any)
  default     = {}
}

/* -------------------------------------------------------------------------- */
/*                                     EFS                                    */
/* -------------------------------------------------------------------------- */
variable "vpc_id" {
  type        = string
  description = "VPC ID"
}

variable "subnets" {
  type        = list(string)
  description = "Subnet IDs"
}

variable "enabled" {
  type        = bool
  description = "Enable EFS"
  default     = true
}

variable "enabled_backup" {
  type        = bool
  description = "Enable Backup EFS"
  default     = false
}

variable "access_points" {
  type        = map(map(map(any)))
  default     = {}
  description = <<-EOT
    A map of the access points you would like in your EFS volume
    See [examples/complete] for an example on how to set this up.
    All keys are strings. The primary keys are the names of access points.
    The secondary keys are `posix_user` and `creation_info`.
    The secondary_gids key should be a comma separated value.
    More information can be found in the terraform resource [efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point).
    EOT
}

variable "performance_mode" {
  type        = string
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  type        = number
  default     = 0
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
}

variable "throughput_mode" {
  type        = string
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  default     = "bursting"
}

variable "mount_target_ip_address" {
  type        = string
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
  default     = null
}

variable "transition_to_ia" {
  type        = list(string)
  description = "Indicates how long it takes to transition files to the Infrequent Access (IA) storage class. Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS and AFTER_90_DAYS. Default (no value) means \"never\"."
  default     = []
  validation {
    condition = (
      length(var.transition_to_ia) == 1 ? contains(["AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS"], var.transition_to_ia[0]) : length(var.transition_to_ia) == 0
    )
    error_message = "Var `transition_to_ia` must either be empty list or one of \"AFTER_7_DAYS\", \"AFTER_14_DAYS\", \"AFTER_30_DAYS\", \"AFTER_60_DAYS\", \"AFTER_90_DAYS\"."
  }
}

variable "transition_to_primary_storage_class" {
  type        = list(string)
  description = "Describes the policy used to transition a file from Infrequent Access (IA) storage to primary storage. Valid values: AFTER_1_ACCESS."
  default     = []
  validation {
    condition = (
      length(var.transition_to_primary_storage_class) == 1 ? contains(["AFTER_1_ACCESS"], var.transition_to_primary_storage_class[0]) : length(var.transition_to_primary_storage_class) == 0
    )
    error_message = "Var `transition_to_primary_storage_class` must either be empty list or \"AFTER_1_ACCESS\"."
  }
}

variable "efs_backup_policy_enabled" {
  type        = bool
  description = "If `true`, it will turn on automatic backups."
  default     = false
}

variable "availability_zone_name" {
  type        = string
  description = "AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes. If set, a single subnet in the same availability zone should be provided to `subnets`"
  default     = null
}

/* -------------------------------------------------------------------------- */
/*                                 Encryption                                 */
/* -------------------------------------------------------------------------- */
variable "encrypted" {
  type        = bool
  description = "If true, the file system will be encrypted"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "If set, use a specific KMS key"
  default     = null
}

/* -------------------------------------------------------------------------- */
/*                               Security Group                               */
/* -------------------------------------------------------------------------- */
variable "associated_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to associate the EFS Mount Targets with, in addition to the created security group.
    These security groups will not be modified and, if `create_security_group` is `false`, must have rules providing the desired access.
    EOT
}
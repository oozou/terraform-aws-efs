

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
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "Subnet IDs"
  type        = list(string)
}

variable "is_created_efs" {
  description = "Is create EFS"
  type        = bool
  default     = true
}

variable "enabled_backup" {
  description = "Enable Backup EFS"
  type        = bool
  default     = false
}

variable "access_points" {
  description = <<-EOT
    A map of the access points you would like in your EFS volume
    See [examples/complete] for an example on how to set this up.
    All keys are strings. The primary keys are the names of access points.
    The secondary keys are `posix_user` and `creation_info`.
    The secondary_gids key should be a comma separated value.
    More information can be found in the terraform resource [efs_access_point](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/efs_access_point).
    EOT
  type        = map(map(map(any)))
  default     = {}
}

variable "performance_mode" {
  description = "The file system performance mode. Can be either `generalPurpose` or `maxIO`"
  type        = string
  default     = "generalPurpose"
}

variable "provisioned_throughput_in_mibps" {
  description = "The throughput, measured in MiB/s, that you want to provision for the file system. Only applicable with `throughput_mode` set to provisioned"
  type        = number
  default     = 0
}

variable "throughput_mode" {
  description = "Throughput mode for the file system. Defaults to bursting. Valid values: `bursting`, `provisioned`. When using `provisioned`, also set `provisioned_throughput_in_mibps`"
  type        = string
  default     = "bursting"
}

variable "mount_target_ip_address" {
  description = "The address (within the address range of the specified subnet) at which the file system may be mounted via the mount target"
  type        = string
  default     = null
}

variable "transition_to_ia" {
  description = "Indicates how long it takes to transition files to the Infrequent Access (IA) storage class. Valid values: AFTER_7_DAYS, AFTER_14_DAYS, AFTER_30_DAYS, AFTER_60_DAYS and AFTER_90_DAYS. Default (no value) means \"never\"."
  type        = list(string)
  default     = []
  validation {
    condition = (
      length(var.transition_to_ia) == 1 ? contains(["AFTER_7_DAYS", "AFTER_14_DAYS", "AFTER_30_DAYS", "AFTER_60_DAYS", "AFTER_90_DAYS"], var.transition_to_ia[0]) : length(var.transition_to_ia) == 0
    )
    error_message = "Var `transition_to_ia` must either be empty list or one of \"AFTER_7_DAYS\", \"AFTER_14_DAYS\", \"AFTER_30_DAYS\", \"AFTER_60_DAYS\", \"AFTER_90_DAYS\"."
  }
}

variable "transition_to_primary_storage_class" {
  description = "Describes the policy used to transition a file from Infrequent Access (IA) storage to primary storage. Valid values: AFTER_1_ACCESS."
  type        = list(string)
  default     = []
  validation {
    condition = (
      length(var.transition_to_primary_storage_class) == 1 ? contains(["AFTER_1_ACCESS"], var.transition_to_primary_storage_class[0]) : length(var.transition_to_primary_storage_class) == 0
    )
    error_message = "Var `transition_to_primary_storage_class` must either be empty list or \"AFTER_1_ACCESS\"."
  }
}

variable "efs_backup_policy_enabled" {
  description = "If `true`, it will turn on automatic backups."
  type        = bool
  default     = false
}

variable "availability_zone_name" {
  description = "AWS Availability Zone in which to create the file system. Used to create a file system that uses One Zone storage classes. If set, a single subnet in the same availability zone should be provided to `subnets`"
  type        = string
  default     = null
}

variable "additional_efs_resource_policies" {
  description = "Additional IAM policies block, input as data source. Ref: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document"
  type        = list(string)
  default     = []
}

variable "bypass_policy_lockout_safety_check" {
  description = "A flag to indicate whether to bypass the aws_efs_file_system_policy lockout safety check. The policy lockout safety check determines whether the policy in the request will prevent the principal making the request will be locked out from making future PutFileSystemPolicy requests on the file system. Set bypass_policy_lockout_safety_check to true only when you intend to prevent the principal that is making the request from making a subsequent PutFileSystemPolicy request on the file system. The default value is false."
  type        = bool
  default     = false
}

/* -------------------------------------------------------------------------- */
/*                                 Encryption                                 */
/* -------------------------------------------------------------------------- */
variable "encrypted" {
  description = "If true, the file system will be encrypted"
  type        = bool
  default     = true
}

variable "kms_key_id" {
  description = "If set, use a specific KMS key"
  type        = string
  default     = null
}

/* -------------------------------------------------------------------------- */
/*                               Security Group                               */
/* -------------------------------------------------------------------------- */
variable "additional_cluster_security_group_ingress_rules" {
  description = "Additional ingress rule for cluster security group."
  type        = list(any)
  default     = []
}

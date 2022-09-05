# Change Log

All notable changes to this module will be documented in this file.

## [v1.0.3] - 2022-09-05

### Added

- Add variable `var.additional_efs_resource_policies`
- Add variable `var.bypass_policy_lockout_safety_check`
- Add data `data.aws_caller_identity.this`
- Add data `data.aws_region.this`
- Add data `data.aws_iam_policy_document.efs_resource_based_policy`
- Add data `data.aws_iam_policy_document.this` to merge `data.aws_iam_policy_document.efs_resource_based_policy[0].json` with variables `additional_efs_resource_policies`
- Add resource `aws_efs_file_system_policy.policy`

## [v1.0.2] - 2022-07-11

### Added

- LICENSE
- CONTRIBUTING.md
- Examples
  - simple
  - complete

### Updated

- rename security.tf to sg.tf


## [v1.0.1] - 2022-07-07


### Added

- Outputs
  - `dns_name`

## [v1.0.0] - 2022-06-31

### Added

- init terraform-aws-efs

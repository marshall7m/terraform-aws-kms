variable "create_key" {
  description = "Determines if key should be created"
  type        = bool
  default     = true
}

variable "account_id" {
  description = "AWS account ID used to define the root ARN that will have user permissions for the key"
  type        = string
}

variable "alias" {
  description = "Alias to attach to key"
  type        = string
  default     = null
}

variable "key_usage" {
  description = "Intended use of key"
  type        = string
  default     = "ENCRYPT_DECRYPT"
}

variable "deletion_window_in_days" {
  description = "Duration of days before the key is deleted and after the resource is deleted"
  type        = number
  default     = 30
}

variable "is_enabled" {
  description = "Determines if the key is available"
  type        = bool
  default     = true
}

variable "enable_key_rotation" {
  description = "Determines if key rotation is enabled"
  type        = bool
  default     = null
}

variable "customer_master_key_spec" {
  description = ""
  type        = string
  default     = "SYMMETRIC_DEFAULT"
}

variable "tags" {
  description = "Tags to attach to the CMK"
  type        = map(string)
  default     = {}
}

variable "trusted_admin_arns" {
  description = "AWS IAM users that will have admin permissions associated with key"
  type        = list(string)
}

variable "trusted_user_usage_arns" {
  description = "AWS IAM users that will have access to use the key"
  type        = list(string)
  default     = []
}

variable "trusted_user_usage_conditions" {
  description = "IAM conditions for AWS users to use the key"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "trusted_service_usage_principals" {
  description = "AWS service principals that will have access to use the key (e.g. `logs.region.amazonaws.com`)"
  type        = list(string)
  default     = []
}

variable "trusted_service_usage_conditions" {
  description = "IAM conditions for AWS service principals to use the key"
  type = list(object({
    test     = string
    variable = string
    values   = list(string)
  }))
  default = []
}

variable "statements" {
  description = "IAM policy statements for cmk"
  type = list(object({
    sid       = optional(string)
    effect    = string
    actions   = list(string)
    resources = list(string)
    principals = optional(list(object({
      type        = string
      identifiers = list(string)
    })))
    conditions = optional(list(object({
      test     = string
      variable = string
      values   = list(string)
    })))
  }))
}

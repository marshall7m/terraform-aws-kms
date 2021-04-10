variable "account_id" {
  description = "Test AWS Account ID"
  type        = string
}

provider "random" {}

locals {
  cw_name = "mut-cmk-${random_id.this.id}"
}

resource "random_id" "this" {
  byte_length = 8
}

resource "aws_cloudwatch_log_group" "this" {
  name       = local.cw_name
  kms_key_id = module.mut_cmk.arn
}

module "mut_cmk" {
  source                           = "../../modules//cmk"
  account_id                       = var.account_id
  trusted_admin_arns               = ["arn:aws:iam::${var.account_id}:role/cross-account-admin-access"]
  trusted_user_usage_arns          = ["arn:aws:iam::${var.account_id}:role/cross-account-admin-access"]
  trusted_service_usage_principals = ["logs.us-west-2.amazonaws.com"]

  trusted_service_usage_conditions = [
    {
      test     = "ArnLike"
      variable = "kms:EncryptionContext:aws:logs:arn"
      values = [
        "arn:aws:logs:us-west-2:${var.account_id}:log-group:${local.cw_name}"
      ]
    }
  ]

  statements = [
    {
      sid    = "AliasCreation"
      effect = "Allow"
      principals = [
        {
          type        = "AWS"
          identifiers = ["*"]
        }
      ]
      actions   = ["kms:CreateAlias"]
      resources = ["*"]
      conditions = [
        {
          test     = "StringEquals"
          variable = "kms:ViaService"
          values   = ["ec2.region.amazonaws.com"]
        },
        {
          test     = "StringEquals"
          variable = "kms:CallerAccount"
          values   = [var.account_id]
        }
      ]
    }
  ]
}
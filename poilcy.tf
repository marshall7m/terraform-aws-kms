locals {
  statements = [for statement in var.statements : defaults(statement, {
    principals = {}
    conditions = {}
  })]
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "this" {
  statement {
    sid     = "EnableUserPermissions"
    effect  = "Allow"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.id}:root"]
    }
    resources = ["*"]
  }

  statement {
    sid    = "AdminPermissions"
    effect = "Allow"
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    principals {
      type        = "AWS"
      identifiers = var.trusted_admin_arns
    }
    resources = ["*"]
  }

  dynamic "statement" {
    for_each = length(var.trusted_service_usage_principals) > 0 ? [1] : []
    content {
      sid    = "ServiceUsagePermissions"
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]

      principals {
        type        = "Service"
        identifiers = var.trusted_service_usage_principals
      }

      resources = ["*"]

      dynamic "condition" {
        for_each = var.trusted_service_usage_conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }

  dynamic "statement" {
    for_each = length(var.trusted_user_usage_arns) > 0 ? [1] : []
    content {
      sid    = "UserUsagePermissions"
      effect = "Allow"
      actions = [
        "kms:Encrypt",
        "kms:Decrypt",
        "kms:ReEncrypt*",
        "kms:GenerateDataKey*",
        "kms:DescribeKey"
      ]
      principals {
        type        = "AWS"
        identifiers = var.trusted_user_usage_arns
      }
      resources = ["*"]
      dynamic "condition" {
        for_each = var.trusted_user_usage_conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
  dynamic "statement" {
    for_each = length(var.trusted_user_usage_arns) > 0 ? [1] : []
    content {
      sid    = "GrantPermissions"
      effect = "Allow"
      actions = [
        "kms:CreateGrant",
        "kms:ListGrants",
        "kms:RevokeGrant"
      ]
      principals {
        type        = "AWS"
        identifiers = var.trusted_user_usage_arns
      }
      resources = ["*"]

      condition {
        test     = "Bool"
        variable = "kms:GrantIsForAWSResource"
        values   = ["true"]
      }
    }
  }

  dynamic "statement" {
    for_each = toset(local.statements)
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = statement.value.resources

      dynamic "principals" {
        for_each = statement.value.principals
        content {
          type        = principals.value.type
          identifiers = principals.value.identifiers
        }
      }
      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}
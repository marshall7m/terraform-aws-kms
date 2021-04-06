data "aws_iam_policy_document" "this" {
  statement {
    sid     = "EnableUserPermissions"
    effect  = "Allow"
    actions = ["kms:*"]
    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.account_id}:root"]
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

  statement {
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

  statement {
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

  statement {
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
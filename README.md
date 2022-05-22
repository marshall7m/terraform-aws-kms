# Terraform AWS KMS

Terraform module that provisions AWS resources to create an AWS KMS key

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.15.0 |
| aws | >= 2.23 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 2.23 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| alias | Alias to attach to key | `string` | `null` | no |
| create\_key | Determines if key should be created | `bool` | `true` | no |
| customer\_master\_key\_spec | n/a | `string` | `"SYMMETRIC_DEFAULT"` | no |
| deletion\_window\_in\_days | Duration of days before the key is deleted and after the resource is deleted | `number` | `30` | no |
| enable\_key\_rotation | Determines if key rotation is enabled | `bool` | `null` | no |
| is\_enabled | Determines if the key is available | `bool` | `true` | no |
| key\_usage | Intended use of key | `string` | `"ENCRYPT_DECRYPT"` | no |
| statements | IAM policy statements for cmk | <pre>list(object({<br>    sid       = optional(string)<br>    effect    = string<br>    actions   = list(string)<br>    resources = list(string)<br>    principals = optional(list(object({<br>      type        = string<br>      identifiers = list(string)<br>    })))<br>    conditions = optional(list(object({<br>      test     = string<br>      variable = string<br>      values   = list(string)<br>    })))<br>  }))</pre> | `[]` | no |
| tags | Tags to attach to the CMK | `map(string)` | `{}` | no |
| trusted\_admin\_arns | AWS IAM users that will have admin permissions associated with key | `list(string)` | n/a | yes |
| trusted\_service\_usage\_conditions | IAM conditions for AWS service principals to use the key | <pre>list(object({<br>    test     = string<br>    variable = string<br>    values   = list(string)<br>  }))</pre> | `[]` | no |
| trusted\_service\_usage\_principals | AWS service principals that will have access to use the key (e.g. `logs.region.amazonaws.com`) | `list(string)` | `[]` | no |
| trusted\_user\_usage\_arns | AWS IAM users that will have access to use the key | `list(string)` | `[]` | no |
| trusted\_user\_usage\_conditions | IAM conditions for AWS users to use the key | <pre>list(object({<br>    test     = string<br>    variable = string<br>    values   = list(string)<br>  }))</pre> | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| arn | AWS CMK ARN |
| id | Globally unique ID for CMK |


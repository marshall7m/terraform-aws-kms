module "mut_aws_kms" {
  source             = "../../..//"
  trusted_admin_arns = ["arn:aws:iam:123456789012:role/test"]
}
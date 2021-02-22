include {
  path = find_in_parent_folders()
}

terraform {
    source = "../../modules//cmk"
}

locals {
  aws_vars = read_terragrunt_config(find_in_parent_folders("aws.hcl"))
  account_id = local.aws_vars.locals.account_id
}

inputs = {
    account_id = local.account_id
    trusted_admin_arns = ["arn:aws:iam::${local.account_id}:role/cross-account-admin-access"]
    trusted_usage_arns = ["arn:aws:iam::${local.account_id}:role/cross-account-admin-access"]
}
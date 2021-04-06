include {
  path = find_in_parent_folders()
}

locals {
  aws_vars   = read_terragrunt_config(find_in_parent_folders("aws.hcl"))
  account_id = local.aws_vars.locals.account_id
}

inputs = {
  account_id = local.account_id
}
export AWS_ACCESS_KEY_ID='<redacted-aws-access-key-id>'
export AWS_SECRET_ACCESS_KEY='<redacted-aws-secret-access-key>'
export AWS_REGION='us-east-1'
export TF_VAR_aws_account="846429350492"
# Could gnerated by the user
export TF_VAR_vault_token="<value>"
# Vault Path: kvv2/rosa/ocm-token
export TF_VAR_ocm_token="<redacted-jwt>"
# Vault Path: kvv2/git/github/pat
export TF_VAR_git_token="<redacted-github-pat>"

export TF_VAR_tfstate_s3_bucket_name="rosa-classic-tfstates"
export TF_VAR_vpc_cidr_block="10.50.0.0/16"
export TF_VAR_private_subnet_cidrs='["10.50.1.0/24", "10.50.2.0/24", "10.50.3.0/24"]'
export TF_VAR_public_subnet_cidrs='["10.50.101.0/24", "10.50.102.0/24", "10.50.103.0/24"]'

export TF_VAR_business_unit="engineering"
export TF_VAR_cost_center="1010101010"
export TF_VAR_aws_region="us-east-1"
export TF_VAR_openshift_environment="dev"
export TF_VAR_base_dns_domain="non-prod.${TF_VAR_business_unit}.example.com"

export TF_VAR_cluster_name="rosa-primary" # Max str length 15 characters
export TF_WORKSPACE="${TF_VAR_business_unit}-${TF_VAR_openshift_environment}"

export TF_VAR_acmhub_cluster_name="noset"
export TF_VAR_ocp_version="4.15.9"
export TF_VAR_acmhub_cluster_env="dev"

export TF_VAR_create_account_roles=true # Set value to false if account_roles already exists.
export TF_VAR_admin_creds_save_to_vault=false # Set value to true if you have vaut instance

export TF_LOG="info"
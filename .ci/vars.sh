export AWS_ACCESS_KEY_ID='<value>'
export AWS_SECRET_ACCESS_KEY='<value>'
export AWS_REGION='us-east-1'
export TF_VAR_aws_account="<value>"
# Could gnerated by the user
export TF_VAR_vault_token="<value>"
# Vault Path: kvv2/rosa/ocm-token
export TF_VAR_ocm_token="<value>"
# Vault Path: kvv2/git/github/pat
export TF_VAR_git_token="<value>"

export TF_VAR_tfstate_s3_bucket_name="rosa-sts-tfstate"
export TF_VAR_cluster_name="rosa-classic-101"
export TF_VAR_business_unit="market-rd"
export TF_VAR_cost_center="1010101010"
export TF_VAR_aws_region="us-east-1"
export TF_VAR_openshift_environment="dev"
export TF_VAR_base_dns_domain="non-prod.market-rd.example.com"
export TF_VAR_acmhub_cluster_name="noset"
export TF_VAR_ocp_version="4.15.5"
export TF_VAR_acmhub_cluster_env="dev"

export TF_VAR_create_account_roles=true # Set value to false if AWS account comes with account_roles already installed.
export TF_VAR_admin_creds_save_to_vault=false # Set value to true if you have vaut instance

export TF_LOG="info"
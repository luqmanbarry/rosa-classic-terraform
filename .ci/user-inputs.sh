export AWS_ACCESS_KEY_ID="<required>"
export AWS_SECRET_ACCESS_KEY="<required>"
export AWS_REGION="us-east-2"
export TF_VAR_tfstate_bucket_region="us-east-1"
export TF_VAR_aws_account="<required>"
# Vault Path: kv/rosa/ocm-token
export TF_VAR_ocm_token="<required>"
# Vault Path: kv/git/github/pat
# The repository must exist. Update the code if you're using SCM vendor othen than GitHub.
export TF_VAR_git_token="<required>"

export TF_VAR_cluster_name="lb-classic-1092" # Max str length 15 characters
export TF_VAR_tfstate_s3_bucket_name="rosa-classic-tfstate"
export TF_VAR_vpc_cidr_block="10.92.0.0/16"
export TF_VAR_machine_type="m5.xlarge"
export TF_VAR_worker_node_replicas=3
export TF_VAR_min_replicas=6 # FOR AUTOSCALING
export TF_VAR_max_replicas=30 # FOR AUTOSCALING

export TF_VAR_business_unit="rnd"
export TF_VAR_cost_center="1010101010"
export TF_VAR_aws_region="${AWS_REGION}"
export TF_VAR_openshift_environment="dev"
export TF_VAR_base_dns_domain="non-prod.${TF_VAR_business_unit}.example.com"

export TF_ENV="${TF_VAR_openshift_environment}-${TF_VAR_cluster_name}"

export TF_VAR_acmhub_cluster_name="classic-acm-hub"
export TF_VAR_ocp_version="4.15.14"
export TF_VAR_acmhub_cluster_env="dev"

export TF_VAR_create_account_roles=true # Set value to false if account_roles already exists.

export TF_VAR_admin_creds_save_to_vault=false # Set value to true if you have vaut instance
# VAULT INFO MUST BE SET IF admin_creds_save_to_vault=true
export TF_VAR_vault_token="<redacted-vault-token>" # Could gnerated by the user
export TF_VAR_vault_addr="https://vault.apps.classic-acm-hub.dlhq.p1.openshiftapps.com" # Change this to your vault address - Use .ci/vault-deploy.sh to deploy one inside OCP

export TF_LOG="info"
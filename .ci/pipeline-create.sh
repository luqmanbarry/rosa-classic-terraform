#!/bin/bash

set -e

echo "=================================================="
echo "==> AWS Authentication"
echo "=================================================="
export AWS_ACCESS_KEY_ID='<value>'
export AWS_SECRET_ACCESS_KEY='<value'
export AWS_REGION='us-east-2'

aws sts get-caller-identity

echo "#########################################################################################################"
echo "=================================================="
echo "==> Set Environment Variables"
echo "=================================================="
export WORKING_DIRECTORY="$(pwd)"
export TF_VAR_tfstate_s3_bucket_name="rosa-sts-tfstate"
export TF_VAR_cluster_name="rosa-sts-100"
export TF_VAR_business_unit="redhat"
export TF_VAR_cost_center="1010101010"
export TF_VAR_aws_region="us-east-2"
export TF_VAR_openshift_environment="dev"
export TF_VAR_base_dns_domain="non-prod.sales.example.com"
# export TF_VAR_base_dns_domain="w47a.p1.openshiftapps.com"
# export TF_VAR_base_dns_domain="non-prod.sales.rosa-7wc76.2ecu.p1.openshiftapps.com"
export TF_VAR_ocp_version="4.15.5"
export TF_VAR_acmhub_cluster_env="dev"

export TF_VAR_git_token="<value>"
export TF_VAR_vault_token="<value>"
export TF_VAR_acmhub_cluster_name="<value>"
export TF_VAR_ocm_token="<value>"
export TF_VAR_aws_account="<value>"

# export TF_LOG="debug"
echo "#########################################################################################################"
TF_MODULE="tfstate-config"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/admin/admin.tfvars"
echo "=================================================="
echo "==> Module - $TF_MODULE"
echo "=================================================="

cd "${TF_MODULE}"
terraform init
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
TF_MODULE="account-setup"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/admin/admin.tfvars"
echo "=================================================="
echo "==> Module - $TF_MODULE"
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
TF_MODULE="tfvars-prep"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/admin/admin.tfvars"
echo "=================================================="
echo "==> Module - $TF_MODULE"
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -reconfigure \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
TF_MODULE="git-tfvars-file"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/${TF_VAR_business_unit}/${TF_VAR_aws_account}/${TF_VAR_cluster_name}.tfvars"
echo "=================================================="
echo "==> Module - $TF_MODULE"
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
TF_MODULE="rosa-sts"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/${TF_VAR_business_unit}/${TF_VAR_aws_account}/${TF_VAR_cluster_name}.tfvars"
echo "=================================================="
echo "==> Module - $TF_MODULE"
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
TF_MODULE="kube-config"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/${TF_VAR_business_unit}/${TF_VAR_aws_account}/${TF_VAR_cluster_name}.tfvars"
echo "=================================================="
echo "===========> Module - $TF_MODULE "
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
set +e # Expected to fail when adding Route53 record (invalid dns_domain)
TF_MODULE="custom-ingress"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/${TF_VAR_business_unit}/${TF_VAR_aws_account}/${TF_VAR_cluster_name}.tfvars"
echo "=================================================="
echo "===========> Module - $TF_MODULE "
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

echo "#########################################################################################################"
TF_MODULE="vault-k8s-auth"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/${TF_VAR_business_unit}/${TF_VAR_aws_account}/${TF_VAR_cluster_name}.tfvars"
echo "=================================================="
echo "===========> Module - $TF_MODULE "
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"
set +e

echo "#########################################################################################################"
TF_MODULE="acmhub-registration"
BACKEND_KEY="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}.tfstate"
BACKEND_PATH="tf-state/${TF_VAR_cluster_name}/${TF_MODULE}"
TFVARS_FILE="../tfvars/${TF_VAR_business_unit}/${TF_VAR_aws_account}/${TF_VAR_cluster_name}.tfvars"
echo "=================================================="
echo "===========> Module - $TF_MODULE "
echo "=================================================="

cd "${TF_MODULE}"
terraform init \
  -backend-config="bucket=${TF_VAR_tfstate_s3_bucket_name}" \
  -backend-config="key=${BACKEND_KEY}" \
  -backend-config="region=${AWS_REGION}"
terraform plan -out "$TF_MODULE.plan" -var-file="$TFVARS_FILE"
terraform apply "$TF_MODULE.plan"
cd "${WORKING_DIRECTORY}"

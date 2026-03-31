#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF' >&2
usage: write_backend_config.sh --cluster-dir <path> --output <path>

Required environment variables:
  TF_BACKEND_BUCKET
  TF_BACKEND_REGION
  TF_BACKEND_DYNAMODB_TABLE

Optional environment variables:
  TF_BACKEND_KEY_PREFIX
  TF_BACKEND_KMS_KEY_ID
  TF_BACKEND_ROLE_ARN
EOF
}

cluster_dir=""
output_file=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cluster-dir)
      cluster_dir="${2:-}"
      shift 2
      ;;
    --output)
      output_file="${2:-}"
      shift 2
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$cluster_dir" || -z "$output_file" ]]; then
  usage
  exit 2
fi

required_vars=(
  TF_BACKEND_BUCKET
  TF_BACKEND_REGION
  TF_BACKEND_DYNAMODB_TABLE
)

for required_var in "${required_vars[@]}"; do
  if [[ -z "${!required_var:-}" ]]; then
    echo "missing required environment variable: ${required_var}" >&2
    exit 1
  fi
done

key_prefix="${TF_BACKEND_KEY_PREFIX:-}"
state_key="${cluster_dir}/terraform.tfstate"
if [[ -n "$key_prefix" ]]; then
  state_key="${key_prefix%/}/${state_key}"
fi

mkdir -p "$(dirname "$output_file")"

{
  printf 'bucket = "%s"\n' "${TF_BACKEND_BUCKET}"
  printf 'region = "%s"\n' "${TF_BACKEND_REGION}"
  printf 'dynamodb_table = "%s"\n' "${TF_BACKEND_DYNAMODB_TABLE}"
  printf 'key = "%s"\n' "${state_key}"
  printf 'encrypt = true\n'

  if [[ -n "${TF_BACKEND_KMS_KEY_ID:-}" ]]; then
    printf 'kms_key_id = "%s"\n' "${TF_BACKEND_KMS_KEY_ID}"
  fi

  if [[ -n "${TF_BACKEND_ROLE_ARN:-}" ]]; then
    printf 'role_arn = "%s"\n' "${TF_BACKEND_ROLE_ARN}"
  fi
} > "${output_file}"

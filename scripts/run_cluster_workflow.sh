#!/usr/bin/env bash

set -euo pipefail

usage() {
  cat <<'EOF' >&2
usage: run_cluster_workflow.sh --cluster-dir <path> --artifact-dir <path> --mode <validate|plan|apply> [--backend true|false] [--backend-config-file <path>]
EOF
}

CLUSTER_DIR=""
ARTIFACT_DIR=""
MODE=""
BACKEND="false"
BACKEND_CONFIG_FILE=""
SKIP_TOOL_CHECK="${ROSA_FACTORY_SKIP_TOOL_CHECK:-false}"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --cluster-dir)
      CLUSTER_DIR="${2:-}"
      shift 2
      ;;
    --artifact-dir)
      ARTIFACT_DIR="${2:-}"
      shift 2
      ;;
    --mode)
      MODE="${2:-}"
      shift 2
      ;;
    --backend)
      BACKEND="${2:-}"
      shift 2
      ;;
    --backend-config-file)
      BACKEND_CONFIG_FILE="${2:-}"
      shift 2
      ;;
    *)
      usage
      exit 2
      ;;
  esac
done

if [[ -z "$CLUSTER_DIR" || -z "$ARTIFACT_DIR" || -z "$MODE" ]]; then
  usage
  exit 2
fi

if [[ ! -d "$CLUSTER_DIR" ]]; then
  echo "cluster directory not found: $CLUSTER_DIR" >&2
  exit 1
fi

case "$MODE" in
  validate|plan|apply)
    ;;
  *)
    echo "unsupported mode: $MODE" >&2
    exit 1
    ;;
esac

if [[ "$SKIP_TOOL_CHECK" != "true" ]]; then
  scripts/check_required_ci_tools.sh bash git jq python3 terraform helm rg oc
fi

mkdir -p "$ARTIFACT_DIR"

python3 scripts/validate_stack_inputs.py \
  --cluster-dir "$CLUSTER_DIR"

python3 scripts/render_effective_config.py \
  --cluster "$CLUSTER_DIR/cluster.yaml" \
  --gitops "$CLUSTER_DIR/gitops.yaml" \
  --output-dir "$ARTIFACT_DIR"

cp "$ARTIFACT_DIR/terraform.auto.tfvars.json" "$CLUSTER_DIR/terraform.auto.tfvars.json"

if [[ "$BACKEND" == "true" ]]; then
  if [[ -n "$BACKEND_CONFIG_FILE" ]]; then
    terraform -chdir="$CLUSTER_DIR" init -backend-config="$BACKEND_CONFIG_FILE"
  else
    terraform -chdir="$CLUSTER_DIR" init
  fi
else
  terraform -chdir="$CLUSTER_DIR" init -backend=false
fi

terraform -chdir="$CLUSTER_DIR" validate

case "$MODE" in
  validate)
    ;;
  plan)
    terraform -chdir="$CLUSTER_DIR" plan -out=tfplan
    terraform -chdir="$CLUSTER_DIR" show -json tfplan > "$ARTIFACT_DIR/terraform-plan.json"
    terraform -chdir="$CLUSTER_DIR" show -no-color tfplan > "$ARTIFACT_DIR/terraform-plan.txt"
    ;;
  apply)
    terraform -chdir="$CLUSTER_DIR" plan -out=tfplan
    terraform -chdir="$CLUSTER_DIR" show -json tfplan > "$ARTIFACT_DIR/terraform-plan.json"
    terraform -chdir="$CLUSTER_DIR" show -no-color tfplan > "$ARTIFACT_DIR/terraform-plan.txt"
    terraform -chdir="$CLUSTER_DIR" apply -auto-approve tfplan
    terraform -chdir="$CLUSTER_DIR" output -json > "$ARTIFACT_DIR/terraform-outputs.json"
    ;;
esac

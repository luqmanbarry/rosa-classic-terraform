# Execution Models

This document explains five common ways to run this repo:

- GitHub Actions
- Azure Pipelines
- bastion host
- Ansible Automation Platform (AAP)
- Terraform CLI

All five patterns use the same Git inputs:

- `clusters/<group-path>/<cluster>/cluster.yaml`
- `clusters/<group-path>/<cluster>/gitops.yaml`
- `clusters/<group-path>/<cluster>/values/*.yaml`

Reusable execution files in this repo:

- [`scripts/run_cluster_workflow.sh`](/Users/luqman/workspace/guides/rosa-classic-terraform/scripts/run_cluster_workflow.sh)
- [`scripts/run_cluster_workflow_bastion.sh`](/Users/luqman/workspace/guides/rosa-classic-terraform/scripts/run_cluster_workflow_bastion.sh)
- [`scripts/write_backend_config.sh`](/Users/luqman/workspace/guides/rosa-classic-terraform/scripts/write_backend_config.sh)
- [`scripts/list_changed_clusters_json.sh`](/Users/luqman/workspace/guides/rosa-classic-terraform/scripts/list_changed_clusters_json.sh)
- [`scripts/check_required_ci_tools.sh`](/Users/luqman/workspace/guides/rosa-classic-terraform/scripts/check_required_ci_tools.sh)
- [`.github/workflows/factory.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/.github/workflows/factory.yml)
- [`azure-pipelines.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/azure-pipelines.yml)
- [`playbooks/aap/run_cluster_workflow.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/playbooks/aap/run_cluster_workflow.yml)
- [`docs/operations/aap-execution.example.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/docs/operations/aap-execution.example.yml)

## Shared Requirements

These items must be ready no matter where you run the code:

- the cluster files are complete
- values files exist for every GitOps app you enable
- required `externalSecrets` entries are defined before you enable secret-consuming modules
- the execution environment has these tools:
  - `bash`
  - `git`
  - `jq`
  - `python3`
  - `terraform`
  - `helm`
  - `rg`
  - `oc`
- you have AWS access for Terraform
- you have a valid ROSA or OCM token
- you have access to the GitOps repo if it is private
- if you use remote Terraform state, you have these backend values ready:
  - `TF_BACKEND_BUCKET`
  - `TF_BACKEND_REGION`
  - `TF_BACKEND_DYNAMODB_TABLE`
  - optional `TF_BACKEND_KEY_PREFIX`
  - optional `TF_BACKEND_KMS_KEY_ID`
  - optional `TF_BACKEND_ROLE_ARN`

Tool check:

```bash
scripts/check_required_ci_tools.sh bash git jq python3 terraform helm rg oc
```

Common execution flow:

```text
Validate cluster files
  -> render effective config
  -> write terraform.auto.tfvars.json
  -> terraform init
  -> terraform validate
  -> terraform plan
  -> terraform apply
```

Example cluster path used below:

```text
clusters/dev/classic-100
```

## Pattern 1: GitHub Actions

Use this pattern when GitHub is your source control and deployment runner.

### Setup Prerequisites

- GitHub repository with Actions enabled
- runners with network access to AWS, ROSA, and your GitOps repo
- repository secrets such as:
  - `OCM_TOKEN`
  - `AWS_ROLE_TO_ASSUME` for OIDC, or `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY`
  - optional `AWS_SESSION_TOKEN`
  - optional Vault and private Git repo secrets when your stack needs them
- repository or environment variables:
  - `AWS_REGION`
  - `TF_BACKEND_BUCKET`
  - `TF_BACKEND_REGION`
  - `TF_BACKEND_DYNAMODB_TABLE`
  - optional `TF_BACKEND_KEY_PREFIX`
  - optional `TF_BACKEND_KMS_KEY_ID`
  - optional `TF_BACKEND_ROLE_ARN`
- GitHub environment `rosa-classic-apply` configured with required reviewers

### How It Works

This repo includes a production GitHub Actions workflow in [`.github/workflows/factory.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/.github/workflows/factory.yml).

Current behavior:

- pull request:
  - detects changed clusters
  - validates inputs
  - renders effective config
  - runs `terraform validate`
  - uploads rendered validation artifacts
  - runs the docs and bug sweep
- merge to `main`:
  - detects changed clusters
  - validates inputs
  - configures AWS credentials
  - writes backend config for each changed cluster
  - runs backend-backed `terraform plan`
  - uploads plan artifacts
  - runs `terraform apply` only in the protected `rosa-classic-apply` environment
- manual run:
  - supports `plan` or `apply`
  - can target one cluster with `workflow_dispatch` input `cluster_dir`

### Recommended Flow

1. Detect changed cluster directories.
2. Validate each changed cluster.
3. Run the docs and bug sweep.
4. Configure AWS credentials.
5. Write remote backend config for each changed cluster.
6. Run `terraform plan`.
7. Save rendered files and plan artifacts.
8. After approval, run `terraform apply`.

Use the shared runner in custom GitHub jobs:

```bash
scripts/write_backend_config.sh \
  --cluster-dir clusters/dev/classic-100 \
  --output .artifacts/github/dev-classic-100/backend.hcl

scripts/run_cluster_workflow.sh \
  --cluster-dir clusters/dev/classic-100 \
  --artifact-dir .artifacts/github/dev-classic-100 \
  --mode plan \
  --backend true \
  --backend-config-file .artifacts/github/dev-classic-100/backend.hcl
```

## Pattern 2: Azure Pipelines

Use this pattern when Azure DevOps is your approved enterprise runner.

### Setup Prerequisites

- Azure DevOps project and pipeline
- agents with network access to AWS, ROSA, and your GitOps repo
- secure pipeline variables or variable groups for:
  - `OCM_TOKEN`
  - `AWS_ACCESS_KEY_ID`
  - `AWS_SECRET_ACCESS_KEY`
  - optional `AWS_SESSION_TOKEN`
  - optional Vault and Git secrets when your stack needs them
- non-secret pipeline variables or variable groups for:
  - `AWS_REGION`
  - `TF_BACKEND_BUCKET`
  - `TF_BACKEND_REGION`
  - `TF_BACKEND_DYNAMODB_TABLE`
  - optional `TF_BACKEND_KEY_PREFIX`
  - optional `TF_BACKEND_KMS_KEY_ID`
  - optional `TF_BACKEND_ROLE_ARN`
- Azure environment `rosa-classic-apply` with approval checks
- optional `cluster_dir_override` variable for one-cluster manual runs
- set `terraform_apply=true` only when you want the apply stage to run

### Recommended Flow

1. Checkout the repo.
2. Detect changed clusters or use `cluster_dir_override`.
3. Install or verify the required tools.
4. Run input validation.
5. Run the docs and bug sweep.
6. Write backend config for each changed cluster.
7. Run `terraform plan`.
8. Publish plan and render artifacts.
9. Run `terraform apply` only after approval and only when `terraform_apply=true`.

This repo includes a production Azure pipeline at [`azure-pipelines.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/azure-pipelines.yml).

### Command Sequence

```bash
scripts/check_required_ci_tools.sh bash git jq python3 terraform helm rg oc

scripts/write_backend_config.sh \
  --cluster-dir clusters/dev/classic-100 \
  --output .artifacts/azure/dev-classic-100/backend.hcl

scripts/run_cluster_workflow.sh \
  --cluster-dir clusters/dev/classic-100 \
  --artifact-dir .artifacts/azure/dev-classic-100 \
  --mode plan \
  --backend true \
  --backend-config-file .artifacts/azure/dev-classic-100/backend.hcl
```

## Pattern 3: Bastion Host

Use this pattern for manual admin execution and debugging.

### Setup Prerequisites

- bastion host with network access to AWS, ROSA, and your GitOps repo
- repo cloned on the bastion host
- required tools installed
- ROSA and AWS credentials exported or available through the local auth model
- local storage for temporary artifacts such as `.artifacts/`

### Command Sequence

```bash
export TF_VAR_ocm_token='your-ocm-token'
export AWS_PROFILE='your-aws-profile'

scripts/run_cluster_workflow_bastion.sh \
  --cluster-dir clusters/dev/classic-100 \
  --artifact-dir .artifacts/bastion/dev-classic-100 \
  --mode apply \
  --backend-true
```

Use this when:

- you want a controlled manual run
- you want to debug one cluster directly
- you want to inspect the rendered files before apply

## Pattern 4: AAP

Use this pattern when your ops team wants approvals, RBAC, and controlled credentials in AAP.

### Setup Prerequisites

- AAP controller and execution environment
- an execution environment image with the required tools installed
- repository access from AAP
- AAP credentials for:
  - Git
  - AWS
  - `OCM_TOKEN`
- job template or workflow template
- optional approval node before apply

### Recommended AAP Job Flow

1. Checkout the repo.
2. Check the required tools.
3. Validate cluster files.
4. Render `terraform.auto.tfvars.json`.
5. Run `terraform init`.
6. Run `terraform plan`.
7. Add approval if needed.
8. Run `terraform apply`.

This repo includes an AAP playbook example at [`playbooks/aap/run_cluster_workflow.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/playbooks/aap/run_cluster_workflow.yml).

### Command Sequence

```bash
ansible-playbook playbooks/aap/run_cluster_workflow.yml \
  -e @docs/operations/aap-execution.example.yml \
  -e workflow_mode=apply \
  -e terraform_backend=true
```

Useful AAP extra vars:

```yaml
cluster_dir: clusters/dev/classic-100
artifact_dir: /runner/artifacts/dev-classic-100
workflow_mode: plan
terraform_backend: false
```

## Pattern 5: Terraform CLI

Use this pattern when you want to run the repo directly from any approved shell environment.

### Recommended Flow

1. Validate the cluster directory.
2. Render the effective config.
3. Copy `terraform.auto.tfvars.json` into the cluster root.
4. Run `terraform init`.
5. Run `terraform validate`.
6. Run `terraform plan`.
7. Run `terraform apply` when approved.

### Command Sequence

```bash
python3 scripts/validate_stack_inputs.py --cluster-dir clusters/dev/classic-100

python3 scripts/render_effective_config.py \
  --cluster clusters/dev/classic-100/cluster.yaml \
  --gitops clusters/dev/classic-100/gitops.yaml \
  --output-dir /tmp/classic-100

cp /tmp/classic-100/terraform.auto.tfvars.json \
  clusters/dev/classic-100/terraform.auto.tfvars.json

terraform -chdir=clusters/dev/classic-100 init -backend=false
terraform -chdir=clusters/dev/classic-100 validate
terraform -chdir=clusters/dev/classic-100 plan
```

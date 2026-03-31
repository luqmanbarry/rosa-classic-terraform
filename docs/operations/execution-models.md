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
  - AWS credentials or role-assumption inputs
  - private GitOps repo credentials if needed
- backend configuration and approval gates added before real apply

### How It Works

This repo already includes a GitHub Actions example in [`.github/workflows/factory.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/.github/workflows/factory.yml).

Current behavior:

- pull request:
  - detects changed clusters
  - validates inputs
  - renders effective config
  - runs `terraform fmt`
  - runs `terraform validate`
- merge to `main`:
  - detects changed clusters
  - validates inputs
  - renders effective config
  - prepares artifacts for a later backend-backed apply flow

Important note:

- the current apply job is still a scaffold
- you still need to wire remote backend config, credential setup, plan storage, approval gates, and real `terraform apply`

### Recommended Flow

1. Detect changed cluster directories.
2. Validate each changed cluster.
3. Render `terraform.auto.tfvars.json`.
4. Run `terraform init`.
5. Run `terraform plan`.
6. Save rendered files and plan artifacts.
7. After approval, run `terraform apply`.

Use the shared runner in custom GitHub jobs:

```bash
scripts/run_cluster_workflow.sh \
  --cluster-dir clusters/dev/classic-100 \
  --artifact-dir .artifacts/github/dev-classic-100 \
  --mode plan \
  --backend false
```

## Pattern 2: Azure Pipelines

Use this pattern when Azure DevOps is your approved enterprise runner.

### Setup Prerequisites

- Azure DevOps project and pipeline
- agents with network access to AWS, ROSA, and your GitOps repo
- secure pipeline variables or variable groups for:
  - `OCM_TOKEN`
  - AWS credentials
  - private GitOps repo credentials if needed
- validation and plan stages
- an approval gate before apply

### Recommended Flow

1. Checkout the repo.
2. Install or verify the required tools.
3. Run input validation.
4. Render `terraform.auto.tfvars.json`.
5. Run `terraform init`.
6. Run `terraform plan`.
7. Publish plan and render artifacts.
8. Run `terraform apply` only after approval.

This repo includes an Azure Pipelines example at [`azure-pipelines.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/azure-pipelines.yml).

### Command Sequence

```bash
scripts/check_required_ci_tools.sh bash git jq python3 terraform helm rg oc

scripts/run_cluster_workflow.sh \
  --cluster-dir clusters/dev/classic-100 \
  --artifact-dir .artifacts/azure/dev-classic-100 \
  --mode plan \
  --backend false
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

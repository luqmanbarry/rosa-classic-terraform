# Execution Models

This repo supports four main execution patterns.

## Bastion or CLI

Use this when an operator runs the stack manually from a jump host or admin workstation.

For a bastion-friendly wrapper, use [`scripts/run_cluster_workflow_bastion.sh`](/Users/luqman/workspace/guides/rosa-classic-terraform/scripts/run_cluster_workflow_bastion.sh).

```bash
scripts/run_cluster_workflow_bastion.sh \
  --cluster-dir clusters/dev/classic-100 \
  --artifact-dir /tmp/classic-100 \
  --mode plan \
  --backend-false
```

Use `--mode apply` without `--backend-false` when you are ready to apply against the real backend state.

## GitHub Actions

Use [`.github/workflows/factory.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/.github/workflows/factory.yml).

This workflow:

- validates changed cluster inputs
- renders effective config
- runs Terraform validation
- uploads rendered artifacts

## Ansible Automation Platform

Use [`playbooks/aap/run_cluster_workflow.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/playbooks/aap/run_cluster_workflow.yml).

This playbook calls the same shared script used by manual runs:

```bash
ansible-playbook playbooks/aap/run_cluster_workflow.yml \
  -e cluster_dir=clusters/dev/classic-100 \
  -e artifact_dir=/tmp/classic-100 \
  -e workflow_mode=plan \
  -e terraform_backend=false
```

## Azure Pipelines

Use [`azure-pipelines.yml`](/Users/luqman/workspace/guides/rosa-classic-terraform/azure-pipelines.yml).

This pipeline:

- installs the required tools
- runs the shared workflow script for plan/apply
- publishes artifacts
- includes a docs and bug sweep stage

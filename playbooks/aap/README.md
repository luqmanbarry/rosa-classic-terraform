# AAP Example

This example shows how to run one cluster stack from Ansible Automation Platform.

The playbook uses the shared script `scripts/run_cluster_workflow.sh`, so the AAP path follows the same steps as bastion, GitHub Actions, and Azure Pipelines.

## Inputs

- `cluster_dir`: cluster folder such as `clusters/dev/classic-100`
- `artifact_dir`: folder where rendered config, plan, and outputs are written
- `workflow_mode`: one of `validate`, `plan`, or `apply`
- `terraform_backend`: `true` or `false`

## Example

```bash
ansible-playbook playbooks/aap/run_cluster_workflow.yml \
  -e cluster_dir=clusters/dev/classic-100 \
  -e artifact_dir=/tmp/classic-100 \
  -e workflow_mode=plan \
  -e terraform_backend=false
```

## Prerequisites

- the execution environment must have `bash`, `git`, `jq`, `python3`, `terraform`, `helm`, `rg`, and `oc`
- AWS credentials and `OCM_TOKEN` must be available to the job
- if you use backend state, the backend credentials must also be available

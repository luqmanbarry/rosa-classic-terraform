# ROSA Classic Factory

This repo builds and manages ROSA Classic clusters on AWS. The inputs live in Git, Terraform builds the AWS/ROSA pieces, and OpenShift GitOps runs the in-cluster apps.

## Day plan

- See [docs/operations/implementation-plan.md](docs/operations/implementation-plan.md) for the Day 0/1/2 rollout. The plan keeps each phase small and shows how we align the factory stack with the ARO Classic layout while honoring ROSA best practices.

## Repository layout

- `catalog/`: shared defaults and cluster classes.
- `clusters/`: one folder per cluster under `clusters/<group-path>/<name>/`, containing `cluster.yaml`, `gitops.yaml`, values, and Terraform entry points.
- `modules/`: reusable Terraform modules, including the factory stack, optional AWS foundation, workload identity, ACM registration, and GitOps bootstrap.
- `gitops/`: OpenShift GitOps bootstrap, shared overlay, and reusable `platform/` and `workload/` applications.
- `playbooks/`: Ansible Automation Platform examples that call the shared workflow script.
- `scripts/`: render, validate, and helper scripts.
- `docs/`: design notes, execution guides, and the Day plan.

## How it works

1. Write or update `cluster.yaml`, `gitops.yaml`, and any app values under `clusters/<group-path>/<name>/`.
2. Render the effective config and validate with the tooling in `scripts/`.
3. Run Terraform from that cluster folder. Terraform optionally builds the AWS account/VPC or uses customer-provided networking.
4. Terraform boots OpenShift GitOps.
5. GitOps applies platform and workload apps after the cluster is ready.

## Terraform scope

- Optional AWS foundation (account roles, VPC, subnets, route tables, and DNS) when `infrastructure.create_aws_resources` is `true`.
- ROSA Classic account roles, OIDC, operator roles, and cluster lifecycle.
- Optional AWS workload identity IAM roles (Terraform manages IAM; GitOps adds the service-account annotations).
- Managed identities are optional and Terraform-based; enable them in `identity.aws_workload_identity.enabled` and annotate the matching `ServiceAccount` via GitOps.
- Optional ACM registration bootstrap when `acm.enabled` is `true`.
- OpenShift GitOps bootstrap, armed with the repo URL and target revision.

## GitOps scope

- AWS Secrets Manager (via ESO) is the default secret provider. Never record secrets in Git; reference ESO `Secret` names instead of copying values.
- Platform apps cover identity providers, RBAC, logging, monitoring, storage, tenant onboarding, and cost/insights integrations.
- Workload apps now follow the same Argo CD layout as ARO Classic: a shared overlay and reusable charts for every cluster.
- Third-party storage starters include NetApp Trident, Portworx Storage, NFS CSI, IBM Spectrum Scale CSI, and the static RWX provisioning module. Each chart is disabled by default and expects cluster-specific secrets and CSI details.
- Opt-in modules for cost management and Red Hat Insights are listed in `gitops/apps/platform` and have support details in their README files.
- High-risk GitOps modules now default to safer production behavior for ROSA Classic: manual operator approval where appropriate, no example admin bindings or tenant meshes, and hard validation for required backend inputs.

## Execution patterns

- **Bastion/CLI:** Render configs (Vault/ESO secrets) and run `terraform init`, `terraform plan -out=tfplan`, and `terraform apply tfplan` directly on a bastion or jump host.
- **Bastion helper:** Use `scripts/run_cluster_workflow_bastion.sh` when you want a bastion-specific wrapper with sane artifact defaults.
- **GitHub Actions:** The repo includes a production workflow that detects changed clusters, validates PRs, generates remote backend config, uploads saved plan artifacts, and applies the approved plan after environment approval. Use GitHub secrets and variables for AWS auth, `OCM_TOKEN`, backend state, and a short-lived `GITOPS_REPO_TOKEN` for bootstrap repo access.
- **Ansible Automation Platform (AAP):** Use `playbooks/aap/run_cluster_workflow.yml` to call the shared workflow script from an AAP job template.
- **Azure Pipelines:** The repo includes a production pipeline that detects changed clusters, validates PRs, writes backend config, publishes saved plan artifacts, supports Azure-to-AWS federation, and applies only when `terraform_apply=true` and the apply environment is approved.
- **Bootstrap Git auth:** Prefer a short-lived Git token or GitHub App installation token for Argo CD bootstrap. Username/password remains only as a legacy fallback.
- **Docs & bug sweep:** Run `scripts/find_bugs_and_docs_issues.sh` locally or in CI to catch `terraform fmt` regressions and unresolved marker words before they land in Git.

## Requirements

- Terraform and Python 3.
- `oc`, AWS credentials, and a Red Hat OCM token.
- Access to the target GitOps repo and ESO for secrets.
- Either an existing AWS network or permission for the repo to create the AWS foundation.
- Flexible grouping under `clusters/`; `group-path` can be environment, region and environment, business unit and environment, failure domain and environment, or any other approved hierarchy.

## Read more

- [Platform factory](docs/architecture/platform-factory.md)
- [Terraform vs GitOps boundary](docs/architecture/terraform-vs-gitops-boundary.md)
- [Execution models](docs/operations/execution-models.md)
- [AAP extra vars example](docs/operations/aap-execution.example.yml)
- [Tenant onboarding](docs/operations/tenant-onboarding.md)
- [Catalog guidance](catalog/README.md)
- [Clusters guidance](clusters/README.md)
- [Terraform modules](modules/README.md)
- [GitOps overview](gitops/README.md)
- [AAP playbooks](playbooks/README.md)

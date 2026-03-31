# ROSA Classic Factory

This repo builds and manages ROSA Classic clusters.

The main idea is simple:

- cluster settings live in Git
- Terraform builds AWS and ROSA resources
- GitOps manages normal in-cluster config after bootstrap

## Repo Layout

- `catalog/`: shared defaults for clusters
- `clusters/`: one folder per cluster
- `modules/`: reusable Terraform modules
- `gitops/`: OpenShift GitOps bootstrap and app charts
- `scripts/`: render, validate, and helper scripts
- `docs/`: short design docs

## How It Works

1. Add or update a cluster folder under `clusters/<env>/<name>/`.
2. Put cluster settings in `cluster.yaml`.
3. Put GitOps app settings in `gitops.yaml`.
4. Render and validate the config.
5. Run Terraform from that cluster folder.
6. Terraform builds the cluster and optional bootstrap parts.
7. OpenShift GitOps applies normal day-2 cluster config from Git.

## What Terraform Manages

- optional AWS foundation such as VPC, subnets, Route53, and helper security groups
- ROSA Classic account roles
- ROSA Classic OIDC
- ROSA Classic operator roles
- ROSA Classic cluster lifecycle
- optional AWS workload identity roles for service accounts
- optional ACM registration bootstrap
- OpenShift GitOps bootstrap

## What GitOps Manages

- identity providers and OAuth config
- RBAC and group mappings
- namespace and tenant onboarding
- logging and monitoring
- secret integration
- service account annotations that consume optional workload identity roles
- vendor storage operators, CSI config, and storage classes
- custom ingress and other in-cluster platform config
- operators and applications

## Cluster Input

Each cluster folder contains:

- `cluster.yaml`
- `gitops.yaml`
- `values/` for per-app Helm values
- `main.tf`
- `variables.tf`
- `outputs.tf`
- `versions.tf`

`cluster.yaml` can use one of two network modes:

- `infrastructure.create_aws_resources: false`
  Use existing VPC, subnets, and hosted zone.
- `infrastructure.create_aws_resources: true`
  Let this repo create the AWS foundation.

`cluster.yaml` can also opt into AWS workload identity for service accounts:

- `identity.aws_workload_identity.enabled: false`
  Do not create any IAM workload identity roles.
- `identity.aws_workload_identity.enabled: true`
  Create IAM roles and trust for the service accounts listed in `identity.aws_workload_identity.roles`.

This feature is split on purpose:

- Terraform creates the AWS IAM role and OIDC trust.
- GitOps should annotate the matching Kubernetes `ServiceAccount` when an app uses that role.

For tenant onboarding and shared app team setup, use `gitops/apps/platform/namespace-onboarding/`.

## Quick Start

Validate one cluster:

```bash
python3 scripts/validate_stack_inputs.py --cluster-dir clusters/dev/classic-100
```

Render the effective config:

```bash
python3 scripts/render_effective_config.py \
  --cluster clusters/dev/classic-100/cluster.yaml \
  --gitops clusters/dev/classic-100/gitops.yaml \
  --output-dir out/classic-100
```

Run Terraform from the cluster folder:

```bash
cd clusters/dev/classic-100
terraform init
terraform plan
```

## Requirements

- Terraform
- Python 3
- `oc`
- AWS credentials
- Red Hat OCM token
- access to the Git repo used by GitOps

You also need either:

- an existing AWS network and DNS setup

or

- permission for this repo to create the AWS foundation

## Read More

- [Platform Factory](/Users/luqman/workspace/guides/rosa-classic-terraform/docs/architecture/platform-factory.md)
- [Terraform vs GitOps Boundary](/Users/luqman/workspace/guides/rosa-classic-terraform/docs/architecture/terraform-vs-gitops-boundary.md)
- [Catalog](/Users/luqman/workspace/guides/rosa-classic-terraform/catalog/README.md)
- [Clusters](/Users/luqman/workspace/guides/rosa-classic-terraform/clusters/README.md)
- [Modules](/Users/luqman/workspace/guides/rosa-classic-terraform/modules/README.md)
- [GitOps](/Users/luqman/workspace/guides/rosa-classic-terraform/gitops/README.md)

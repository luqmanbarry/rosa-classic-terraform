# Clusters

Each cluster gets its own folder under:

`clusters/<group>/<cluster-name>/`

`<group>` is flexible. It can be:

- an environment such as `dev`, `qa`, or `prod`
- a region such as `us-east-1`
- a mixed grouping such as `prod-us-east-1`
- a team or business grouping when that fits your operating model

Examples:

- `clusters/dev/classic-100/`
- `clusters/qa/classic-210/`
- `clusters/prod-us-east-1/classic-310/`
- `clusters/emea-prod/classic-410/`

This means the repo supports:

- multiple dev clusters
- multiple qa clusters
- multiple prod clusters
- mixed environment and region grouping

Each cluster folder contains:

- `cluster.yaml`: human-authored cluster intent
- `gitops.yaml`: GitOps app selection
- `values/`: per-app Helm values used by `gitops.yaml`
- `main.tf`: Terraform entrypoint for one cluster
- `versions.tf`, `variables.tf`, `outputs.tf`: stack wiring

Validation rules:

- the folder must live under `clusters/`
- the layout must end with `<group>/<cluster-name>/`
- `cluster.yaml` key `cluster_name` must match the cluster directory name

`cluster.yaml` also controls whether the repo should create the AWS foundation itself:

- `infrastructure.create_aws_resources: false`: use existing VPC, subnets, and hosted zone
- `infrastructure.create_aws_resources: true`: create the VPC, subnets, Route53 zone, and helper security group from this repo

`cluster.yaml` can also opt into AWS workload identity:

- `identity.aws_workload_identity.enabled: false`: do not create IAM roles for service accounts
- `identity.aws_workload_identity.enabled: true`: create IAM roles and trust for the service accounts listed under `identity.aws_workload_identity.roles`

Use `gitops.yaml` plus files in `values/` to choose day-2 apps such as tenant onboarding, service account annotations, logging, or policy apps.

Rendered artifacts are generated at runtime and should not be committed.

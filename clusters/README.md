# Clusters

Each cluster gets its own folder under:

`clusters/<group-path>/<cluster-name>/`

`<group-path>` is flexible. It can be one level or many levels. It can represent:

- an environment such as `dev`, `qa`, or `prod`
- a region with environment under it such as `us-east-1/dev`
- a business unit with environment under it such as `bu-retail/prod`
- a failure domain with environment under it such as `fd1/prod-dr`
- any other approved grouping that helps your operating model

Examples:

- `clusters/dev/classic-100/`
- `clusters/us-east-1/qa/classic-210/`
- `clusters/bu-retail/prod/classic-310/`
- `clusters/fd1/prod-dr/classic-410/`

This means the repo supports:

- multiple dev clusters
- multiple qa clusters
- multiple prod clusters
- nested grouping such as region to env, business unit to env, and failure domain to env

Each cluster folder contains:

- `cluster.yaml`: human-authored cluster intent
- `gitops.yaml`: GitOps app selection
- `values/`: per-app Helm values used by `gitops.yaml`
- `main.tf`: Terraform entrypoint for one cluster
- `versions.tf`, `variables.tf`, `outputs.tf`: stack wiring

Validation rules:

- the folder must live under `clusters/`
- the layout must end with `<group-path>/<cluster-name>/`
- `cluster.yaml` key `cluster_name` must match the cluster directory name

Important rule:

- the directory path is for human organization
- the real automation inputs still live in `cluster.yaml`
- keep fields such as environment, region, business unit, and failure-domain metadata in the YAML, not only in the folder name

`cluster.yaml` also controls whether the repo should create the AWS foundation itself:

- `infrastructure.create_aws_resources: false`: use existing VPC, subnets, and hosted zone
- `infrastructure.create_aws_resources: true`: create the VPC, subnets, Route53 zone, and helper security group from this repo

`cluster.yaml` can also opt into AWS workload identity:

- `identity.aws_workload_identity.enabled: false`: do not create IAM roles for service accounts
- `identity.aws_workload_identity.enabled: true`: create IAM roles and trust for the service accounts listed under `identity.aws_workload_identity.roles`

Use `gitops.yaml` plus files in `values/` to choose day-2 apps such as tenant onboarding, service account annotations, logging, or policy apps.

Rendered artifacts are generated at runtime and should not be committed.

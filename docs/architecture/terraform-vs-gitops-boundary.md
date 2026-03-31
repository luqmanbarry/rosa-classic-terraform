# Terraform vs GitOps Boundary

Use this rule:

- If the resource is outside the cluster, or created through RHCS or AWS APIs, use Terraform.
- If the resource lives in the cluster and should stay in sync from Git, use OpenShift GitOps.

## Terraform-Owned

- AWS network discovery or optional network creation
- Route53 records and hosted zone integration required for cluster creation
- ROSA classic account roles
- ROSA classic OIDC configuration
- ROSA classic operator roles
- ROSA classic cluster lifecycle
- optional AWS workload identity IAM roles and trust policies
- optional ACM registration bootstrap when explicitly enabled
- OpenShift GitOps bootstrap

## GitOps-Owned

- IDPs and OAuth config after the cluster is reachable
- RBAC and group mappings
- self-provisioner policy
- image registry policy
- logging and monitoring
- Vault or AWS Secrets Manager integration through External Secrets Operator
- service account annotations that bind workloads to optional AWS workload identity roles
- custom ingress controllers
- workload operators and applications
- Secrets live in AWS Secrets Manager (via ESO) instead of hardcoded YAML files.

## Exception

If something must exist before GitOps can start, keep only that small bootstrap step in Terraform.

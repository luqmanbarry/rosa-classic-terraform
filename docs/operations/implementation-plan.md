# Day plan for ROSA Classic factory

This repo now follows the ARO Classic factory layout while keeping ROSA Classic specifics such as AWS, ACM, and Secrets Manager. The work is split into three days so you can ship changes in phases while honoring Red Hat, Terraform, IBM, and GitHub guidance.

## Day 0 (foundation)

- Align the cluster automation stack with the factory pattern (catalog, cluster folders, shared modules, and GitOps overlays) documented by ARO Classic and ROSA HCP. That means one `modules/factory-stack` entry point, optional AWS foundation modules, and Terraform-managed ACM/workload identity on demand.
- Follow Terraform best practices: keep state per cluster, reuse modules, avoid pinning to minor versions, and keep code in the shared `modules/` tree so a review touches just the factory stack and the reusable pieces.
- Document the account setup, VPC, subnets, DNS, IAM, and service role steps so a team can opt into repo-managed AWS infrastructure or supply their own network inputs.
- Capture this plan so every engineer knows where Day 1 and Day 2 begin.

## Day 1 (cluster automation)

- Refine `clusters/<group-path>/<name>` inputs, including optional account creation, AWS workload identity, managed identity, ACM registration, and GitOps bootstrap settings. Keep any sensitive data out of Git and referenced through ESO-managed Secrets or Terraform variables.
- Ensure the factory modules follow ROSA Classic contracts (account roles, OIDC, operator roles, cluster lifecycle) while leaving OpenShift GitOps for in-cluster config, mirroring the `terraform-vs-gitops-boundary` doc.
- Include docs that explain how to run the Terraform stack from bastion, GitHub Actions, Ansible Automation Platform, or Azure Pipelines, reusing the patterns from the guides.

## Day 2 (GitOps and Day 2 ops)

- Bring the GitOps tree in line with the ARO structure: a root bootstrap app, a shared overlay, and reusable `platform/` and `workloads/` charts. Each chart must be ROSA Classic compatible, reference AWS Secrets Manager (via ESO) when secrets are needed, and use dedicated namespaces instead of `default`.
- Add opt-in modules for tenant onboarding, third-party CSI drivers (NetApp Trident, Portworx, NFS CSI, IBM Spectrum Scale), cost management, Red Hat Insights, and static RWX provisioning. Keep them disabled by default and document how to enable them along with their prerequisites.
- Detail how managed identities are handled (Terraform for AWS IAM, GitOps for service-account annotations) so operators understand the Terraform/GitOps boundary.
- Clean up unused examples, dead files, and legacy code. Keep README/docs in easy English and make sure no stale references to other repos remain.

Each day can be landed separately, but the repo should remain usable between phases: Day 0 sets the structure, Day 1 builds clusters, and Day 2 pieces together GitOps automation.

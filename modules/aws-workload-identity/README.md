# aws-workload-identity

This module creates optional AWS IAM roles for ROSA Classic service accounts.

Use it when a workload running in the cluster needs AWS access through OIDC and STS.

What Terraform does:

- trusts the cluster OIDC provider that ROSA already creates
- creates one IAM role per configured service account
- attaches managed policies
- adds an optional inline policy

What GitOps does:

- annotates the matching Kubernetes `ServiceAccount` with the role ARN

This split keeps AWS IAM in Terraform and in-cluster service account changes in GitOps.

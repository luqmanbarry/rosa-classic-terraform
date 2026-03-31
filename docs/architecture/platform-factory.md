# Platform Factory

This repo uses a cluster factory model.

The flow is simple:

1. Write cluster settings in Git.
2. Validate and render the config.
3. Run one Terraform stack for one cluster.
4. Let OpenShift GitOps manage normal in-cluster config.

The factory stack supports two infrastructure models:

- customer-provided AWS network and DNS inputs
- repo-managed AWS foundation when `infrastructure.create_aws_resources: true`

## End-to-End Flow

```text
Cluster class
  + cluster files
  -> render effective config
  -> Terraform factory-stack
     -> optional AWS foundation
     -> ROSA classic cluster
     -> optional AWS workload identity
     -> optional ACM registration
  -> OpenShift GitOps bootstrap
     -> root app
        -> platform apps
        -> workload apps
```

## Terraform Scope

Terraform owns resources that are created outside the cluster or through RHCS or AWS APIs:

- optional AWS networking and Route53 prerequisites
- ROSA classic account roles, OIDC, operator roles, and cluster lifecycle
- optional AWS workload identity IAM roles for service accounts
- optional ACM registration bootstrap when explicitly enabled
- OpenShift GitOps bootstrap

## GitOps Scope

OpenShift GitOps should own normal cluster configuration after bootstrap:

- identity providers and OAuth config
- RBAC and group bindings
- namespace and tenant onboarding
- ingress policy and extra ingress controllers
- logging and monitoring
- secret integration
- service account annotations that consume optional workload identity roles
- workload operators and applications

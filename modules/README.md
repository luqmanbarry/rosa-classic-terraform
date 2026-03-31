# Modules

These are the Terraform modules used by the factory.

- `factory-stack/`
  The main entrypoint for one cluster.
- `rosa-classic-infra/`
  Optional AWS foundation module.
- `rosa-classic-core/`
  ROSA Classic cluster module.
- `aws-workload-identity/`
  Optional AWS IAM roles for service accounts.
- `rosa-classic-acm-registration/`
  Optional ACM registration bootstrap.
- `openshift-gitops-bootstrap/`
  Installs OpenShift GitOps and creates the root Argo CD app.

The factory stack calls these modules in order.

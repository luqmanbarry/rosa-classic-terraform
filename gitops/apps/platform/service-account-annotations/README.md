# service-account-annotations

This chart manages annotations on Kubernetes `ServiceAccount` objects.

Main use in this repo:

- annotate service accounts with AWS workload identity role ARNs

Use it when:

- Terraform has created optional AWS workload identity roles
- an app chart does not expose `serviceAccount.annotations`

Example annotation:

```yaml
annotations:
  eks.amazonaws.com/role-arn: arn:aws:iam::123456789012:role/classic-100-external-secrets-operator
```

The values file expects a list of service accounts with:

- `name`
- `namespace`
- `annotations`

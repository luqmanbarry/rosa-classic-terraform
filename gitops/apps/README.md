# GitOps Apps

These are the reusable app targets used by the shared overlay.

## Layout

- `platform/`: platform apps and operators managed by cluster admins.
- `workloads/`: workload apps enabled per cluster.

Each cluster chooses apps in `clusters/<environment>/<cluster>/gitops.yaml`.
Update any values files before enabling an app. Never keep secrets or credentials in those files; reference an ESO-managed Secret name instead.

## Secret policy

- AWS Secrets Manager is the default secret backend. External Secrets Operator (ESO) keeps Kubernetes secrets synchronized from that store.
- When a chart needs credentials, point it to the ESO Secret name and namespace rather than putting data into Git.

## Storage starters

- `netapp-trident`
- `portworx-storage`
- `nfs-csi`
- `ibm-spectrum-scale-csi`
- `static-storage` (static RWX provisioning for tenant namespaces)

Every storage starter is disabled by default so you can fill in backend-specific secrets and CSI settings before enabling the chart.

## Additional opt-in apps

- `cost-management`: for customers with cost management entitlements.
- `redhat-insights`: registers the cluster with Red Hat Insights.
- `namespace-onboarding`: creates tenant namespaces, quotas, RBAC, and optional tenant Argo CD instances.

Enable each optional app only after you satisfy its prerequisites. The readme in each chart explains required entitlements and ESO secrets.

For AWS workload identity, use `service-account-annotations` to attach the Terraform-created IAM roles when a chart does not expose `serviceAccount` annotations directly.

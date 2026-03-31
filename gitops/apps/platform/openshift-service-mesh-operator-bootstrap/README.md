# OpenShift Service Mesh Operator Bootstrap

This chart installs the shared service mesh platform pieces for ROSA Classic.

It can install the Service Mesh operator, Kiali, OpenTelemetry, and Tempo, then create tenant-specific mesh control plane resources from values.

## How To Enable

1. Review whether your platform team wants shared or tenant-specific mesh control planes.
2. Store any Tempo object storage credentials in AWS Secrets Manager.
3. Update `clusters/<group-path>/<cluster>/values/openshift-service-mesh-operator-bootstrap.yaml`.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `operators.*`: operator subscription and namespace settings.
- `operators.tempo.s3.*`: Tempo object storage settings and secret references.
- `tenants[]`: tenant definitions, control plane settings, member namespaces, and RBAC.

## Prerequisites

- A clear service mesh tenancy model approved by the platform team.
- ESO-managed Secrets for Tempo or other object storage credentials.
- Namespace planning for mesh control plane and member namespaces.

## Support Note

Keep operator lifecycle admin-managed. Tenant teams should opt into mesh use through approved namespaces and RBAC, not by creating their own operator subscriptions.

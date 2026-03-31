# GitOps

OpenShift GitOps keeps ROSA Classic cluster configuration in sync after Terraform bootstrap. The layout follows the same factory pattern used elsewhere in this repo: bootstrap, shared overlay, reusable platform charts, and reusable workload charts.

## GitOps flow

1. Terraform installs the OpenShift GitOps operator and creates the root `Application`.
2. The root app points to `gitops/overlays/cluster-applications/`.
3. The shared overlay creates the `platform` and `workloads` AppProjects and their child applications.
4. Each child application syncs a chart from `gitops/apps/platform` or `gitops/apps/workloads`.

## Argo CD model

- One GitOps operator per cluster in `openshift-gitops`.
- The admin Argo CD instance owns shared platform and workload applications.
- `namespace-onboarding` can optionally create one shared tenant Argo CD instance for approved teams.
- Tenant teams do not get their own GitOps operator.

## GitOps modules

- Secrets come from AWS Secrets Manager through External Secrets Operator.
- Platform charts cover identity, RBAC, logging, monitoring, storage, service mesh, onboarding, and bootstrap operators.
- Workload charts cover shared tenant-facing platforms such as AAP, OpenShift AI, and CP4BA.
- `namespace-onboarding` can record namespace-level feature intent and access bindings for shared features such as service mesh, OpenShift AI, CP4BA, and AAP while leaving operator subscriptions under admin control.
- Storage starters include NetApp Trident, Portworx, NFS CSI, IBM Spectrum Scale CSI, and static RWX provisioning.
- Cost management and Red Hat Insights are opt-in and disabled by default.
- High-risk charts now use safer defaults: no example tenant resources, no default admin RBAC, manual install approval for optional operators, and fail-fast checks when required backend values are missing.

## Namespace policy

- No chart should use the `default` namespace.
- If a chart creates a namespace, that namespace must come from values so tenants can use their own namespace names.

## Enabling apps

- Each cluster selects apps in `clusters/<group-path>/<cluster>/gitops.yaml`.
- Each app reads its values from `clusters/<group-path>/<cluster>/values/`.
- Keep secrets out of Git. Store them in AWS Secrets Manager and sync them with ESO.

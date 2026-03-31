# GitOps

OpenShift GitOps manages normal cluster changes after Terraform finishes bootstrap.

Simple flow:

1. Terraform installs the OpenShift GitOps operator and creates a root `Application`.
2. The root application points to `gitops/overlays/cluster-applications/`.
3. The shared overlay creates the shared `platform` and `workloads` AppProjects.
4. The shared overlay creates child Argo CD applications.
5. Those child applications deploy platform and workload apps.

Most reusable apps in this repo are Helm charts.

The shared overlay is also a Helm chart. During bootstrap, Terraform passes in the Git repo URL, Git revision, cluster name, and cluster app list.

## Argo CD model

This repo uses one OpenShift GitOps operator per cluster.

It uses one admin Argo CD instance in `openshift-gitops` for platform work:

- apps from `gitops/apps/platform`
- apps from `gitops/apps/workloads`
- the shared `platform` AppProject
- the shared `workloads` AppProject

How to set up GitOps for one cluster:

- choose apps in `clusters/<environment>/<cluster>/gitops.yaml`
- set `enabled: true` only for the apps you want to run now
- put app values in `clusters/<environment>/<cluster>/values/<app>.yaml` when you need separate values files
- use `namespace-onboarding` when you want shared tenant namespaces, quotas, RBAC, and optional tenant Argo CD setup

ROSA Classic notes:

- keep Terraform for ROSA, AWS, DNS, IAM, and cluster bootstrap
- keep GitOps for normal cluster settings after the cluster is ready
- use AWS Secrets Manager as the default shared secret backend
- use Terraform to create optional AWS workload identity roles
- use GitOps to annotate the matching Kubernetes `ServiceAccount` when an app should use one of those roles
- use GitOps for vendor storage operators, CSI driver custom resources, and `StorageClass` objects
- keep secret values out of Git
- enable External Secrets style apps only when the operator and API level are supported on your ROSA Classic version

When an app chart does not support `serviceAccount.annotations`, use `gitops/apps/platform/service-account-annotations/` to bind the role ARN to the target service account.

For third-party storage, starter apps are included for NetApp Trident, Portworx, NFS CSI, and IBM Spectrum Scale CSI.

## Layout

- `bootstrap/openshift-gitops/`: installs the OpenShift GitOps operator
- `bootstrap/root-app/`: creates the root `Application` for a cluster
- `overlays/cluster-applications/`: builds the list of Argo CD applications for a cluster
- `apps/platform/`: reusable platform applications
- `apps/workloads/`: reusable workload applications

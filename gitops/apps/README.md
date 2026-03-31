# GitOps Apps

These are the reusable app targets used by the shared cluster overlay.

## Layout

- `platform/`: platform apps and operators managed by cluster admins
- `workloads/`: workload apps enabled per cluster

Each cluster chooses its apps in `clusters/<environment>/<cluster>/gitops.yaml`.

For AWS workload identity, use the `service-account-annotations` app when a target chart does not expose service account annotations directly.

For tenant onboarding, use the `namespace-onboarding` app.

For third-party storage, use the starter apps for:

- `netapp-trident`
- `portworx-storage`
- `nfs-csi`
- `ibm-spectrum-scale-csi`

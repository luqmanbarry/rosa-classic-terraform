# Self Provisioner

This chart controls whether regular users can create new projects with the self-provisioner role.

Many platform teams disable self-provisioning so all namespaces go through the onboarding process.

## How To Enable

1. Update `clusters/<group-path>/<cluster>/values/self-provisioner.yaml`.
2. Set `disableSelfProvisioner` to the behavior you want.
3. Enable the app in `gitops.yaml`.

## Main Inputs

- `disableSelfProvisioner`: set to `true` to remove self-provisioning from regular users.
- `clusterAdminEmail`: contact value used in the project configuration.

## Prerequisites

- Decide whether namespace creation is admin-controlled or user-controlled for this cluster.

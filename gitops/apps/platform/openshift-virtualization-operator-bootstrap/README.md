# OpenShift Virtualization Operator Bootstrap

Installs the OpenShift Virtualization operator and creates the `HyperConverged` custom resource.

Use this module when you want GitOps to create the operator namespace, `OperatorGroup`, `Subscription`, and base virtualization settings.

The default OLM channel is `stable`.

Keep it disabled until you have approved worker pool, storage, and support settings for virtualization.

## What This Chart Manages

- namespace `openshift-cnv`
- operator `OperatorGroup`
- operator `Subscription`
- `HyperConverged` custom resource
- cluster-wide live migration defaults
- optional infra and workload node placement settings

## Production Readiness Rules

- Use this only on ROSA Classic clusters that meet the OpenShift Virtualization support requirements for ROSA Classic.
- In practice, that means you must confirm the worker nodes use supported AWS bare-metal instance types before you enable this chart.
- The chart will fail on purpose unless `support.bareMetalWorkersConfirmed` is set to `true`.

## How To Enable

1. Confirm the cluster uses supported bare-metal worker instance types for OpenShift Virtualization on ROSA Classic.
2. Confirm you have a supported storage design for VM disks.
3. Update `clusters/<group-path>/<cluster>/values/openshift-virtualization-operator-bootstrap.yaml`.
4. Set `support.bareMetalWorkersConfirmed: true`.
5. Enable the app in `gitops.yaml`.

## Main Inputs

- `operator.*`: operator install settings.
- `support.bareMetalWorkersConfirmed`: required safety switch.
- `hyperconverged.liveMigrationConfig.*`: live migration tuning.
- `hyperconverged.infra.nodePlacement.*`: placement for infra virtualization components.
- `hyperconverged.workloads.nodePlacement.*`: placement for VM workloads.
- `hyperconverged.extraSpec`: extra supported `HyperConverged.spec` fields not modeled directly in this chart.

## Suggested Defaults

The chart ships with Red Hat documented live migration defaults:

- `bandwidthPerMigration: 64Mi`
- `completionTimeoutPerGiB: 800`
- `parallelMigrationsPerCluster: 5`
- `parallelOutboundMigrationsPerNode: 2`
- `progressTimeout: 150`
- `allowPostCopy: false`

## Prerequisites

- ROSA Classic cluster that meets OpenShift Virtualization support requirements.
- Supported bare-metal worker instance types.
- Supported storage class for VM disks.
- Platform-team review of networking, VM storage, and node placement.

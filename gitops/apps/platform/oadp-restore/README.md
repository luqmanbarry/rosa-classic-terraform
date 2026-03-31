# OADP Restore

This chart creates restore resources for OADP.

Use it only after the backup source and OADP operator are already ready.

Safe defaults:

- restore is disabled by default
- the backup list is empty by default
- storage class mapping is empty by default

## How To Enable

1. Make sure `oadp-operator` is installed and the target backup exists.
2. Update `clusters/<group-path>/<cluster>/values/oadp-restore.yaml`.
3. Set `enable: true`.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `storageClassMapping`: maps source storage classes to target storage classes.
- `backups[]`: list of backup names to restore.
- `namespace`: OADP namespace.

## Prerequisites

- Existing backups in the configured backup store.
- Correct storage class mapping for the target cluster.

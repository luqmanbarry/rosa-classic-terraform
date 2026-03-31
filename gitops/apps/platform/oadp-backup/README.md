# OADP Backup

This chart creates scheduled OADP backups after the OADP operator is already installed and configured.

## How To Enable

1. Install and configure `oadp-operator` first.
2. Update `clusters/<group-path>/<cluster>/values/oadp-backup.yaml`.
3. Add the namespaces and schedules you want to protect.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `namespace`: OADP namespace, usually `openshift-adp`.
- `projects[]`: list of namespaces to back up.
- `projects[].cronSchedule`: backup schedule.
- `projects[].backupRetentionPeriod`: how long to keep backups.
- `defaultVolumesToFsBackup`: choose filesystem backup behavior for volumes.

## Prerequisites

- OADP operator and `DataProtectionApplication` already working.
- Backup storage and credentials already configured.

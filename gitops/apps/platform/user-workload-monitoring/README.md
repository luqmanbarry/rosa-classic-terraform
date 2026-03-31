# User Workload Monitoring

This chart configures OpenShift monitoring for user workloads.

Use it when application teams need Prometheus, Alertmanager, and Thanos storage for their own namespaces.

## How To Enable

1. Update `clusters/<group-path>/<cluster>/values/user-workload-monitoring.yaml`.
2. Set the storage sizes and storage classes that match your platform.
3. Enable the app in `gitops.yaml`.

## Main Inputs

- `enableUserWorkload`: turns user workload monitoring on or off.
- `prometheusK8s.*`: cluster monitoring retention and storage settings.
- `prometheus.*`: user workload Prometheus retention and storage settings.
- `alertmanagerMain.*`: Alertmanager retention and storage settings.
- `thanosRuler.*`: Thanos Ruler retention and storage settings.

## Prerequisites

- A supported storage class for monitoring data.
- Capacity planning for retention and storage growth.

# Splunk Log Forwarding

This chart deploys the Splunk OpenTelemetry Collector through Argo CD and forwards cluster logs to Splunk.

Secrets are expected from AWS Secrets Manager through ESO.

## How To Enable

1. Store the Splunk HEC details in AWS Secrets Manager.
2. Sync them with ESO.
3. Update `clusters/<group-path>/<cluster>/values/splunk-log-forwarding.yaml`.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `hecSecretName`: Kubernetes Secret name created by ESO.
- `helmChart.*`: upstream chart source and version.
- `clusterName`, `environment`, `namespaceOverride`: cluster identity and target namespace.
- `splunkPlatform.*`: Splunk endpoint and forwarding settings.
- `logsEnabled`, `metricsEnabled`, `tracesEnabled`: telemetry switches.

## Prerequisites

- Splunk HEC endpoint and token.
- ESO-managed Secret with the HEC details.
- Review proxy and trust settings if the cluster uses enterprise egress controls.

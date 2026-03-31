# OpenShift Cluster Log Forwarder

This chart installs the logging operator and sets up log forwarding to Splunk.

It is meant for:

- app logs
- audit logs
- infra logs

Before you enable it:

- Up and running ROSA Classic cluster
- [External Secrets Operator](../external-secrets-operator/)
- Splunk HEC token available through the shared secret store used by External Secrets

Safe defaults:

- operator install plan approval is `Manual`
- Splunk endpoint is empty by default

The chart fails fast if you enable it without `splunk.endpoint`.

Set the values in `values.yaml` or in the cluster values file before you enable the app.

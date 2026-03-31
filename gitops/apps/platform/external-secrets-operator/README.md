# External Secrets Operator

This chart installs External Secrets Operator for OpenShift and can also create one shared `ClusterSecretStore`.

For this repo, the default provider direction is AWS Secrets Manager on ROSA Classic.

## What this chart does

- creates the operator namespace
- installs the operator from OperatorHub
- creates the operator config
- can create one shared `ClusterSecretStore`

## Recommended pattern

- keep operator install in this chart
- keep shared `ClusterSecretStore` definitions in `external-secrets-config`
- keep app `ExternalSecret` objects with the app that uses them

## ROSA Classic note

- enable this only when the operator channel you choose is supported for your OpenShift and ROSA Classic version
- the default subscription here uses the Red Hat operator package and `stable-v1`

Values are in [values.yaml](./values.yaml).

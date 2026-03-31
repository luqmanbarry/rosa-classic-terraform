# Identity Providers

This chart configures OpenShift OAuth identity providers.

It supports OpenID-based providers and reads client secrets from ESO-managed Kubernetes Secrets.

## How To Enable

1. Store the client secrets in AWS Secrets Manager.
2. Sync those secrets into the cluster with ESO.
3. Update `clusters/<group-path>/<cluster>/values/identity-providers.yaml`.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `idp.openid.enable`: turns OpenID identity providers on or off.
- `idp.openid.providers[]`: provider definitions such as AAD or Keycloak.
- `clientSecretSecretName`: name of the ESO-managed Secret with the client secret.
- `oauthCertsConfigMapName`: config map name for custom CA certificates if needed.

## Prerequisites

- A working OpenID identity provider.
- ESO-managed Secrets for client credentials.
- CA certificates if your provider uses private trust.

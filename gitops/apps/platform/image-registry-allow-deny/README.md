# Image Registry Allow Deny

This chart updates the cluster image policy so you can allow only approved registries and images.

It can also install trusted CA certificates for private registries.

## How To Enable

1. Store the pull secret and any registry CA data in AWS Secrets Manager.
2. Sync them with ESO.
3. Update `clusters/<group-path>/<cluster>/values/image-registry-allow-deny.yaml`.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `pullSecretSecretName`: Secret with the pull secret JSON.
- `registriesTrustedCerts[]`: registry host, CA secret, and template key mapping.
- `allowList[]`: approved registries or exact image references.
- `patchSchedule`: schedule for the pull-secret update job.

## Prerequisites

- ESO-managed Secrets for the pull secret and any CA bundles.
- A reviewed allow list. This chart blocks registries by default unless you allow them.

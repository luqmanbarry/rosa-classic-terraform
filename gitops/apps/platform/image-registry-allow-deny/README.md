# Image Registry Allow Deny

This chart updates the cluster image policy so you can allow only approved registries and images.

It can also install trusted CA certificates for private registries.

Safe defaults:

- no pull secret is configured by default
- no trusted CA bundle is configured by default
- the registry CA copy job runs daily, not every five minutes

The chart still keeps a conservative allow list for common registries, but private registry details stay empty until you add them.

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
- If you do not use private registry CA bundles, leave `registriesTrustedCerts` empty. The ESO CA secret and copy job will not be created.

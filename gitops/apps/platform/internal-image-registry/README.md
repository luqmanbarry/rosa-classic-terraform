# Internal Image Registry

This chart configures the OpenShift internal image registry.

Use it when you need to expose the default route, disable redirect behavior, or configure object storage.

## How To Enable

1. Update `clusters/<group-path>/<cluster>/values/internal-image-registry.yaml`.
2. Enable the app in `gitops.yaml`.

## Main Inputs

- `defaultRoute`: expose the default route.
- `disableRedirect`: keep traffic on the registry service instead of redirecting to storage.
- `storage.s3`: optional S3 storage settings.

## Prerequisites

- If you use custom object storage, provide the right S3 bucket and region values.
- Review Red Hat guidance for supported registry storage settings on ROSA Classic.

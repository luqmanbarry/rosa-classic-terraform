# OADP Operator

This chart installs the OADP operator and creates the `DataProtectionApplication` custom resource for AWS.

Secrets are expected from AWS Secrets Manager through ESO.

## How To Enable

1. Create or choose the S3 bucket for backup data.
2. Store the AWS credential values in AWS Secrets Manager.
3. Update `clusters/<group-path>/<cluster>/values/oadp-operator.yaml`.
4. Enable the app in `gitops.yaml`.

## Main Inputs

- `namespace`: namespace for the operator and data protection resources.
- `subscriptionChannel`: OADP operator channel.
- `storage.region`, `storage.bucketName`, `storage.bucketPrefix`: S3 backup target.
- `storage.credentialsSecretName`: Kubernetes Secret name created by ESO.
- `storage.accessKeyIdRemoteRef`, `storage.secretAccessKeyRemoteRef`: AWS Secrets Manager references.

## Prerequisites

- S3 bucket for OADP backups.
- ESO-managed Secret inputs for AWS credentials.
- Supported snapshot classes if you plan to use volume snapshots.

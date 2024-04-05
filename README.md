# ROSA STS Cluster Automation

## Pre-Requisites

### Account Level
- [Detailed List](https://docs.openshift.com/rosa/rosa_planning/rosa-sts-aws-prereqs.html)

### Execution Level
- IAM STS User with permission to:
  - Create Operator Roles
  - Create S3 Bucket (TF State Bucket)
  - Create, Delete ROSA
  - Create OIDC
  - Add Route53 HostedZone records
- VPC tagged with `cluster_name`
- Private and/or Public Subnets tagged with `cluster_name`
  - `/24` CIDR for Multi-AZ
  - `/25` CIDR for Single-AZ
  - tagged with `cluster_name`
- Base DNS Domain name if you intend to deploy a custom `IngressController`
- Additional Security Groups to apply to the cluster nodes (Master, Infra, Worker) tagged with `cluster_name`)
- ROSA OCM Token
- Cluster Name
- Vault Token or AppRole with permission to:
  - Add a PKI engine Role
  - Request TLS certificates
  - Create KeyVault secrets
  - Retrieve/Read KV secrets
- Vault Paths for retrieving the following:
  - Identity Provider Details. Look at the [idp-<name>.tf](./rosa-sts/) files for examples. 4 examples are provided.
  - ACMHUB cluster credentials (api_url, username, password)

    For example:
    ```json
      {
        "api_url": "https://api.example.p1.openshiftapps.com:6443",
        "password": "<value>",
        "username": "<value>"
      }
    ```
  - OCM Token
  
    For example:
    ```json
      {
        "ocm_token": "<value>"
      }
    ```
  - Github/GitLab Authentication Token
  
    For Example:
    ```json
      {
        "git_token": "<value>"
      }
    ```


## Execution Flow
![Rosa STS Stages](.assets/rosa-sts-modules.png)


## Admin Variables

These are the cross-module [variables](./tfvars/admin/admin.tfvars) that are common across business units.

## Terraform Modules

Listed in their order of precedence, they work together to provision a rosa-sts (classic) cluster, make necessary configurations and then register the cluster to ACM for day-2 configurations and management.

- [tfstate-config](./tfstate-config/): Create an S3 bucket for remote state storage.
- [account-setup](./account-setup/): Create necessary AWS resources such as VPC, Subnets, NAT Gateways, Account Roles. Security Groups...
- [tfvars-prep](./tfvars-prep/): Combine admin, user inputs, and dynamic variables into a master tfvars file. All subsequent modules will use the master tfvars file.
- [git-tfvars-file](./git-tfvars-file/): Commit the master tfvars file to GitHub. Feel free to change the repo location to GitLab, BitBucket...etc.
- [rosa-sts](./rosa-sts/): Creates the rosa-sts (classic) cluster, deploys two identity providers (GitHub, GitLab), and then writes the cluster-admin credentials to Vault.
- [kube-config](./kube-config/): Create two kubeconfig files. One for the the rosa-sts (classic) cluster and another for the ACMHUB cluster.
- [custom-ingress](./custom-ingress/): Deploys an additional IngressController.
- [vault-k8s-auth](./vault-k8s-auth/): Deploy the vault-kubernetes-authentication backend for apps running on the cluster to be able to read Vault secrets.
- [acmhub-registration](./acmhub-registration/): Registers the rosa-sts (classic) cluster to the ACMHUB cluster.

## Implementation

### Cluster Build

Take a look at the [.ci/pipeline-create.sh](.ci/pipeline-create.sh) file.

### Cluster Tear Down

Take a look at the [.ci/pipeline-destroy.sh](.ci/pipeline-create.sh) file.

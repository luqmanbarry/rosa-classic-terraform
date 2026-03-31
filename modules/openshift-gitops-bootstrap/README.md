# openshift-gitops-bootstrap

This module installs OpenShift GitOps and creates the root Argo CD application.

## What it does

- creates the operator and Argo CD namespaces
- installs the OpenShift GitOps operator
- waits for operator and Argo CD readiness
- optionally creates a repository secret
- creates the root `Application`

## Requirements

- kubeconfig for the managed cluster
- `oc` available in the execution environment
- `helm` available in the execution environment

## Root app contract

The root app points to `gitops/overlays/cluster-applications/` and passes:

- the Git repository URL
- the target revision
- the cluster-scoped values from `gitops.yaml`

ROSA Classic notes:

- this module uses the OpenShift GitOps operator pattern supported on OpenShift
- the default operator channel is `gitops-1.15`
- child applications can use in-repo manifests or remote chart repositories
- app projects allow extra source repositories so AWS-focused platform apps can use chart repos when needed

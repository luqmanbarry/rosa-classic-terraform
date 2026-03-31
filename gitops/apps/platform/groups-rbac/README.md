# Groups RBAC

This chart creates cluster role bindings for identity groups.

Use it when your identity provider already creates the groups and you want to map those groups to OpenShift roles.

## How To Enable

1. Update `clusters/<group-path>/<cluster>/values/groups-rbac.yaml`.
2. Add one entry under `rbac.assignments` for each group-to-role mapping.
3. Enable the app in `gitops.yaml`.

## Main Inputs

- `rbac.assignments[].groupName`: identity group name.
- `rbac.assignments[].ocpRole`: OpenShift cluster role to bind.

## Prerequisites

- The group names must already exist in your identity provider.
- Use built-in or approved custom OpenShift roles only.

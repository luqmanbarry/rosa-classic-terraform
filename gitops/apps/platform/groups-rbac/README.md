# Groups RBAC

This chart creates cluster role bindings for identity groups.

Use it when your identity provider already creates the groups and you want to map those groups to OpenShift roles.

Safe default:

- `rbac.assignments` is empty

This is intentional. The chart does not ship any default admin binding.

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
- Review every binding before you add it. Avoid `cluster-admin` unless your platform team explicitly approves it.

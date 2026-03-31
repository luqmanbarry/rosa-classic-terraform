# OpenShift Compliance Operator

This chart installs the Compliance Operator.

Use it when you want GitOps to create the namespace, `OperatorGroup`, `Subscription`, and compliance setup resources.

Safe defaults:

- operator install plan approval is `Automatic`
- automatic remediation is off
- debug is off

This is intentional. Compliance scans can be heavy, and automatic remediation should only be enabled after review.

Automatic approval is used here because `compliance-content` depends on the Compliance Operator CRDs.

Before you enable it:

- Up and running ROSA Classic cluster
- approved compliance profile and scan plan
- approved remediation policy

# Global Pull Secret

This chart updates the cluster pull secret to add private registry credentials.

The secret value must look like this:

```yaml
{
  "auths": {
    "my-registry.example.com": {
      "username": "value",
      "password": "value"
    }
  }
}
```

Store that JSON in your shared secret store.

Then update the cluster values file to set:

- the shared store name
- the secret name

Safe defaults:

- the secret name is empty by default
- the update job runs daily

The chart fails fast if you enable it without a real `pullSecretSecretName`.

Keep this app disabled until the secret exists.

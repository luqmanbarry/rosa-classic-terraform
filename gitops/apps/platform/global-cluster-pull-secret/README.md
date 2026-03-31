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

Keep this app disabled until the secret exists.

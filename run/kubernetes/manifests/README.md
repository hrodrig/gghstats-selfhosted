# Kubernetes manifests (optional)

← [Back to run/README](../../README.md).

This directory is reserved for **raw YAML** manifests (e.g. `Deployment` + `Service` + `Ingress`) if you prefer not to use Helm.

The maintained install path is the **[Helm chart](../helm/gghstats/)**. You can generate a starting point with:

```bash
helm template gghstats ../helm/gghstats > example-rendered.yaml
```

Review and edit before applying; values are the source of truth in **`../helm/gghstats/values.yaml`**.

---

**[↑ Back to run/README](../../README.md)**

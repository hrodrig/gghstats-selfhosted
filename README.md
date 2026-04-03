# Helm chart index (gghstats)

This **`gh-pages`** branch is the **Helm chart repository** served at  
**https://hrodrig.github.io/gghstats-selfhosted/** for [gghstats](https://github.com/hrodrig/gghstats).

| File | Role |
|------|------|
| **`index.yaml`** | Chart index — updated by [helm/chart-releaser](https://github.com/helm/chart-releaser) when a **`v*`** tag is pushed on **`main`** (with chart changes under `run/kubernetes/helm/`). |
| **`index.html`** | Human-readable landing for the same URL (optional; Helm uses **`index.yaml`** only). |

Sources and operator documentation: **[gghstats-selfhosted](https://github.com/hrodrig/gghstats-selfhosted)**.

## Quick start

```bash
helm repo add gghstats https://hrodrig.github.io/gghstats-selfhosted
helm repo update
helm install gghstats gghstats/gghstats -n gghstats --create-namespace -f my-values.yaml
```

Use **`helm show values gghstats/gghstats`** after **`helm repo update`** to build **`my-values.yaml`**.

# Local Kubernetes smoke test (kind)

End-to-end check for the **[gghstats Helm chart](../../run/kubernetes/helm/gghstats/)** on a disposable **kind** cluster. Unlike **pgwd-selfhosted**, gghstats does **not** need an in-cluster Postgres — only a **GitHub token** and a writable **`/data`** volume (chart PVC).

## Automated run

| Make target | What it does |
|-------------|----------------|
| **`make test-helm-kind`** | kind cluster + **`helm upgrade --install`** gghstats + rollout + log check for **`listening`**. |

```bash
export GGHSTATS_HELM_E2E_GITHUB_TOKEN=ghp_xxx   # repo read (scope to your test filter)
make test-helm-kind
```

Requires **Docker**, **kind**, **kubectl**, and **helm**.

**Environment (optional):**

| Variable | Purpose |
|----------|---------|
| **`GGHSTATS_HELM_E2E_GITHUB_TOKEN`** | **Required.** PAT passed to the chart (`githubToken.value`). |
| **`GGHSTATS_HELM_E2E_CLUSTER`** | kind cluster name (default **`gghstats-helm-e2e`**) |
| **`GGHSTATS_HELM_E2E_ROLLOUT_TIMEOUT`** | Deployment `kubectl rollout status … --timeout` (default **`300s`**) |
| **`GGHSTATS_HELM_E2E_LOG_WAIT_SECS`** | Seconds to wait for **`listening`** in logs (default **`120`**) |
| **`GGHSTATS_HELM_E2E_NO_CLEANUP`** | If non-empty, **do not** delete the kind cluster |

The script sets **`env.syncOnStartup=false`** and slightly **higher CPU/memory** limits so the check is stable under kind.

If the Deployment fails to become ready, the script prints **`kubectl` describe / logs / events** before exiting.

## Manual Helm (existing cluster)

From the **repository root**:

```bash
helm upgrade --install gghstats ./run/kubernetes/helm/gghstats \
  -n gghstats --create-namespace \
  --set githubToken.value="$GGHSTATS_GITHUB_TOKEN" \
  --set env.syncOnStartup=false
```

This path is **optional** for contributors; CI still relies on **`helm template`** + **kubeconform** (see **[CONTRIBUTING.md](../../CONTRIBUTING.md)**).

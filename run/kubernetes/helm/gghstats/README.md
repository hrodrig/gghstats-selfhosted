# Helm chart: gghstats

← [Back to run/README](../../../README.md).

This chart installs **gghstats** from the published container image.

**Path vs repository name:** In a clone of **[gghstats-selfhosted](https://github.com/hrodrig/gghstats-selfhosted)**, this chart is the directory **`run/kubernetes/helm/gghstats/`**. The segment **`gghstats`** is the **Helm chart name** (matches **`name:`** in **`Chart.yaml`**) and the workload it deploys — not the GitHub repo name (**`gghstats-selfhosted`**). The application source code lives in **[hrodrig/gghstats](https://github.com/hrodrig/gghstats)**.

### Install from the Helm repository (recommended)

The project publishes packaged charts and **`index.yaml`** on **GitHub Pages** (same GitHub project). Install without cloning:

```bash
helm repo add gghstats https://hrodrig.github.io/gghstats-selfhosted
helm repo update
helm install gghstats gghstats/gghstats -n gghstats --create-namespace -f my-values.yaml
```

Use **`helm show values gghstats/gghstats`** to dump defaults. If **`helm repo add`** fails, the index may not be published yet — use **from a git clone** below.

### Install from a git clone (sources and templates)

From the **repository root** of [gghstats-selfhosted](https://github.com/hrodrig/gghstats-selfhosted):

```bash
helm install gghstats ./run/kubernetes/helm/gghstats -n gghstats --create-namespace -f my-values.yaml
```

This path is the **same chart** as the published package; use it to read **`templates/`**, **`values.yaml`**, and **`values.schema.json`** in detail.

**Namespace:** the chart does **not** set a default namespace in `values.yaml`. You choose it at install time with **`-n` / `--namespace`** (example: **`gghstats`**). Use **`--create-namespace`** if that namespace does not exist yet. All manifests use the **release namespace** Helm applies. Uninstall with the same **`-n`**: `helm uninstall gghstats -n gghstats`.

See **`values.yaml`** for image repository, tag, persistence, **resource requests/limits**, and environment variables. The application’s configuration is documented in the main **[gghstats](https://github.com/hrodrig/gghstats)** repository.

**Validation:** **`values.schema.json`** requires **`resources.requests`** and **`resources.limits`** (cpu + memory). `helm install` / `helm template` fail if `resources` is omitted or cleared (e.g. `--set resources=null`).

**Security:** the chart sets **`podSecurityContext`** / **`containerSecurityContext`** so the workload runs **non-root** (UID/GID **1000**, matching the upstream image) with **`readOnlyRootFilesystem: true`**. The database and SQLite sidecars use **`env.dbPath`** under the **`/data`** mount; **`/tmp`** is a small **`emptyDir`** for runtime temp files. Set **`readOnlyRootFilesystem: false`** under **`containerSecurityContext`** only if a custom image needs writes elsewhere.

---

**[↑ Back to run/README](../../../README.md)**

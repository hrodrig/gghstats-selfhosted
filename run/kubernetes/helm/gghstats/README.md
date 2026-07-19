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

### GitHub token (Kubernetes secret)

Prefer **not** storing the PAT in **`my-values.yaml`**. Defaults in **`values.yaml`** expect a Secret named **`gghstats-secret`** with key **`github-token`**. Create it before **`helm install`** (replace **`YOUR_GITHUB_TOKEN`**):

```bash
kubectl create namespace gghstats
kubectl create secret generic gghstats-secret \
  -n gghstats \
  --from-literal=github-token=YOUR_GITHUB_TOKEN
```

Leave **`githubToken.value`** empty so the chart does not render the token into release manifests. If **`githubToken.existingSecret`** is set, it overrides the Secret name the Deployment mounts (see **`templates/deployment.yaml`**).

### Opt-in alerts

Set `alerting.enabled`, `alerting.sinks`, and `alerting.rules` in `my-values.yaml`. Keep Slack/webhook/Loki/SMTP credentials out of Helm values: create a Secret whose keys use the exact environment-variable names referenced by the sink JSON, then set `alerting.existingSecret`. The Deployment loads every key from that Secret with `envFrom`.

```bash
kubectl create secret generic gghstats-alerts -n gghstats \
  --from-literal=GGHSTATS_TEAMS_WEBHOOK_URL='https://...'
```

```yaml
alerting:
  enabled: true
  existingSecret: gghstats-alerts
  sinks: '[{"type":"webhook","url_env":"GGHSTATS_TEAMS_WEBHOOK_URL","body":"teams"}]'
  rules: '[{"repo":"owner/repo","metric":"clones","window":"lifetime","op":"gte","value":4000,"fire":"once"}]'
```

Supported sink families: Slack, generic webhook (Discord / Teams / n8n), Loki, and SMTP. See [gghstats SPEC §8](https://github.com/hrodrig/gghstats/blob/main/SPEC.md#8-opt-in-alerts--notification-rules).

### Install from a git clone (sources and templates)

From the **repository root** of [gghstats-selfhosted](https://github.com/hrodrig/gghstats-selfhosted):

```bash
helm install gghstats ./run/kubernetes/helm/gghstats -n gghstats --create-namespace -f my-values.yaml
```

This path is the **same chart** as the published package; use it to read **`templates/`**, **`values.yaml`**, and **`values.schema.json`** in detail.

**Namespace:** the chart does **not** set a default namespace in `values.yaml`. You choose it at install time with **`-n` / `--namespace`** (example: **`gghstats`**). Use **`--create-namespace`** if that namespace does not exist yet. All manifests use the **release namespace** Helm applies. Uninstall with the same **`-n`**: `helm uninstall gghstats -n gghstats`.

See **`values.yaml`** for image repository, tag, persistence, **resource requests/limits**, and environment variables (including optional **`env.customCss`** for a [gghstats ≥ 0.2.0](https://github.com/hrodrig/gghstats/releases) dashboard theme). The application’s configuration is documented in the main **[gghstats](https://github.com/hrodrig/gghstats)** repository.

### Optional custom theme (`env.customCss`)

**`GGHSTATS_CUSTOM_CSS`** in the workload must reference a **`.css` file path inside the container**. With chart defaults, **only `/data`** is a persistent writable mount: the **PVC** (when **`persistence.enabled: true`**) is mounted there, alongside **`env.dbPath`** (SQLite). Use a value such as **`/data/custom-theme.css`** and place the file on that volume — **`kubectl cp`**, a **Job**, or your GitOps process — because **`readOnlyRootFilesystem: true`** prevents treating random image paths as writable theme storage. See the root [README — Custom UI theme](https://github.com/hrodrig/gghstats-selfhosted/blob/main/README.md#custom-ui-theme-optional) for Compose vs Kubernetes wording.

**After `helm install`:** Helm prints **post-install notes** from **`templates/NOTES.txt`** (what the app is, how to reach the UI, GitHub token Secret). The short **`DESCRIPTION: Install complete`** line in Helm’s status block is generic and cannot be replaced with product marketing copy — use the notes for operator guidance.

**Validation:** **`values.schema.json`** requires **`resources.requests`** and **`resources.limits`** (cpu + memory). `helm install` / `helm template` fail if `resources` is omitted or cleared (e.g. `--set resources=null`).

**Same checks as CI (developers):** GitHub runs [helm-lint.yml](https://github.com/hrodrig/gghstats-selfhosted/blob/main/.github/workflows/helm-lint.yml) when **`run/kubernetes/helm/`** changes — **`helm lint`** plus **`helm template`** piped to **[kubeconform](https://github.com/yannh/kubeconform)**. To replicate locally: requirements, full command list, expected resource counts, and optional **`kubectl --dry-run=server`** with a cluster are documented in **[CONTRIBUTING.md — Helm chart validation (same as CI)](https://github.com/hrodrig/gghstats-selfhosted/blob/main/CONTRIBUTING.md#helm-chart-validation-same-as-ci)**.

**Security:** the chart sets **`podSecurityContext`** / **`containerSecurityContext`** so the workload runs **non-root** (UID/GID **1000**, matching the upstream image) with **`readOnlyRootFilesystem: true`**. The database and SQLite sidecars use **`env.dbPath`** under the **`/data`** mount; **`/tmp`** is a small **`emptyDir`** for runtime temp files. Set **`readOnlyRootFilesystem: false`** under **`containerSecurityContext`** only if a custom image needs writes elsewhere.

---

**[↑ Back to run/README](../../../README.md)**

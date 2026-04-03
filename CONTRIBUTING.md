# Contributing to gghstats-selfhosted

Thank you for helping improve these deployment manifests.

## How to contribute

- **Issues:** Use [GitHub Issues](https://github.com/hrodrig/gghstats-selfhosted/issues) for bugs, doc gaps, or manifest improvements (Compose, Helm, observability).
- **Pull requests:** Open PRs against **`develop`**. Keep changes focused (one concern per PR when possible).
- **Application behavior** (Go code, UI, API): contribute in **[gghstats](https://github.com/hrodrig/gghstats)** — this repo is **infrastructure only**.

## Checks before submitting

- Paths under **`run/`** match the documented layout; **`docker compose … config`** succeeds when a minimal env file is provided (e.g. **`--env-file "${GGHSTATS_HOST_DATA}/.env"`** with **`GGHSTATS_HOST_DATA`** set, or a dev **`./.env`** at the repo root with defaults). For observability: **`--env-file "${GGHSTATS_HOST_DATA}/.env.observability"`** and **`-p gghstats-obs`**.
- **Helm:** PRs and pushes that touch **`run/kubernetes/helm/`** run [**.github/workflows/helm-lint.yml**](.github/workflows/helm-lint.yml) — **`helm lint`** and **`helm template`** piped to **`kubectl apply --dry-run=client --validate=false`** (no cluster in CI; **`--validate=false`** avoids OpenAPI fetch to a missing apiserver).
- **English** for README and comments.
- If you bump **[`VERSION`](VERSION)**, keep the README **Version** badge and **CHANGELOG** aligned. Bump **`Chart.yaml` `version:`** only when **`run/kubernetes/helm/gghstats/`** changes and you intend to publish a **new chart package** — **`VERSION`** and chart **`version:`** do not need to match on every release (see **Versioning** in the root README).

## Release flow (this repo)

- **`VERSION`** at the repo root — semver without `v` (e.g. `0.2.0`).
- Git tags **`v<version>`** on **`main`** after merging from **`develop`**.
- See **[CHANGELOG.md](CHANGELOG.md)** for notable infra-facing changes.

### Helm chart on GitHub Pages (maintainers)

The install path **`helm repo add gghstats https://hrodrig.github.io/gghstats-selfhosted`** expects **`index.yaml`** and packaged **`.tgz`** files on the **`gh-pages`** branch.

- **Automation:** [**.github/workflows/release-charts.yml**](.github/workflows/release-charts.yml) runs **[helm/chart-releaser-action](https://github.com/helm/chart-releaser-action)** when you **push an annotated tag `v*`** on **`main`** (aligned with the repo’s **`VERSION`** / release tags). It packages the chart, creates a GitHub Release (artifact `.tgz`), and updates **`gh-pages`** with **`index.yaml`**. **`workflow_dispatch`** is available for a manual re-run. Continuous validation before merge: [**helm-lint.yml**](.github/workflows/helm-lint.yml).
- **One-time setup:** Repository **Settings → Pages → Build and deployment → Source:** branch **`gh-pages`**, folder **`/` (root)**.
- **Release checklist (chart publish):** When the **chart** changes, bump **`Chart.yaml` `version:`** (semver) and **`appVersion`** if the image story changes. Merge to **`main`**, push **`git tag -a v…`** and **`git push origin v…`**. Confirm [Release Charts](.github/workflows/release-charts.yml) is green; then **`helm repo update`** on a test machine. **Repo `VERSION`** and Git tag **`v*`** snapshot the **whole repository** — they need not equal **`Chart.yaml` `version:`** if this release did not touch the chart.
- **“No chart changes detected”:** Normal when you tag **`v*`** for a **docs-only or Compose-only** release. chart-releaser only updates **`gh-pages`** / chart packages when **`run/kubernetes/helm/`** has meaningful diffs. **No action required** unless you intended to ship a new **`.tgz`** — then edit the chart, bump **`Chart.yaml` `version:`**, merge, and tag again.
- **First chart upload failed with `invalid reference: origin/gh-pages`:** Fixed in the workflow by bootstrapping an **orphan `gh-pages`** branch when it does not exist yet; use workflow and chart version **≥ 0.1.2** (or re-tag after pulling that workflow).

The chart **source of truth** remains **`run/kubernetes/helm/gghstats/`**.

## Questions

Open an issue to discuss larger refactors before investing heavy work.

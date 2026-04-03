# Contributing to gghstats-selfhosted

Thank you for helping improve these deployment manifests.

## How to contribute

- **Issues:** Use [GitHub Issues](https://github.com/hrodrig/gghstats-selfhosted/issues) for bugs, doc gaps, or manifest improvements (Compose, Helm, observability).
- **Pull requests:** Open PRs against **`develop`**. Keep changes focused (one concern per PR when possible).
- **Application behavior** (Go code, UI, API): contribute in **[gghstats](https://github.com/hrodrig/gghstats)** — this repo is **infrastructure only**.

## Checks before submitting

- Paths under **`run/`** match the documented layout; **`docker compose … config`** succeeds when a minimal env file is provided (e.g. **`--env-file "${GGHSTATS_HOST_DATA}/.env"`** with **`GGHSTATS_HOST_DATA`** set, or a dev **`./.env`** at the repo root with defaults). For observability: **`--env-file "${GGHSTATS_HOST_DATA}/.env.observability"`** and **`-p gghstats-obs`**.
- **English** for README and comments.
- If you bump **[`VERSION`](VERSION)**, keep the README badge, Helm **`Chart.yaml`** `version:`, and **CHANGELOG** aligned; see **Versioning** in the root README.

## Release flow (this repo)

- **`VERSION`** at the repo root — semver without `v` (e.g. `0.2.0`).
- Git tags **`v<version>`** on **`main`** after merging from **`develop`**.
- See **[CHANGELOG.md](CHANGELOG.md)** for notable infra-facing changes.

### Helm chart on GitHub Pages (maintainers)

The install path **`helm repo add gghstats https://hrodrig.github.io/gghstats-selfhosted`** expects **`index.yaml`** and packaged **`.tgz`** files on the **`gh-pages`** branch.

- **Automation:** [**.github/workflows/release-charts.yml**](.github/workflows/release-charts.yml) runs **[helm/chart-releaser-action](https://github.com/helm/chart-releaser-action)** when you **push an annotated tag `v*`** on **`main`** (aligned with the repo’s **`VERSION`** / release tags). It packages the chart, creates a GitHub Release (artifact `.tgz`), and updates **`gh-pages`** with **`index.yaml`**. **`workflow_dispatch`** is available for a manual re-run.
- **One-time setup:** Repository **Settings → Pages → Build and deployment → Source:** branch **`gh-pages`**, folder **`/` (root)**.
- **Release checklist:** On **`main`**, set **`run/kubernetes/helm/gghstats/Chart.yaml`** **`version:`** to match the tag without **`v`** (e.g. tag **`v0.2.0`** → **`version: 0.2.0`**). Adjust **`appVersion`** if it tracks the container image. Push **`git tag -a v0.2.0 -m "…"`** and **`git push origin v0.2.0`**, confirm the workflow is green, then **`helm repo update`** on a test machine.
- **chart-releaser skipped / no `gh-pages`:** The workflow compares git history and only publishes if **`run/kubernetes/helm/`** changed since its baseline. A tag whose only new commits touch docs (e.g. README) will log **“No chart changes detected”** and will not create **`gh-pages`**. Fix: include a commit that bumps **`Chart.yaml`** `version:` (and align **`VERSION`**, README badge, **CHANGELOG**) before tagging again.
- **First chart upload failed with `invalid reference: origin/gh-pages`:** Fixed in the workflow by bootstrapping an **orphan `gh-pages`** branch when it does not exist yet; use workflow and chart version **≥ 0.1.2** (or re-tag after pulling that workflow).

The chart **source of truth** remains **`run/kubernetes/helm/gghstats/`**.

## Questions

Open an issue to discuss larger refactors before investing heavy work.

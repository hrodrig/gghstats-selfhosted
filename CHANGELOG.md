# Changelog

All notable changes to **gghstats-selfhosted** (deployment manifests, docs, and tooling for this repository only) are documented here. For the **gghstats** application, see [gghstats CHANGELOG](https://github.com/hrodrig/gghstats/blob/main/CHANGELOG.md).

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Added

- **`run/scripts/compose-stack.sh`** — wrapper for **`docker compose`** on **minimal**, **Traefik**, and **observability** stacks (correct **`--env-file`**, **`-f`**, project **`gghstats-obs`**); **`--traefik`** for the observability Grafana overlay file. **`run/scripts/README.md`**; links from **`run/README.md`**, root **README**, and Compose READMEs.

## [0.1.6] - 2026-04-04

### Changed

- Default **gghstats** container image tag **`v0.1.3`** ([gghstats v0.1.3](https://github.com/hrodrig/gghstats/releases/tag/v0.1.3)): [`run/common/.env.example`](run/common/.env.example), Compose image defaults, Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), and docs.
- **Helm chart:** bump **`version:`** to **0.1.6** and **`appVersion`** to **0.1.3**.

## [0.1.5] - 2026-04-03

### Added

- **Helm chart:** **`Chart.yaml` `icon`** — [`assets/gghstats-selfhosted-icon.png`](assets/gghstats-selfhosted-icon.png) (512×512, derived from the README hero) for Helm / Artifact Hub UIs; **`raw.githubusercontent.com`** URL on **`main`**.
- **Documentation:** [CONTRIBUTING.md](CONTRIBUTING.md) — section **Helm chart validation (same as CI)** (tooling requirements, CI version pins, full **`helm lint`** / **`kubeconform`** command block, expected resource counts per scenario, optional **`kubectl apply --dry-run=server`** with a cluster). [Chart README](run/kubernetes/helm/gghstats/README.md) points to that section.

### Fixed

- **Helm CI:** [`.github/workflows/helm-lint.yml`](.github/workflows/helm-lint.yml) — replace **`kubectl apply --dry-run=client`** with **[kubeconform](https://github.com/yannh/kubeconform)** (`helm template … | kubeconform`). Pin **kubeconform** to **[v0.7.0](https://github.com/yannh/kubeconform/releases/tag/v0.7.0)**. Recent **`kubectl`** still contacts **`localhost:8080`** for API discovery even with **`--validate=false`**, so CI failed with **connection refused**; kubeconform validates manifests **without** a cluster.

## [0.1.4] - 2026-04-02

### Added

- **CI:** [`.github/workflows/helm-lint.yml`](.github/workflows/helm-lint.yml) — **`helm lint`** and **`helm template`** piped to **`kubectl apply --dry-run=client`** for default values, **`persistence.enabled=false`**, inline **`githubToken.value`**, and **`githubToken.existingSecret`**.

### Changed

- **Release `0.1.4`:** root **[`VERSION`](VERSION)** and **`Chart.yaml` `version:`** — chart **`0.1.4`** packages **`templates/NOTES.txt`** and prior chart/doc updates that shipped after **`0.1.3`** without a new chart semver.
- **Versioning policy:** **`VERSION`** (repo) and **`Chart.yaml` `version:`** (Helm package) may diverge — bump chart **`version:`** only when **`run/kubernetes/helm/gghstats/`** changes. Updated **README**, **AGENTS.md**, **CONTRIBUTING.md**, and **`.cursor/rules`** (`version-sync`, `git-flow`, `documentation-and-layout`, `readme-root`).
- **Helm chart:** add **`templates/NOTES.txt`** so **`helm install`** prints post-install steps (what **gghstats** is, **`kubectl`** checks, port-forward / NodePort / LoadBalancer hints, GitHub token Secret). The **`DESCRIPTION: Install complete`** line in Helm’s summary is not customizable product text — use these notes for that.
- **Documentation (Helm):** `kubectl create secret` example for **`gghstats-secret`** / **`github-token`** in root **README** and **`run/kubernetes/helm/gghstats/README.md`** (keep PAT out of **`my-values.yaml`**).
- **Documentation:** clarify **repository name** (**`gghstats-selfhosted`**) vs **Helm chart directory/name** (**`run/kubernetes/helm/gghstats/`**, chart **`gghstats`**) and vs **chart-releaser** GitHub Release names (**`gghstats-<version>`**) vs **Git tags** (**`v<semver>`**).
- **GitHub Pages (`gh-pages`):** add **`index.html`** landing and expand **`README.md`**; **`index.yaml`** remains the chart index (updated by chart-releaser on **`v*`** tags). Root **README** notes that Helm only needs the Pages base URL.

## [0.1.3] - 2026-04-04

### Changed

- **Documentation:** Compose examples use **`${GGHSTATS_HOST_DATA}/.env`** and **`docker compose --env-file …`** everywhere; **`run/common/.env.example`** and related READMEs no longer recommend copying `.env` to the repository root as the default path.
- **Observability:** **`observability.env.example`**, **`run/README.md`**, **`run/common/README.md`**, and **`run/docker-compose/observability/README.md`** describe the same pattern for **`${GGHSTATS_HOST_DATA}/.env.observability`** (including Traefik prerequisites with **`--env-file`** for the main stack).

## [0.1.2] - 2026-04-03

### Fixed

- **Release Charts workflow:** create an **orphan `gh-pages`** branch when missing so **chart-releaser** does not fail with **`fatal: invalid reference: origin/gh-pages`** on the first chart upload.

## [0.1.1] - 2026-04-03

### Fixed

- **Helm / chart-releaser:** bump chart **`version:`** in **`Chart.yaml`** so **chart-releaser** sees a change under **`run/kubernetes/helm/`** and publishes **`index.yaml`** to **`gh-pages`**. Tag **`v0.1.0`** pointed at a commit whose diff did not touch the chart directory, so the workflow exited with “No chart changes detected” and never created **`gh-pages`**.

## [0.1.0] - 2026-04-02

### Added

- **`run/`** layout: `common/`, `standalone/{linux,macos,windows}/`, `docker/`, `docker-compose/{minimal,traefik,observability}/`, `kubernetes/{helm,manifests}/`.
- **Docker Compose** examples: minimal GHCR stack; Traefik + Let’s Encrypt + `gghstats_edge`; optional Prometheus / Grafana / Loki stack ([`run/docker-compose/observability/README.md`](run/docker-compose/observability/README.md)).
- **`GGHSTATS_HOST_DATA`** for absolute host paths to SQLite; optional colocation of **`.env`** and **`.env.observability`** outside the clone ([`run/common/.env.example`](run/common/.env.example)).
- **Helm chart** at [`run/kubernetes/helm/gghstats`](run/kubernetes/helm/gghstats).
- **Root README** with table of contents, copy-paste flows per deployment mode (standalone, `docker run`, Compose, observability, Helm), validation and teardown snippets.
- **Hero image** [`assets/gghstats-selfhosted-hero.png`](assets/gghstats-selfhosted-hero.png).
- **Community docs:** `CONTRIBUTING.md`, `CODE_OF_CONDUCT.md`, `SECURITY.md`, `AGENTS.md`.
- **`VERSION`** file and **Version** badge for this repository (distinct from **`GGHSTATS_VERSION`** / container image tag).
- **`data/.keep`** with gitignore rules so runtime DB files under `data/` are not committed.

[Unreleased]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.6...HEAD
[0.1.6]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.6
[0.1.5]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.5
[0.1.4]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.4
[0.1.3]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.3
[0.1.2]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.2
[0.1.1]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.1
[0.1.0]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.0

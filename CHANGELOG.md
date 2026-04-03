# Changelog

All notable changes to **gghstats-selfhosted** (deployment manifests, docs, and tooling for this repository only) are documented here. For the **gghstats** application, see [gghstats CHANGELOG](https://github.com/hrodrig/gghstats/blob/main/CHANGELOG.md).

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

### Changed

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

[Unreleased]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.3...HEAD
[0.1.3]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.3
[0.1.2]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.2
[0.1.1]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.1
[0.1.0]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.0

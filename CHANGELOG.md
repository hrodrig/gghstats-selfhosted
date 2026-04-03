# Changelog

All notable changes to **gghstats-selfhosted** (deployment manifests, docs, and tooling for this repository only) are documented here. For the **gghstats** application, see [gghstats CHANGELOG](https://github.com/hrodrig/gghstats/blob/main/CHANGELOG.md).

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

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

[Unreleased]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.1...HEAD
[0.1.1]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.1
[0.1.0]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.0

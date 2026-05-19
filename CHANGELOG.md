# Changelog

All notable changes to **gghstats-selfhosted** (deployment manifests, docs, and tooling for this repository only) are documented here. For the **gghstats** application, see [gghstats CHANGELOG](https://github.com/hrodrig/gghstats/blob/main/CHANGELOG.md).

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.22] - 2026-05-18

### Added

- **Docs:** Grafana dashboard screenshots [`assets/grafana-domain-metrics-1.png`](assets/grafana-domain-metrics-1.png), [`assets/grafana-domain-metrics-2.png`](assets/grafana-domain-metrics-2.png) linked from [observability README](run/docker-compose/observability/README.md).

### Fixed

- **Grafana domain dashboard:** per-repo bar gauges sort by clone count descending (`sort_desc(topk(...))` + panel `sortBy: value`).
- **Observability README:** remove broken links to missing Explore screenshots; document `sort_desc(topk(...))` for bar gauges.

## [0.1.21] - 2026-05-18

### Fixed

- **`compose-stack.sh`:** `traefik` / `prod` / `full` **`down`** also stops legacy Compose project **`traefik`** (pre-0.1.20) and removes fixed-name containers **`traefik`** / **`gghstats`** so `full down` does not leave the old stack running.

## [0.1.20] - 2026-05-18

### Fixed

- **Grafana domain dashboard:** PromQL for sync age ignores `last_sync_timestamp_seconds == 0` (avoids multi-year spikes on the trend panel). Sync duration panel uses `increase()` over 6h instead of `rate(...[5m])` on sparse histograms. GitHub API error % uses `increase` + `clamp_min` so “no errors” shows **0%** instead of “No data”.

### Changed

- **Traefik Compose:** Compose project **`gghstats-edge`** (containers `gghstats-edge-traefik-1`, `gghstats-edge-gghstats-1`) — same style as observability **`gghstats-obs-*`**. Removed fixed **`container_name`**; Prometheus still uses service names **`gghstats`** / **`traefik`** on **`gghstats_edge`**.
- **Traefik Compose:** pass through **`GGHSTATS_METRICS_PER_REPO`** from `${GGHSTATS_HOST_DATA}/.env` (default `false`) so per-repo Grafana panels can be enabled without editing the compose file.

## [0.1.19] - 2026-05-18

### Fixed

- **Traefik Compose:** set **`container_name: gghstats`** and **`container_name: traefik`** so hostnames match [`prometheus.yml`](run/docker-compose/observability/observability/prometheus.yml) on shared **`gghstats_edge`** (separate Compose projects).

## [0.1.18] - 2026-05-18

### Fixed

- **Grafana provisioning:** remove fixed datasource `uid` values that prevented startup when `grafana_data` already existed from an earlier stack (error: `data source not found`). Domain dashboard now references the **Prometheus** datasource by name.

## [0.1.17] - 2026-05-18

### Changed

- Default **gghstats** container image tag **`v0.4.0`** ([gghstats v0.4.0](https://github.com/hrodrig/gghstats/releases/tag/v0.4.0) — Prometheus domain metrics): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Helm chart:** bump **`version:`** to **0.1.14**, **`appVersion`** to **0.4.0**; optional **`env.metricsPerRepo`** → `GGHSTATS_METRICS_PER_REPO`.

### Added

- **Observability docs:** domain metric names and example PromQL on [`run/docker-compose/observability/README.md`](run/docker-compose/observability/README.md) (requires app **≥ 0.4.0**).
- **`GGHSTATS_METRICS_PER_REPO`** documented in [`run/common/.env.example`](run/common/.env.example).
- **Grafana:** provisioned dashboard **gghstats — Domain metrics** (`uid: gghstats-domain`) under folder **gghstats**.

## [0.1.16] - 2026-05-17

### Added

- **`run/vps-recommended/`** — optional agnostic VPS baseline (Ansible): unattended upgrades, UFW, official **Docker CE** + Compose plugin, **Fail2ban** (default on; verified on Debian 13 with **`sshd`** jail), optional **`sshd`** hardening. Does not install gghstats or Traefik app config. Operator-local `inventory.yml` / `group_vars/all.yml` gitignored. See [`run/vps-recommended/README.md`](run/vps-recommended/README.md).

### Changed

- Root **README** and **`run/README.md`**: link to VPS baseline section and layout entry.

## [0.1.15] - 2026-05-17

### Changed

- Default **gghstats** container image tag **`v0.3.2`** ([gghstats v0.3.2](https://github.com/hrodrig/gghstats/releases/tag/v0.3.2)): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Helm chart:** bump **`version:`** to **0.1.13**, **`appVersion`** to **0.3.2** (includes [gghstats 0.3.2](https://github.com/hrodrig/gghstats/releases/tag/v0.3.2) fix for the index **(1d)** clone column).

## [0.1.14] - 2026-05-17

### Changed

- Default **gghstats** container image tag **`v0.3.1`** ([gghstats v0.3.1](https://github.com/hrodrig/gghstats/releases/tag/v0.3.1)): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Helm chart:** bump **`version:`** to **0.1.12**, **`appVersion`** to **0.3.1**.

## [0.1.13] - 2026-05-16

### Changed

- Default **gghstats** container image tag **`v0.3.0`** ([gghstats v0.3.0](https://github.com/hrodrig/gghstats/releases/tag/v0.3.0)): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Helm chart:** bump **`version:`** to **0.1.11**, **`appVersion`** to **0.3.0**.
- **`run/common/.env.example`:** note optional **`GGHSTATS_BADGE_PUBLIC`** / **`GGHSTATS_PUBLIC_URL`** (gghstats ≥ 0.3.0); clarify **`GGHSTATS_API_TOKEN`** covers sync and traffic APIs.
- **`AGENTS.md`:** supply-chain guidance (prefer in-repo manifest review and trusted image sources); state that **`.cursor/`** is **local-only** and not versioned. Drop reference to **`.cursor/rules`** for chart/version policy — use root **README** **Versioning** instead.

## [0.1.12] - 2026-05-17

### Added

- **Documentation:** [Custom UI theme (optional)](../README.md#custom-ui-theme-optional) in the root README — **`GGHSTATS_CUSTOM_CSS`**, **`v0.2.1`** image pin, Compose vs Helm notes, links to [gghstats `contrib/themes/`](https://github.com/hrodrig/gghstats/tree/main/contrib/themes) and upstream README.
- **`run/README.md`:** table row linking to the theme section.

### Changed

- Default **gghstats** container image tag **`v0.2.1`** ([gghstats v0.2.1](https://github.com/hrodrig/gghstats/releases/tag/v0.2.1)): [`run/common/.env.example`](run/common/.env.example), Compose image defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Compose:** pass optional **`GGHSTATS_CUSTOM_CSS`** into the **gghstats** service (Traefik + minimal stacks).
- **Helm chart:** bump **`version:`** to **0.1.10**, **`appVersion`** to **0.2.1**, optional **`env.customCss`** → **`GGHSTATS_CUSTOM_CSS`** in [`templates/deployment.yaml`](run/kubernetes/helm/gghstats/templates/deployment.yaml).
- **Documentation:** Custom UI theme — explicit **bind mount `/data`** (Compose / `docker run`) vs **Helm PVC** (and **`emptyDir`** when **`persistence.enabled: false`**), **`readOnlyRootFilesystem`**, UID **1000**; Helm chart README subsection for **`env.customCss`**. **`run/common/.env.example`** comments tie **`GGHSTATS_CUSTOM_CSS`** to the **`/data`** mount.

## [0.1.11] - 2026-05-11

### Changed

- **GitHub Actions:** bump [`actions/checkout`](https://github.com/actions/checkout) to **v6** and [`azure/setup-helm`](https://github.com/Azure/setup-helm) to **v5** ([`helm-lint`](.github/workflows/helm-lint.yml), [`release-charts`](.github/workflows/release-charts.yml)).

## [0.1.10] - 2026-05-11

### Changed

- Default **gghstats** container image tag **`v0.1.6`** ([gghstats v0.1.6](https://github.com/hrodrig/gghstats/releases/tag/v0.1.6)): [`run/common/.env.example`](run/common/.env.example), Compose image defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Helm chart:** bump **`version:`** to **0.1.9** and **`appVersion`** to **0.1.6**.

## [0.1.9] - 2026-05-03

### Changed

- Default **gghstats** container image tag **`v0.1.5`** ([gghstats v0.1.5](https://github.com/hrodrig/gghstats/releases/tag/v0.1.5)): [`run/common/.env.example`](run/common/.env.example), Compose image defaults, Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), [`run/docker/README.md`](run/docker/README.md), and root **README** examples.
- **Helm chart:** bump **`version:`** to **0.1.8** and **`appVersion`** to **0.1.5**.
- **Documentation:** operator checklist to upgrade the **gghstats** image — set **`GGHSTATS_VERSION`**, **pull** from GHCR, **`up -d`** (recreate); optional **`down`** first; **`restart`** does not swap images. **`run/common/.env.example`**, root **README** (Versioning), **`run/README.md`**, **`run/scripts/README.md`**, **`compose-stack.sh --help`** note.
- **Documentation:** root **README** — subsection **Validate gghstats image upgrade (Compose / Traefik)** with concrete commands (`env`, `compose config`, `pull`/`up -d`, `docker ps`, UI); optional observability note; TOC link.

## [0.1.8] - 2026-04-13

### Added

- **`compose-stack.sh`:** stacks **`prod`** (Traefik + gghstats: `up` / `down` / `restart` only) and **`full`** (same as **`--with-obs prod`**: Traefik then observability with Grafana Traefik overlay, correct order for `up` / `down` / `restart`). Docs: **`run/scripts/README.md`**, **`run/README.md`**, root **README**.

### Changed

- Default **gghstats** container image tag **`v0.1.4`** ([gghstats v0.1.4](https://github.com/hrodrig/gghstats/releases/tag/v0.1.4)): [`run/common/.env.example`](run/common/.env.example), Compose image defaults, Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), and docs.
- **Helm chart:** bump **`version:`** to **0.1.7** and **`appVersion`** to **0.1.4**.

## [0.1.7] - 2026-04-04

### Added

- **`run/scripts/compose-stack.sh`** — wrapper for **`docker compose`** on **minimal**, **Traefik**, and **observability** stacks (correct **`--env-file`**, **`-f`**, project **`gghstats-obs`**); **`--traefik`** for the observability Grafana overlay file. Help text documents **traefik** before **observability** for the shared **`gghstats_edge`** network. **`run/scripts/README.md`**; links from **`run/README.md`**, root **README**, and Compose READMEs.

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

[Unreleased]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.19...HEAD
[0.1.19]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.18...v0.1.19
[0.1.18]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.17...v0.1.18
[0.1.17]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.16...v0.1.17
[0.1.16]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.15...v0.1.16
[0.1.15]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.14...v0.1.15
[0.1.14]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.13...v0.1.14
[0.1.13]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.12...v0.1.13
[0.1.12]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.12
[0.1.11]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.11
[0.1.10]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.10
[0.1.9]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.9
[0.1.8]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.8
[0.1.7]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.7
[0.1.6]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.6
[0.1.5]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.5
[0.1.4]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.4
[0.1.3]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.3
[0.1.2]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.2
[0.1.1]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.1
[0.1.0]: https://github.com/hrodrig/gghstats-selfhosted/releases/tag/v0.1.0

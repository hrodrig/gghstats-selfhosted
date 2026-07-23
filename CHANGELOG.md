# Changelog

All notable changes to **gghstats-selfhosted** (deployment manifests, docs, and tooling for this repository only) are documented here. For the **gghstats** application, see [gghstats CHANGELOG](https://github.com/hrodrig/gghstats/blob/main/CHANGELOG.md).

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
This project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [0.1.50] - 2026-07-22

### Added

- **Docs:** Slack alert smoke-test checklist in root README (`gghstats alert test --sink slack`) plus anonymized capture [`assets/alert-test-slack.png`](assets/alert-test-slack.png).
- **Trusted proxies:** pass **`GGHSTATS_TRUSTED_PROXIES`** through minimal/Traefik Compose and Helm (`env.trustedProxies`); document Traefik/Docker CIDR setup for gghstats ≥ **0.10.2**.

### Changed

- Default **gghstats** container image tag **`v0.10.2`** ([gghstats v0.10.2](https://github.com/hrodrig/gghstats/releases/tag/v0.10.2) — trusted proxies SEC1, HTTP server timeouts SEC2, `x/net` pin): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples, platform-test defaults.
- **Helm chart:** bump **`version:`** to **0.1.36**, **`appVersion`** to **0.10.2**.
- **README:** sync version badge to **0.1.50**.

## [0.1.49] - 2026-07-18

### Added

- **Compose alerts:** minimal and Traefik pass `GGHSTATS_ALERTS_ENABLED`, sink/rule JSON, and standard Slack, Discord, Teams, n8n, Loki, and SMTP provider variables into the gghstats container.
- **Helm alerts:** `alerting.enabled`, `alerting.sinks`, `alerting.rules`, and `alerting.existingSecret`; provider credentials load from an existing Kubernetes Secret via `envFrom`.
- **Operator docs:** sink examples and `gghstats alert test` smoke-test flow in root README and `.env.example`.

### Changed

- **Helm chart:** bump **`version:`** to **0.1.35** (`appVersion` remains **0.10.1**).
- **README:** sync version badge to **0.1.49**.

## [0.1.48] - 2026-07-18

### Changed

- Default **gghstats** container image tag **`v0.10.1`** ([gghstats v0.10.1](https://github.com/hrodrig/gghstats/releases/tag/v0.10.1) — incremental star sync, opt-in alerts with Slack/webhook/Loki/SMTP, star milestones): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples, platform-test defaults.
- **Helm chart:** bump **`version:`** to **0.1.34**, **`appVersion`** to **0.10.1**.
- **README:** sync version badge to **0.1.48**.

## [0.1.47] - 2026-07-12

### Changed

- Default **gghstats** container image tag **`v0.9.0`** ([gghstats v0.9.0](https://github.com/hrodrig/gghstats/releases/tag/v0.9.0) — demo mode, backup/restore CLI, repo trends, distroless image, security headers/SRI): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples, platform-test defaults.
- **Compose / Helm:** pass **`GGHSTATS_DEMO`** (gghstats ≥ 0.9.0) and **`GGHSTATS_METRICS`**; Traefik no longer hard-requires `GGHSTATS_GITHUB_TOKEN` so demo mode can run without a token.
- **Helm chart:** bump **`version:`** to **0.1.33**, **`appVersion`** to **0.9.0**; **`env.demo`** value.
- **README:** sync version badge to **0.1.47**.

## [0.1.46] - 2026-07-10

### Changed

- Default **gghstats** container image tag **`v0.8.1`** ([gghstats v0.8.1](https://github.com/hrodrig/gghstats/releases/tag/v0.8.1) — Go **1.26.5** toolchain; stdlib security fixes): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples, platform-test defaults.
- **Helm chart:** bump **`version:`** to **0.1.32**, **`appVersion`** to **0.8.1**.
- **README:** sync version badge to **0.1.46**.

## [0.1.45] - 2026-06-27

### Fixed

- **Compose (minimal, Traefik):** pass `GGHSTATS_ENABLE_COLLECTOR` and `GGHSTATS_ENABLE_UPDATE_CHECK` from `${GGHSTATS_HOST_DATA}/.env` into the gghstats container (were documented in `.env.example` and supported by the app since v0.7.11, but omitted from the Compose environment blocks — collector remained disabled despite env file setting).
- **`.env.example`:** document `GGHSTATS_ENABLE_COLLECTOR` and `GGHSTATS_ENABLE_UPDATE_CHECK`.

### Changed

- **Helm chart:** bump **`version:`** to **0.1.31** (appImage unchanged at **v0.8.0**; `syncWorkers` helm value added in prior release).

## [0.1.44] - 2026-06-27

### Changed

- Default **gghstats** container image tag **`v0.8.0`** ([gghstats v0.8.0](https://github.com/hrodrig/gghstats/releases/tag/v0.8.0) — concurrent sync workers, exponential GitHub API retries, SQLite connection pooling, new Prometheus metrics for rate limiter/whitelist/badges/sync): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples.
- **Helm chart:** bump **`version:`** to **0.1.30**, **`appVersion`** to **0.8.0**.
- **Helm chart:** expose new `GGHSTATS_SYNC_WORKERS` env var via `env.syncWorkers` value (gghstats >= 0.8.0). Template uses truthy check so unset values are omitted from the pod spec.
- **README:** sync version badge to 0.1.44.

## [0.1.43] - 2026-06-25

### Changed

- Default **gghstats** container image tag **`v0.7.11`** ([gghstats v0.7.11](https://github.com/hrodrig/gghstats/releases/tag/v0.7.11) — head HTML injection, reverse proxy rules, anonymous usage collector, startup update check): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples.
- **Helm chart:** bump **`version:`** to **0.1.29**, **`appVersion`** to **0.7.11**.
- **Helm chart:** expose new `GGHSTATS_ENABLE_COLLECTOR` and `GGHSTATS_ENABLE_UPDATE_CHECK` env vars via `env.enableCollector` and `env.enableUpdateCheck` values (gghstats ≥ 0.7.11). Template uses truthy check so unset values are omitted from the pod spec.
- **README:** sync version badge to 0.1.43.

## [0.1.42] - 2026-06-19

### Changed

- Default **gghstats** container image tag **`v0.7.10`** ([gghstats v0.7.10](https://github.com/hrodrig/gghstats/releases/tag/v0.7.10) — whitelist bypass for valid `x-api-token`, clearer dashboard sync errors): Compose, Helm, `.env.example`, Linux standalone `.deb`/`.rpm` examples.
- **Helm chart:** bump **`version:`** to **0.1.28**, **`appVersion`** to **0.7.10**.
- **README:** note that gghstats ≥ 0.7.10 lets **Sync all** work through `GGHSTATS_WHITELIST` when `GGHSTATS_API_TOKEN` is set.
- **Platform tests:** default **`gghstats_image_version`** → **v0.7.10**.

## [0.1.41] - 2026-06-15

### Fixed

- **Traefik:** dedicated `gghstats-badges` router for `/api/v1/badge` without edge rate limiting (README embeds / GitHub image proxy).
- **Defaults:** `GGHSTATS_VERSION` / Compose / Helm **`appVersion`** → **v0.7.8**; fix `.deb`/`.rpm` example filenames in Linux standalone README.

### Changed

- **Helm chart:** bump **`version:`** to **0.1.27**, **`appVersion`** to **0.7.8**.
- **Traefik README:** document `gghstats-badges` router and gghstats ≥ 0.7.8 in-app exemption.

## [0.1.40] - 2026-06-14

### Added

- **Authelia SSO stack:** optional advanced authentication with 2FA (TOTP/WebAuthn) via Traefik forwardAuth. Protects `/api/` and `/h2h` — dashboard remains public. Includes compose file, override for Traefik labels, configuration templates, Valkey for sessions, and full README with setup guide.
- **compose-stack.sh:** add `authelia` stack and `--with-auth` flag for prod/full orchestration.

### Changed

- **Compose:** inject `GGHSTATS_RATE_LIMIT_*` and `GGHSTATS_WHITELIST*` env vars in both Traefik and minimal compose files.
- **env.example:** add Authelia secrets section.

## [0.1.39] - 2026-06-14

### Changed

- Default **gghstats** container image tag **`v0.7.7`** ([gghstats v0.7.7](https://github.com/hrodrig/gghstats/releases/tag/v0.7.7) — IP whitelist, query param sanitization, SQLite 3.53.2): Compose, README examples.
- **Compose:** add `GGHSTATS_WHITELIST*` env vars to `run/common/.env.example`.
- **README:** add IP whitelist note alongside rate limiting in Traefik section.

## [0.1.38] - 2026-06-14

### Changed

- Default **gghstats** container image tag **`v0.7.5`** ([gghstats v0.7.5](https://github.com/hrodrig/gghstats/releases/tag/v0.7.5) — per-IP rate limiting, alpine 3.24): Compose, Helm, README examples.
- **Helm chart:** bump **`version:`** to **0.1.26**, **`appVersion`** to **0.7.5**.
- **Helm:** add `GGHSTATS_RATE_LIMIT_*` env vars (`rateLimitEnabled`, `rateLimitRequests`, `rateLimitPeriod`, `rateLimitBurst`).
- **Compose:** add rate limit env vars to `run/common/.env.example`.
- **Traefik compose:** update rate-limit middleware comment to note gghstats >= 0.7.5 has built-in rate limiting.
- **README:** add rate limiting defence-in-depth note in Traefik section.

## [0.1.37] - 2026-06-10

### Changed

- Default **gghstats** container image tag **`v0.7.4`** ([gghstats v0.7.4](https://github.com/hrodrig/gghstats/releases/tag/v0.7.4) — canonical/meta SEO, Go 1.26.4): Compose, Helm, README examples, platform test defaults.
- **Helm chart:** bump **`version:`** to **0.1.25**, **`appVersion`** to **0.7.4**.

## [0.1.36] - 2026-05-29

### Changed

- Default **gghstats** container image tag **`v0.7.3`** ([gghstats v0.7.3](https://github.com/hrodrig/gghstats/releases/tag/v0.7.3) — per-site SEO `/robots.txt` + `/sitemap.xml`, **x/net** v0.55.0): Compose, Helm, README examples, platform test defaults.
- **Helm chart:** bump **`version:`** to **0.1.24**, **`appVersion`** to **0.7.3**.
- **`run/common/.env.example`:** document **`GGHSTATS_PUBLIC_URL`** for public sitemap/robots (gghstats ≥ 0.7.3).

## [0.1.35] - 2026-05-29

### Changed

- Default **gghstats** container image tag **`v0.7.2`** ([gghstats v0.7.2](https://github.com/hrodrig/gghstats/releases/tag/v0.7.2) — sqlite bump, **x/net** pin guard): Compose, Helm, README examples, platform test defaults.
- **Helm chart:** bump **`version:`** to **0.1.23**, **`appVersion`** to **0.7.2**.

## [0.1.34] - 2026-05-27

### Added

- **`testing/`** — Ansible **Compose minimal** platform tests on real VPS (`make test-compose-platforms`); **kind** + Helm smoke test (`make test-helm-kind`, requires `GGHSTATS_HELM_E2E_GITHUB_TOKEN`).
- **`Makefile`** — `release-check`, `test-compose-platforms`, `test-helm-kind` (local gates aligned with CI and operator paths).

### Changed

- Default **gghstats** container image tag **`v0.7.1`** ([gghstats v0.7.1](https://github.com/hrodrig/gghstats/releases/tag/v0.7.1) — security dependency bumps, FreeBSD port arch fix): Compose, Helm, README examples, platform test defaults.
- **Helm chart:** bump **`version:`** to **0.1.22**, **`appVersion`** to **0.7.1**.

## [0.1.33] - 2026-05-22

### Changed

- **Traefik (production Compose):** bump image **`traefik:v3.6.12`** → **`traefik:v3.6.17`** (stay on **≥ v3.6.14** for security advisories, including ForwardAuth header handling). Recreate with `traefik pull` + `traefik up -d`.

## [0.1.32] - 2026-05-22

### Fixed

- **Traefik (production Compose):** public router rule excludes **`/metrics`** (`!PathPrefix(\`/metrics\`)`) so Prometheus scrapes **`http://gghstats:8080/metrics`** on **`gghstats_edge`** only, not via the public hostname. Documented in [`run/docker-compose/traefik/README.md`](run/docker-compose/traefik/README.md).

## [0.1.31] - 2026-05-21

### Changed

- Default **gghstats** container image tag **`v0.6.3`** ([gghstats v0.6.3](https://github.com/hrodrig/gghstats/releases/tag/v0.6.3) — German UI polish and i18n test coverage): Compose, Helm, README examples.
- **Helm chart:** bump **`version:`** to **0.1.21**, **`appVersion`** to **0.6.3**.

## [0.1.30] - 2026-05-21

### Fixed

- **Compose (minimal, Traefik):** pass **`GGHSTATS_DEFAULT_LOCALE`**, **`GGHSTATS_ENABLED_LOCALES`**, and related app env vars from `${GGHSTATS_HOST_DATA}/.env` into the gghstats container (fixes sidebar showing only EN/ES/DE when fr/pt-br were set on the host).
- **Helm:** same i18n and optional env vars in [`deployment.yaml`](run/kubernetes/helm/gghstats/templates/deployment.yaml) and [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml).

### Changed

- **Helm chart:** bump **`version:`** to **0.1.20** (app image unchanged at **v0.6.2**).

## [0.1.29] - 2026-05-21

### Changed

- Default **gghstats** container image tag **`v0.6.2`** ([gghstats v0.6.2](https://github.com/hrodrig/gghstats/releases/tag/v0.6.2) — French and Brazilian Portuguese UI): Compose, Helm, README examples.
- **Helm chart:** bump **`version:`** to **0.1.19**, **`appVersion`** to **0.6.2**.

### Added

- **`run/common/.env.example`:** example **`GGHSTATS_ENABLED_LOCALES=en,es,de,fr,pt-br`**.

## [0.1.28] - 2026-05-21

### Changed

- Default **gghstats** container image tag **`v0.6.1`** ([gghstats v0.6.1](https://github.com/hrodrig/gghstats/releases/tag/v0.6.1) — Secure flag on locale cookie, CodeQL fix): [`run/common/.env.example`](run/common/.env.example), Compose defaults, Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), and README examples.
- **Helm chart:** bump **`version:`** to **0.1.18**, **`appVersion`** to **0.6.1**.

## [0.1.27] - 2026-05-20

### Changed

- Default **gghstats** container image tag **`v0.6.0`** ([gghstats v0.6.0](https://github.com/hrodrig/gghstats/releases/tag/v0.6.0) — Web UI i18n en/es/de): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), and README examples.
- **Helm chart:** bump **`version:`** to **0.1.17**, **`appVersion`** to **0.6.0**.

### Added

- **`run/common/.env.example`:** optional **`GGHSTATS_DEFAULT_LOCALE`** / **`GGHSTATS_ENABLED_LOCALES`** ([gghstats >= 0.6.0](https://github.com/hrodrig/gghstats/releases/tag/v0.6.0)); README versioning note links to upstream i18n docs.

## [0.1.26] - 2026-05-20

### Changed

- Default **gghstats** container image tag **`v0.5.2`** ([gghstats v0.5.2](https://github.com/hrodrig/gghstats/releases/tag/v0.5.2) — H2H momentum chart and copy fixes): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), and README examples.
- **Helm chart:** bump **`version:`** to **0.1.16**, **`appVersion`** to **0.5.2**.

## [0.1.24] - 2026-05-19

### Added

- **`.env.example`:** optional **`GGHSTATS_SYNC_ON_STARTUP`** ([gghstats >= 0.5.0](https://github.com/hrodrig/gghstats/releases/tag/v0.5.0)) — skip blocking full sync at container start when set to `false`.

### Changed

- Default **gghstats** container image tag **`v0.5.0`** ([gghstats v0.5.0](https://github.com/hrodrig/gghstats/releases/tag/v0.5.0) — Head to Head, optional startup sync): [`run/common/.env.example`](run/common/.env.example), Compose defaults ([Traefik](run/docker-compose/traefik/docker-compose.yml), [minimal](run/docker-compose/minimal/docker-compose.yml)), Helm [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml), and README examples.
- **Helm chart:** bump **`version:`** to **0.1.15**, **`appVersion`** to **0.5.0**.

## [0.1.23] - 2026-05-18

### Fixed

- **Grafana domain dashboard:** per-repo bar gauge queries now run in **Instant** mode (`instant: true`) so clone ranking renders in strict descending order (`sort_desc(topk(...))`) instead of time-range series order.

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

[Unreleased]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.50...HEAD
[0.1.50]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.49...v0.1.50
[0.1.49]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.48...v0.1.49
[0.1.48]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.47...v0.1.48
[0.1.47]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.46...v0.1.47
[0.1.46]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.45...v0.1.46
[0.1.45]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.44...v0.1.45
[0.1.44]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.37...v0.1.44
[0.1.37]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.36...v0.1.37
[0.1.36]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.35...v0.1.36
[0.1.26]: https://github.com/hrodrig/gghstats-selfhosted/compare/v0.1.24...v0.1.26
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

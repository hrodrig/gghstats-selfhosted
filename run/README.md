# How to run gghstats (self-hosted)

← [Back to the repository README](../README.md).

Pick a **mode** below. Commands are documented in each subdirectory’s `README.md`.

| Directory | When to use |
|-----------|-------------|
| [`common/`](common/) | Shared **environment variables** for Compose flows (copy `run/common/.env.example` → `.env` at repo root). |
| [`standalone/`](standalone/) | **Release binaries** from [gghstats Releases](https://github.com/hrodrig/gghstats/releases) — no Docker. |
| [`docker/`](docker/) | **`docker run`** with the GHCR image — minimal, no Compose file. |
| [`docker-compose/minimal/`](docker-compose/minimal/) | **One Compose service** — quick test or small VPS. |
| [`docker-compose/traefik/`](docker-compose/traefik/) | **Traefik + TLS** — production-style HTTPS on your domain. |
| [`docker-compose/observability/`](docker-compose/observability/) | **Optional** Prometheus, Grafana, Loki (after Traefik stack is up). |
| [`kubernetes/helm/`](kubernetes/helm/) | **Helm** chart — install from the [published Helm repo](https://hrodrig.github.io/gghstats-selfhosted) when available; sources live here. |
| [`kubernetes/manifests/`](kubernetes/manifests/) | Raw manifests — optional; see folder README. |

Always use the **published image tag** that matches your desired [gghstats](https://github.com/hrodrig/gghstats) release (see `GGHSTATS_VERSION` in `run/common/.env.example`).

---

**[↑ Back to the repository README](../README.md)**

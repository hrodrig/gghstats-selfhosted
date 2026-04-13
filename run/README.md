# How to run gghstats (self-hosted)

← [Back to the repository README](../README.md).

Pick a **mode** below. Commands are documented in each subdirectory’s `README.md`.

### Compose helper script

From the **repository root**, after **`GGHSTATS_HOST_DATA`** is set and env files exist (see below), you can use **[`run/scripts/compose-stack.sh`](scripts/compose-stack.sh)** instead of typing long `docker compose --env-file … -f …` lines:

```bash
export GGHSTATS_HOST_DATA=/path/to/your/gghstats-data
./run/scripts/compose-stack.sh minimal up -d
./run/scripts/compose-stack.sh traefik down
./run/scripts/compose-stack.sh --traefik observability up -d
# Traefik + gghstats only, or Traefik + gghstats + observability (ordered up/down/restart):
./run/scripts/compose-stack.sh prod restart
./run/scripts/compose-stack.sh full restart
```

Stacks: **`minimal`**, **`traefik`**, **`observability`**, **`prod`** (Traefik stack only, `up`/`down`/`restart`), **`full`** (Traefik + observability with Grafana overlay — same as **`--with-obs prod`**). For **`prod`** / **`full`**, only **`up`**, **`down`**, and **`restart`** are supported. Pass any other Compose subcommand on the single-stack targets (`logs`, `ps`, `pull`, …). **`./run/scripts/compose-stack.sh --help`** for options (`--data-dir`, `--traefik` for observability, `--with-obs` for **`prod`**).

| Directory | When to use |
|-----------|-------------|
| [`run/common/`](common/) | Shared **environment template** for Compose. Copy to **`${GGHSTATS_HOST_DATA}/.env`**, set **`GGHSTATS_HOST_DATA`** inside that file, then `docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f …` from the clone root (see [`run/common/.env.example`](common/.env.example)). |
| [`standalone/`](standalone/) | **Release binaries** from [gghstats Releases](https://github.com/hrodrig/gghstats/releases) — no Docker. |
| [`docker/`](docker/) | **`docker run`** with the GHCR image — minimal, no Compose file. |
| [`docker-compose/minimal/`](docker-compose/minimal/) | **One Compose service** — quick test or small VPS. |
| [`docker-compose/traefik/`](docker-compose/traefik/) | **Traefik + TLS** — production-style HTTPS on your domain. |
| [`docker-compose/observability/`](docker-compose/observability/) | **Optional** Prometheus, Grafana, Loki (after Traefik). Copy **[`observability.env.example`](docker-compose/observability/observability.env.example)** to **`${GGHSTATS_HOST_DATA}/.env.observability`** (same **`GGHSTATS_HOST_DATA`** as the main **`.env`**), then `docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs -f …` (see [README](docker-compose/observability/README.md)). |
| [`kubernetes/helm/`](kubernetes/helm/) | **Helm** chart — install from the [published Helm repo](https://hrodrig.github.io/gghstats-selfhosted) when available; sources live here. |
| [`kubernetes/manifests/`](kubernetes/manifests/) | Raw manifests — optional; see folder README. |

Always use the **published image tag** that matches your desired [gghstats](https://github.com/hrodrig/gghstats) release (see `GGHSTATS_VERSION` in [`run/common/.env.example`](common/.env.example)).

---

**[↑ Back to the repository README](../README.md)**

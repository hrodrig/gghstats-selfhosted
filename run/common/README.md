# Shared environment (`run/common`)

← [Back to run/README](../README.md).

Copy **[`.env.example`](.env.example)** to **`${GGHSTATS_HOST_DATA}/.env`** on the host (same directory as SQLite — outside the git clone). Set **`GGHSTATS_HOST_DATA`** in that file to the same absolute path, then run Compose with **`docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f …`** from the repository root. Optional local-only path: **`./.env`** at the repo root with **`GGHSTATS_HOST_DATA`** unset (uses repo **`data/`**). Do not commit real secrets.

The template covers:

- **gghstats** — GitHub token, image tag, filters, sync interval
- **minimal Compose** — port and related overrides
- **Traefik production stack** — hostname, ACME email, **`GGHSTATS_HOST_DATA`** (host path for SQLite; absolute path recommended), container UID/GID must own that directory

**Observability** (optional) uses a **second** file in that same directory: copy **`run/docker-compose/observability/observability.env.example`** to **`${GGHSTATS_HOST_DATA}/.env.observability`**. **`GGHSTATS_HOST_DATA`** must be the same value as in **`${GGHSTATS_HOST_DATA}/.env`**. Pass **`--env-file "${GGHSTATS_HOST_DATA}/.env.observability"`** to every observability `docker compose` command. See **`run/docker-compose/observability/README.md`**.

---

**[↑ Back to run/README](../README.md)**

# Shared environment (`run/common`)

← [Back to run/README](../README.md).

Copy **[`.env.example`](.env.example)** to a file used with **`docker compose --env-file …`** — commonly **`.env` in the repository root**, or **`.env` inside your persistent directory** (e.g. `/home/gghstats/gghstats-data/.env` next to SQLite and `.env.observability`). Do not commit real secrets.

The template covers:

- **gghstats** — GitHub token, image tag, filters, sync interval
- **minimal Compose** — port and related overrides
- **Traefik production stack** — hostname, ACME email, **`GGHSTATS_HOST_DATA`** (host path for SQLite; absolute path recommended), container UID/GID must own that directory

Observability uses a separate env file: copy **`run/docker-compose/observability/observability.env.example`** to **`${GGHSTATS_HOST_DATA}/.env.observability`** (outside the clone, next to your main `.env` and SQLite). See **`run/docker-compose/observability/README.md`**.

---

**[↑ Back to run/README](../README.md)**

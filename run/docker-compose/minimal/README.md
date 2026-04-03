# Minimal Compose

← [Back to run/README](../../README.md).

Single **gghstats** service using the **GHCR image**. Set **`GGHSTATS_HOST_DATA`** in `.env` to a **host directory** for SQLite (recommended: absolute path, e.g. `/home/gghstats/gghstats-data`). If unset, Compose bind-mounts the repo’s **`data/`** (tracked empty via **`data/.keep`**; other files under **`data/`** are gitignored — see root `.gitignore`).

From the **repository root**:

```bash
cp run/common/.env.example .env
# Edit .env — at minimum GGHSTATS_GITHUB_TOKEN and GGHSTATS_VERSION

docker compose -f run/docker-compose/minimal/docker-compose.yml up -d
```

Stop:

```bash
docker compose -f run/docker-compose/minimal/docker-compose.yml down
```

For **HTTPS and a public hostname**, use **[`run/docker-compose/traefik/`](../traefik/)** instead.

---

**[↑ Back to run/README](../../README.md)**

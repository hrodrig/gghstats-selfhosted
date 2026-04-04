# Minimal Compose

← [Back to run/README](../../README.md).

Single **gghstats** service using the **GHCR image**. Set **`GGHSTATS_HOST_DATA`** in **`${GGHSTATS_HOST_DATA}/.env`** to a **host directory** for SQLite (recommended: absolute path, e.g. `/home/gghstats/gghstats-data`). If **`GGHSTATS_HOST_DATA`** is unset in the env file you pass to Compose, the stack bind-mounts the repo’s **`data/`** (tracked empty via **`data/.keep`**; other files under **`data/`** are gitignored — see root `.gitignore`).

**Shortcut:** [`run/scripts/compose-stack.sh`](../../scripts/compose-stack.sh) — e.g. `./run/scripts/compose-stack.sh minimal up -d` (same `--env-file` / `-f` as below).

From the **repository root**:

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"
cp run/common/.env.example "${GGHSTATS_HOST_DATA}/.env"
# Edit "${GGHSTATS_HOST_DATA}/.env" — GGHSTATS_GITHUB_TOKEN, GGHSTATS_VERSION, GGHSTATS_HOST_DATA (same path)

docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/minimal/docker-compose.yml up -d
```

Stop:

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/minimal/docker-compose.yml down
```

For **HTTPS and a public hostname**, use **[`run/docker-compose/traefik/`](../traefik/)** instead.

---

**[↑ Back to run/README](../../README.md)**

# Docker (`docker run`)

← [Back to run/README](../README.md).

Run the published image without Compose. Use the same **host directory** idea as in **`run/common/.env.example`**: set **`GGHSTATS_HOST_DATA`** to an **absolute path** on the server (SQLite and optional `.env` colocation).

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"

docker run -d \
  -e GGHSTATS_GITHUB_TOKEN=ghp_xxx \
  -e GGHSTATS_FILTER="your-github-user/*" \
  -p 8080:8080 \
  -v "${GGHSTATS_HOST_DATA}:/data" \
  --name gghstats \
  ghcr.io/hrodrig/gghstats:v0.1.4
```

Replace the path with your own (e.g. `/var/lib/gghstats`). Avoid **`$(pwd)/data`** in production — it depends on the current working directory and is easy to mis-mount.

The image tag must match a published **GHCR** image from [gghstats releases](https://github.com/hrodrig/gghstats/releases) — same value as **`GGHSTATS_VERSION`** in **[`run/common/.env.example`](../common/.env.example)** (e.g. `v0.1.4`). For **all** environment variables supported by the binary/container, see the upstream **[`.env.example`](https://github.com/hrodrig/gghstats/blob/main/.env.example)** on **`main`** in the gghstats repository.

For **Compose-based** setups (persistent layout, Traefik, observability), use **`run/docker-compose/`** instead.

---

**[↑ Back to run/README](../README.md)**

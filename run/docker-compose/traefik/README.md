# Traefik + TLS (production-style)

← [Back to run/README](../../README.md).

**Traefik** terminates HTTPS (Let’s Encrypt) and routes to **gghstats** on the **`gghstats_edge`** Docker network. No host port is published for gghstats; only **80** and **443** for Traefik.

**Shortcut:** [`run/scripts/compose-stack.sh`](../../scripts/compose-stack.sh) — e.g. `./run/scripts/compose-stack.sh traefik up -d`.

From the **repository root**:

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"
cp run/common/.env.example "${GGHSTATS_HOST_DATA}/.env"
# Set GGHSTATS_GITHUB_TOKEN, GGHSTATS_HOSTNAME, ACME_EMAIL, GGS_UID, GGS_GID,
# GGHSTATS_VERSION, and GGHSTATS_HOST_DATA (same absolute path; directory must be owned by GGS_UID:GGS_GID)

docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/traefik/docker-compose.yml up -d
```

Ensure DNS for `GGHSTATS_HOSTNAME` points to this host and **80/443** are reachable for ACME.

Optional **Prometheus / Grafana / Loki**: **[`run/docker-compose/observability/`](../observability/README.md)** (start this Traefik stack first so `gghstats_edge` exists).

---

**[↑ Back to run/README](../../README.md)**

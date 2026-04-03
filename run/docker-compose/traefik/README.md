# Traefik + TLS (production-style)

← [Back to run/README](../../README.md).

**Traefik** terminates HTTPS (Let’s Encrypt) and routes to **gghstats** on the **`gghstats_edge`** Docker network. No host port is published for gghstats; only **80** and **443** for Traefik.

From the **repository root**:

```bash
cp run/common/.env.example .env
# Set GGHSTATS_GITHUB_TOKEN, GGHSTATS_HOSTNAME, ACME_EMAIL, GGS_UID, GGS_GID,
# and GGHSTATS_HOST_DATA (absolute host path for SQLite; directory must be owned by GGS_UID:GGS_GID)

docker compose -f run/docker-compose/traefik/docker-compose.yml up -d
```

Ensure DNS for `GGHSTATS_HOSTNAME` points to this host and **80/443** are reachable for ACME.

Optional **Prometheus / Grafana / Loki**: **[`run/docker-compose/observability/`](../observability/README.md)** (start this Traefik stack first so `gghstats_edge` exists).

---

**[↑ Back to run/README](../../README.md)**

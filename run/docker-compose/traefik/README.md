# Traefik + TLS (production-style)

← [Back to run/README](../../README.md).

**Traefik** terminates HTTPS (Let’s Encrypt) and routes to **gghstats** on the **`gghstats_edge`** Docker network. No host port is published for gghstats; only **80** and **443** for Traefik.

**Prometheus `/metrics`:** the public router rule excludes `PathPrefix(`/metrics`)`, so `https://<GGHSTATS_HOSTNAME>/metrics` is **not** reachable from the Internet. Scraping uses the Compose service name on the internal network (`http://gghstats:8080/metrics` in [`observability/prometheus.yml`](../observability/observability/prometheus.yml)). After changing labels, recreate the stack (`up -d`) so Traefik reloads routing.

Compose **project** `gghstats-edge` (containers `gghstats-edge-traefik-1`, `gghstats-edge-gghstats-1`) — same naming style as observability `gghstats-obs-*`. Use **`docker compose exec gghstats …`** (service name), not the old fixed names `traefik` / `gghstats`.

**Shortcut:** [`run/scripts/compose-stack.sh`](../../scripts/compose-stack.sh) — e.g. `./run/scripts/compose-stack.sh traefik up -d`.

From the **repository root**:

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"
cp run/common/.env.example "${GGHSTATS_HOST_DATA}/.env"
# Set GGHSTATS_GITHUB_TOKEN, GGHSTATS_HOSTNAME, ACME_EMAIL, GGS_UID, GGS_GID,
# GGHSTATS_VERSION, and GGHSTATS_HOST_DATA (same absolute path; directory must be owned by GGS_UID:GGS_GID)

docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml up -d
```

Ensure DNS for `GGHSTATS_HOSTNAME` points to this host and **80/443** are reachable for ACME.

**Exec / logs** (service names):

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml exec gghstats env | grep GGHSTATS_METRICS
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml logs -f traefik
```

**Upgrade from 0.1.19 (`container_name: traefik` / `gghstats`, Compose project `traefik`):** use **`./run/scripts/compose-stack.sh full down`** (0.1.21+ also stops legacy project `traefik` and removes those containers), then **`full up -d`**. You should see **`gghstats-edge-traefik-1`** and **`gghstats-edge-gghstats-1`** in `docker ps`.

Optional **Prometheus / Grafana / Loki**: **[`run/docker-compose/observability/`](../observability/README.md)** (start this Traefik stack first so `gghstats_edge` exists).

---

**[↑ Back to run/README](../../README.md)**

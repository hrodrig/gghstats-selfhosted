# Refreshing observability image digest pins (developer guide)

[`docker-compose.observability.yml`](docker-compose.observability.yml) pins **Prometheus**, **Loki**, **Promtail**, and **Grafana** by **image digest** for `linux/amd64`, with `platform: linux/amd64` on each service. Follow this document when you **bump image versions** or need to **re-pin** after upstream retags.

## Why digest + `linux/amd64`

| Concern | What we do |
|---------|------------|
| **Reproducible deploys** | Same digest → same root filesystem layers on the VPS. |
| **Security scanners** (e.g. Trivy) | Baselines match the pinned artifact; avoid “latest moved under us”. |
| **Typical server** | Production is usually **linux/amd64**. |
| **Apple Silicon (M1/M2/M3)** | Without `platform: linux/amd64`, Docker often pulls **arm64** variants. The VPS would run a different image than you tested. |

**Important:** `docker pull prom/prometheus:v2.55.1` prints a **manifest list** digest at the end (multi-arch index). For Compose pins you need the digest of the **`linux/amd64` variant**, not only that index digest. Use `docker buildx imagetools inspect` (below).

## Prerequisites

- **Docker** with **Buildx** (default in current Docker Desktop / Engine): `docker buildx version`
- Network access to `docker.io` (or your mirror) when pulling/inspecting

## Step 1 — Pick the new tag

Decide semver tags upstream (examples: `prom/prometheus:v2.55.2`, `grafana/grafana:12.4.2`). Check release notes for breaking changes.

**Grafana:** `grafana/grafana:<version>` is the **Alpine** image; `grafana/grafana:<version>-ubuntu` is **Ubuntu**. Use the same tag when running `imagetools inspect` that you intend to deploy (pins differ per variant).

## Step 2 — Pull the amd64 variant (optional but useful)

Pulling materializes layers locally and confirms the tag resolves.

```bash
docker pull --platform linux/amd64 prom/prometheus:v2.55.1
```

Repeat for each image you will pin, or skip to Step 3 if you only need the digest.

## Step 3 — Read the `linux/amd64` manifest digest

Use **Buildx imagetools** (works without a local pull):

```bash
docker buildx imagetools inspect prom/prometheus:v2.55.1
```

In the output, find the block:

```text
  Name:      docker.io/prom/prometheus:v2.55.1@sha256:<DIGEST_AMD64>
  MediaType: application/vnd.docker.distribution.manifest.v2+json
  Platform:  linux/amd64
```

Copy **`<DIGEST_AMD64>`** (64 hex chars). The full pin is:

```text
prom/prometheus@sha256:<DIGEST_AMD64>
```

**Check:** The digest must sit on the `Name:` line **above** `Platform:  linux/amd64`. The next block is often **arm64** with a different digest; using that digest with `platform: linux/amd64` fails on the server with *does not provide the specified platform (linux/amd64)*.

Do **not** use only the top-level “Digest:” line if it refers to the **manifest list** (index); always confirm the line **above** `Platform: linux/amd64`.

### One-liner helper (copy digest only)

Adjust the image argument as needed:

```bash
docker buildx imagetools inspect prom/prometheus:v2.55.1 \
  | awk '/Name:.*@sha256:/{name=$0} /Platform:.*linux\/amd64/{print name; exit}' \
  | sed 's/.*@sha256:/sha256:/'
```

You should see a single line like `sha256:b1935d181b6dd8e9c827705e89438815337e1b10ae35605126f05f44e5c6940f`.

## Step 4 — Update `docker-compose.observability.yml`

For each service:

1. Set **`image:`** to `repository/name@sha256:<DIGEST_AMD64>`.
2. Keep **`platform: linux/amd64`** (already present).
3. Update the **comment** above the image with the human-readable tag, e.g. `# Tag (linux/amd64): v2.55.1`.

Current services and upstream repositories:

| Service in Compose | Example image ref |
|--------------------|-------------------|
| `prometheus` | `prom/prometheus` |
| `node-exporter` | `prom/node-exporter` |
| `loki` | `grafana/loki` |
| `promtail` | `grafana/promtail` |
| `grafana` | `grafana/grafana` |

## Step 5 — Verify locally

From the repository root, with **`GGHSTATS_HOST_DATA`** exported and a minimal **`${GGHSTATS_HOST_DATA}/.env.observability`** (copy from **`observability.env.example`**, set at least **`GRAFANA_ADMIN_PASSWORD`**):

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs \
  -f run/docker-compose/observability/docker-compose.observability.yml config >/dev/null && echo OK
```

Optionally dry-run pull (does not start the stack):

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs \
  -f run/docker-compose/observability/docker-compose.observability.yml pull
```

## Step 6 — Documentation

- Update **[README.md](README.md)** in this directory if versions or assumptions change materially.

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| **Wrong architecture on M1** | Ensure `platform: linux/amd64` is set and the digest is from the **linux/amd64** block in `imagetools inspect`. |
| **`imagetools` shows no amd64** | Rare; upstream may have dropped the arch. Check another tag or arch in release notes. |
| **Digest changed without tag change** | Upstream may have rebuilt the tag (mutable tag practice). Re-inspect and re-pin, or prefer tags that are immutable. |

## See also

- [README.md](README.md) — full observability overview
- [Prometheus OCI tags](https://hub.docker.com/r/prom/prometheus/tags) / Grafana images on Docker Hub

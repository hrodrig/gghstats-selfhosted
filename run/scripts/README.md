# Helper scripts

← [Back to run/README](../README.md).

| Script | Purpose |
|--------|---------|
| [`compose-stack.sh`](compose-stack.sh) | Run **`docker compose`** for **minimal**, **Traefik**, or **observability** stacks with the correct **`--env-file`**, **`-f`**, and project name — from any cwd (resolves paths from the clone root). Stacks **`prod`** (Traefik + gghstats only) and **`full`** (same as **`--with-obs prod`**: Traefik + observability with Grafana-via-Traefik overlay) run **`up` / `down` / `restart`** in a safe order so you do not have to remember which compose to stop first. |

**Usage:** `./run/scripts/compose-stack.sh --help`

**Typical production with observability:** `./run/scripts/compose-stack.sh full restart` (or `full up -d` / `full down`).

**New gghstats image version:** edit **`GGHSTATS_VERSION`**, then **pull** (download from GHCR) and **`traefik up -d`** so the service is **recreated** with the new tag (`pull` + `up -d`, or **`up -d --pull always`**). Optional **`traefik down`** before pull/up for a full stop/start. **`restart`** / **`full restart`** does **not** replace the image — same container, same image it was created with.

**Full validation checklist** (env, `compose config`, `docker ps`, browser): [repository README — Validate gghstats image upgrade](../../README.md#validate-gghstats-image-upgrade-compose--traefik).

**[↑ Back to run/README](../README.md)**

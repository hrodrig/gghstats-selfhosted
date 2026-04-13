# Helper scripts

← [Back to run/README](../README.md).

| Script | Purpose |
|--------|---------|
| [`compose-stack.sh`](compose-stack.sh) | Run **`docker compose`** for **minimal**, **Traefik**, or **observability** stacks with the correct **`--env-file`**, **`-f`**, and project name — from any cwd (resolves paths from the clone root). Stacks **`prod`** (Traefik + gghstats only) and **`full`** (same as **`--with-obs prod`**: Traefik + observability with Grafana-via-Traefik overlay) run **`up` / `down` / `restart`** in a safe order so you do not have to remember which compose to stop first. |

**Usage:** `./run/scripts/compose-stack.sh --help`

**Typical production with observability:** `./run/scripts/compose-stack.sh full restart` (or `full up -d` / `full down`).

**[↑ Back to run/README](../README.md)**

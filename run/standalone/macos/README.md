# macOS (standalone binary)

← [Back to run/README](../../README.md).

**Smoke test** (UI only) — same flow as [gghstats Quick start](https://github.com/hrodrig/gghstats#quick-start): `export GGHSTATS_GITHUB_TOKEN=ghp_xxx` and `gghstats run --open`.

1. Install: `brew install hrodrig/gghstats/gghstats`, or download the **macOS** archive from [gghstats Releases](https://github.com/hrodrig/gghstats/releases).
2. Run the smoke-test commands above. Other variables: **[gghstats `.env.example`](https://github.com/hrodrig/gghstats/blob/main/.env.example)**.
3. For a long-running server, consider **Launchd** or run inside **Docker** (`run/docker/` / `run/docker-compose/`).

Docker Desktop paths differ from Linux; optional **Promtail** log shipping in the observability stack is tuned for Linux Engine.

---

**[↑ Back to run/README](../../README.md)**

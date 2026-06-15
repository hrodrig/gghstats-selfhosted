# Windows (standalone binary)

← [Back to run/README](../../README.md).

**Smoke test** (UI only) — same flow as [gghstats Quick start](https://github.com/hrodrig/gghstats#quick-start): set `GGHSTATS_GITHUB_TOKEN`, then `gghstats.exe run --open`.

1. Download the **Windows** zip from [gghstats Releases](https://github.com/hrodrig/gghstats/releases).
2. `set GGHSTATS_GITHUB_TOKEN=ghp_xxx` (cmd) or `$env:GGHSTATS_GITHUB_TOKEN="ghp_xxx"` (PowerShell), then `gghstats.exe run --open`.
3. For a background service, use **Task Scheduler**, **NSSM**, or run the app in **Docker Desktop** using **`run/docker/`** or **`run/docker-compose/`**. Other variables: **[gghstats `.env.example`](https://github.com/hrodrig/gghstats/blob/main/.env.example)**.

Optional **Promtail** log shipping in the observability stack targets Linux Docker paths; adjust mounts if you run observability on Windows.

---

**[↑ Back to run/README](../../README.md)**

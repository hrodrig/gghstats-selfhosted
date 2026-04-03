# Windows (standalone binary)

← [Back to run/README](../../README.md).

1. Download the **Windows** zip from [gghstats Releases](https://github.com/hrodrig/gghstats/releases).
2. Extract `gghstats.exe` and run it from **PowerShell** or **cmd**, setting `GGHSTATS_GITHUB_TOKEN` and other variables (see **[gghstats `.env.example`](https://github.com/hrodrig/gghstats/blob/develop/.env.example)**).
3. For a background service, use **Task Scheduler**, **NSSM**, or run the app in **Docker Desktop** using **`run/docker/`** or **`run/docker-compose/`**.

Optional **Promtail** log shipping in the observability stack targets Linux Docker paths; adjust mounts if you run observability on Windows.

---

**[↑ Back to run/README](../../README.md)**

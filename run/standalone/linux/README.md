# Linux (standalone binary)

← [Back to run/README](../../README.md).

1. Download the **Linux** tarball for your architecture from [gghstats Releases](https://github.com/hrodrig/gghstats/releases) (e.g. `gghstats_*_linux_amd64.tar.gz`).
2. Extract the binary and install it on your `PATH`, or run it from a directory of your choice.
3. Set `GGHSTATS_GITHUB_TOKEN` and other variables (see **[gghstats `.env.example`](https://github.com/hrodrig/gghstats/blob/develop/.env.example)**).
4. Run **`./gghstats serve`** for the web dashboard (see upstream **Usage** for CLI subcommands).

For **systemd**, create a unit that runs the binary with `EnvironmentFile=` pointing to a root-only file containing secrets. Keep the SQLite database path stable (e.g. `/var/lib/gghstats/data`).

Docker-based options are under **`run/docker/`** and **`run/docker-compose/`**.

---

**[↑ Back to run/README](../../README.md)**

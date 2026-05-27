# Linux (standalone binary and packages)

← [Back to run/README](../../README.md) · [Standalone overview](../README.md) (if present) · [Repository README](../../../README.md).

Use this guide when you run **gghstats as a native Linux binary** (tarball, `.deb`, or `.rpm`) — not Docker. For **Compose, Traefik, Helm, and `GGHSTATS_HOST_DATA`**, use **[`run/docker-compose/`](../../docker-compose/)** and **[`run/common/.env.example`](../../common/.env.example)** instead.

**Application behavior** (filters, API, i18n, H2H): [gghstats README — Configuration](https://github.com/hrodrig/gghstats#configuration).

---

## Quick install (command only)

| Platform | Command |
|----------|---------|
| **Tarball** | Download `gghstats_*_linux_*.tar.gz` from [gghstats Releases](https://github.com/hrodrig/gghstats/releases), extract, run `./gghstats serve` |
| **Debian / Ubuntu** | See [`.deb` package](#debian--ubuntu-deb) below |
| **Fedora / RHEL / AlmaLinux / Rocky / Oracle** | See [`.rpm` package](#fedora--rhel--almalinux-rpm) below |

Set **`GGHSTATS_GITHUB_TOKEN`** before `gghstats serve`. For a **smoke test** of the UI only, a minimal env is enough; for a **server**, complete the configuration sections below (or prefer [Docker Compose Traefik](../../docker-compose/traefik/README.md)).

---

## Configuration on Linux (bare metal)

gghstats reads **`GGHSTATS_*` environment variables**. On servers, use a single file:

| What | Path |
|------|------|
| Environment file | **`/etc/gghstats/gghstats.env`** (from [gghstats `contrib/gghstats.env.example`](https://github.com/hrodrig/gghstats/blob/main/contrib/gghstats.env.example)) |
| SQLite database | **`/var/lib/gghstats/gghstats.db`** — set `GGHSTATS_DB` in the env file |
| Binary | **`/usr/bin/gghstats`** (`.deb`/`.rpm`) or your install path |

```bash
sudo mkdir -p /etc/gghstats /var/lib/gghstats
sudo cp contrib/gghstats.env.example /etc/gghstats/gghstats.env   # from gghstats release or clone
sudo chmod 600 /etc/gghstats/gghstats.env
sudo nano /etc/gghstats/gghstats.env
```

**Recommended values for a server behind nginx or Traefik on the same host:**

- `GGHSTATS_HOST=127.0.0.1` — do not expose `8080` on the public internet without a proxy
- `GGHSTATS_FILTER` — narrow scope (e.g. `your-user/*,!fork,!archived`); avoid `*` on large accounts
- `GGHSTATS_SYNC_ON_STARTUP` — `true` for first deploy; `false` if you want the UI up immediately on an existing DB

**Public HTTPS with Traefik + domain:** use **[gghstats-selfhosted Traefik stack](../../docker-compose/traefik/README.md)** instead of bare `8080`.

Variable reference (semantics): [gghstats Configuration](https://github.com/hrodrig/gghstats#configuration).

---

## systemd service

Packages install **`gghstats.service`** to `/lib/systemd/system/`. Unit source: [gghstats `contrib/systemd/gghstats.service`](https://github.com/hrodrig/gghstats/blob/main/contrib/systemd/gghstats.service).

Full setup and troubleshooting: [gghstats `contrib/systemd/README.md`](https://github.com/hrodrig/gghstats/blob/main/contrib/systemd/README.md).

**Enable after editing `/etc/gghstats/gghstats.env`:**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now gghstats
journalctl -u gghstats -f
```

**Optional dedicated user:**

```bash
sudo useradd -r -d /var/lib/gghstats -s /usr/sbin/nologin gghstats
sudo chown -R gghstats:gghstats /var/lib/gghstats
# Uncomment User=/Group= in gghstats.service, then daemon-reload && restart
```

Scheduling runs inside `gghstats serve` (`GGHSTATS_SYNC_INTERVAL`); there is no separate timer unit.

---

## Debian / Ubuntu (`.deb`)

The same `.deb` works on Debian and Ubuntu. Installs `/usr/bin/gghstats`, `/etc/gghstats/gghstats.env`, `man gghstats`, and `gghstats.service`.

**From GitHub** (replace version / arch):

```bash
wget -q -O /tmp/gghstats.deb https://github.com/hrodrig/gghstats/releases/download/v0.7.1/gghstats_0.7.1_linux_amd64.deb
sudo dpkg -i /tmp/gghstats.deb
```

**Local build** (`make snapshot` in gghstats → `dist/`):

```bash
sudo dpkg -i ./gghstats_0.7.1_linux_amd64.deb
```

**Then:** [Configuration on Linux](#configuration-on-linux-bare-metal) → [systemd](#systemd-service).

```bash
sudo chmod 600 /etc/gghstats/gghstats.env
sudo nano /etc/gghstats/gghstats.env
sudo systemctl enable --now gghstats
curl -sS http://127.0.0.1:8080/api/v1/healthz
```

---

## Fedora / RHEL / AlmaLinux (`.rpm`)

Same `.rpm` for Fedora, AlmaLinux, Rocky Linux, and Oracle Linux.

**From GitHub:**

```bash
sudo dnf install -y "https://github.com/hrodrig/gghstats/releases/download/v0.7.1/gghstats_0.7.1_linux_amd64.rpm"
```

**Local build:**

```bash
sudo dnf install ./gghstats_0.7.1_linux_amd64.rpm
```

**Then:** same as Debian — edit `/etc/gghstats/gghstats.env`, [systemd](#systemd-service).

---

## Docker-based production (recommended)

Bare-metal systemd is optional. Most operators use **[`run/docker-compose/minimal/`](../../docker-compose/minimal/)**, **[Traefik + TLS](../../docker-compose/traefik/README.md)**, or **[Helm](../../kubernetes/helm/gghstats/README.md)** with env from **[`run/common/.env.example`](../../common/.env.example)**.

---

**[↑ Back to run/README](../../README.md)**

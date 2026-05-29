# Compose platform tests (Ansible)

Batch validation of the **Docker Compose minimal stack** from this repository on **real machines** (VPS, lab VMs), similar in spirit to **[pgwd-selfhosted `testing/platforms`](https://github.com/hrodrig/pgwd-selfhosted/tree/develop/testing/platforms)** but for **gghstats** (GitHub token + SQLite, no Postgres).

These playbooks **fail fast on the same prerequisite checks** a human operator would hit: missing **Docker** or **Compose**, wrong **inventory**, unreachable **SSH**, missing **GitHub token**, etc. They mirror what you see when running **`compose-stack.sh minimal`** on a host that is not ready yet.

## Scope

| Suite | What it validates |
| --- | --- |
| **This directory** | **Docker** + **Compose v2** on **Linux** VPS; clone **gghstats-selfhosted**; **`compose-stack.sh minimal`**; **`/api/v1/healthz`**; teardown |
| [gghstats](https://github.com/hrodrig/gghstats) | Go unit tests (`make test`); **native OS** installs (`.deb`/`.rpm`/BSD) via **`make test-platforms`** in **`gghstats/testing/platforms/`** — not Docker |
| **`make test-helm-kind`** | **kind** + Helm chart (see [testing/kind/README.md](../kind/README.md)) |

**Not in scope here:** Traefik, observability, or Helm on real clusters (extend playbooks later if needed).

## Prerequisites

### Control node (your laptop or CI with SSH access)

- **Ansible** 2.14+
- SSH key access to targets (**`root`** or a user with **passwordless `sudo`** and **Docker**)

### Each target host

1. **Docker Engine** and **Docker Compose v2** (`docker compose`). Install on each target **before** running playbooks.
2. **Git** (the prepare role installs **git** when missing).
3. **Python 3** on the control node for Ansible. Target hosts must be **Linux with Docker** (not \*BSD — BSD has no supported Docker path for this Compose suite).
4. A **GitHub fine-grained or classic PAT** with **read** access to the repos you put in **`gghstats_filter`** (set in inventory as **`gghstats_github_token`**).

## Quick start

```bash
cd /path/to/gghstats-selfhosted
cp testing/platforms/inventory/hosts.yml.example testing/platforms/inventory/hosts.yml
# Edit hosts.yml: ansible_host, gghstats_github_token, gghstats_host_data, optional filter

make
make test-compose-platforms

# Single host
make test-compose-platforms LIMIT=vps-ubuntu
```

Or from `testing/platforms/`:

```bash
ansible-playbook playbooks/full-cycle.yml
ansible-playbook playbooks/full-cycle.yml --limit vps-ubuntu
```

## Playbooks

| Playbook | Description |
| --- | --- |
| `playbooks/setup.yml` | Install **git** if needed, clone/update repo, create **`gghstats_host_data`**, template **`${gghstats_host_data}/.env`**, set ownership (**1000:1000**) |
| `playbooks/test.yml` | **`minimal up -d`**, log-based readiness, **`/api/v1/healthz`** HTTP check |
| `playbooks/teardown.yml` | **`compose-stack.sh minimal down`** (idempotent) |
| `playbooks/full-cycle.yml` | **setup** → **test** → **teardown** |

To leave the stack running after a successful test:

```bash
cd testing/platforms
ansible-playbook playbooks/setup.yml playbooks/test.yml
```

## Inventory

Copy **`inventory/hosts.yml.example`** to **`inventory/hosts.yml`** (gitignored). Set at least:

- **`ansible_host`**, **`ansible_port`**, **`ansible_user`**
- **`gghstats_github_token`** — PAT (never commit)
- **`gghstats_host_data`** — e.g. `/var/lib/gghstats-compose` (must match **`GGHSTATS_HOST_DATA`** inside the generated **`.env`**)
- Optional: **`gghstats_compose_repo_version`** (default `develop`), **`gghstats_image_version`** (default `v0.7.2`), **`gghstats_port`**, **`gghstats_filter`**, **`gghstats_sync_on_startup`** (default **`false`** for faster smoke tests)

**`gghstats_container_uid` / `gghstats_container_gid`** default **1000:1000** (official GHCR image). Override if you use a custom image — verify with `docker run --rm --entrypoint id ghcr.io/hrodrig/gghstats:<tag>`.

## Troubleshooting

Docker install, **nftables/iptables**, and **`DOCKER-FORWARD`** issues are the same class of problems as on any Compose host. See **[pgwd-selfhosted testing/platforms README](https://github.com/hrodrig/pgwd-selfhosted/blob/develop/testing/platforms/README.md#troubleshooting)** for detailed Arch/Linux notes.

If **`/api/v1/healthz`** fails but logs show **`listening`**, check **`gghstats_port`** matches the published port and that nothing else binds that port on the host.

If the container exits immediately, verify **`gghstats_github_token`** and **`gghstats_filter`** (`docker logs gghstats`).

## Relationship to gghstats (application repo)

| Repo | Validates |
|------|-----------|
| **gghstats** `testing/platforms/` | Native **`.deb`/`.rpm`/BSD tarball**, systemd/rc.d, `/etc/gghstats/gghstats.env` |
| **gghstats-selfhosted** (here) | **Docker Compose** + **Helm/kind** on Linux |

Run both before a release if you changed **packaging** and **deployment manifests**.

## Relationship to pgwd-selfhosted

- **pgwd-selfhosted** — Compose + Postgres on Linux VPS.
- **This repo** — gghstats Compose + GHCR image (`run/docker-compose/minimal/`).

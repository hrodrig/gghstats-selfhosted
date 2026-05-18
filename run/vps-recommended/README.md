# Recommended VPS baseline (optional, agnostic)

← [Back to `run/`](../README.md) · [Repository README](../../README.md)

> **Recommendations only.** Everything under `run/vps-recommended/` is a set of **optional suggestions and good practices**, not a supported service or guarantee. **You** choose whether to apply them on **your** VPS. **Your** responsibility covers **your** host, credentials, and choices (lockout from a wrong firewall rule you added, a leaked `.env`, skipping hardening). It does **not** excuse a **broken documented path** here: if you follow [Quick start](#quick-start) on a fresh Debian/Ubuntu system as described and the playbook or docs fail, that is a **maintainer** issue to fix — not “your problem” because we pointed you at steps that do not work.

**This directory does not install or configure gghstats.** It is an optional **operator checklist** you can apply to a fresh Linux VPS **before or after** you deploy the app — same host, any cloud, any provider.

**Docker Compose is only the most common example** in this repository (minimal, Traefik, observability). The same host practices apply equally if you run gghstats via **`docker run`**, **standalone binary**, **Kubernetes / Helm**, or another layout: secure the **OS and network first**, then follow the [run path](../README.md) that matches your install.

## What this is

| In scope | Out of scope |
|----------|----------------|
| Generic host hygiene (updates, firewall, Docker for Compose, optional SSH tighten) | gghstats containers, Traefik labels, `GGHSTATS_*` env |
| Debian / Ubuntu (`ansible_os_family == Debian`) | Windows, RHEL-only shops (adapt yourself) |
| Repeatable Ansible you own on **your** machine | A hosted “gghstats appliance” or support contract |

**Threat model (short):** if the VPS is compromised (weak SSH, open admin ports, stolen `.env` on disk), attackers get your **GitHub PAT**, **SQLite**, and **API token** — that is **host security**, not an HTTP header missing on the app. See [gghstats](https://github.com/hrodrig/gghstats) for application issues; use this tree for **your** server.

**Layout and accounts (recommended):**

- **Keep the git clone separate from runtime config.** Clone **[gghstats-selfhosted](https://github.com/hrodrig/gghstats-selfhosted)** under something like `/opt/src/gghstats-selfhosted` (or only on your laptop) and keep **SQLite**, **`.env`**, and **`.env.observability`** under a **different** directory (e.g. `/var/lib/gghstats-data/` or your home) — see [Persistent data and secrets](../../README.md#persistent-data-and-secrets). Do not store live secrets inside the repository tree; a leaked clone path should not equal a leaked PAT.
- **Use an SSH/Linux user name you already use** (`deploy`, your initials, a team account, etc.). We **do not** recommend creating a predictable OS user such as `gghstats` just because the app is called that — it adds another obvious username for password spraying. Prefer **SSH keys**, **`sudo`**, and (optionally) this playbook’s SSH tag over a shared password on a themed account.

## Layout

```text
run/vps-recommended/
├── README.md                 # this file
└── ansible/
    ├── playbook.yml          # tagged tasks
    ├── inventory.example.yml
    ├── group_vars/all.yml.example
    └── requirements.yml        # community.general (UFW)
```

## What is Ansible?

We assume you are comfortable with a **shell**, **SSH**, and basic **Linux** administration on your VPS. **Ansible** is the optional tool this tree uses to apply the same steps repeatably: you run commands from your **laptop** (or CI), Ansible connects over **SSH**, and a **playbook** (`playbook.yml`) describes what to change on the server (packages, firewall, optional `sshd` tweaks). You do **not** install an Ansible agent on the VPS — only Python/sudo on the target, which Debian and Ubuntu already provide.

Official documentation: **[Ansible Documentation](https://docs.ansible.com/)** · Getting started: **[Installation & first playbook](https://docs.ansible.com/ansible/latest/getting_started/index.html)**

## Prerequisites

- **Ansible** 2.14+ on your laptop or CI runner (`ansible --version`).
- **SSH key** access to the VPS as a user with **`sudo`** (see below on minimal Debian).
- Target host: **Debian 13+** or **Ubuntu 24.04+** (64-bit).

### Debian netinst: install `sudo` first

A **minimal** Debian installer image often creates your user **without** the `sudo` package (`sudo: command not found`). This playbook uses `become: true`, which expects `sudo` on the target.

On the VPS, as **root** (for example `su -` with the root password from install, or the Proxmox VM console):

```bash
apt update
apt install -y sudo
usermod -aG sudo YOUR_USER
```

Log out and SSH in again, then verify:

```bash
sudo -v
```

Ubuntu Server images usually include `sudo` already; Debian netinst is the common case where you need this step once.

### Ansible `become` and the sudo password

This playbook runs tasks with **`become: true`** (privilege escalation via `sudo`). If your user must type a password for `sudo`, Ansible stops with **`Missing sudo password`** unless you pass one.

**Option A — prompt each run (no server change):**

```bash
ansible-playbook -i inventory.yml playbook.yml --check --diff --tags baseline,firewall --ask-become-pass
```

(`-K` asks for the **sudo** password of `ansible_user` in `inventory.yml`.)

**Option B — passwordless sudo for that user (common in a lab VM):**

On the VPS, as **root**, after `YOUR_USER` is in the `sudo` group:

```bash
echo 'YOUR_USER ALL=(ALL) NOPASSWD:ALL' > /etc/sudoers.d/YOUR_USER
chmod 440 /etc/sudoers.d/YOUR_USER
visudo -cf /etc/sudoers.d/YOUR_USER
```

Expected: `parsed OK`. From your laptop:

```bash
ssh YOUR_USER@YOUR_VPS_HOST 'sudo -n true && echo OK'
```

Then run `ansible-playbook` **without** `--ask-become-pass`.

**Scope:** Option B is **your** choice on **your** VPS. It trades convenience for “anyone with that SSH key can sudo without a password.” Do not treat it as required for production; many operators prefer Option A or a tight `sudoers` rule instead of `NOPASSWD:ALL`.

Install the collection once:

```bash
cd run/vps-recommended/ansible
ansible-galaxy collection install -r requirements.yml
```

## Quick start

1. Copy and edit inventory:

   ```bash
   cp inventory.example.yml inventory.yml
   # Set ansible_host, ansible_user, ansible_ssh_private_key_file if needed
   ```

2. Copy and edit variables (ports, SSH hardening flags):

   ```bash
   cp group_vars/all.yml.example group_vars/all.yml
   ```

3. **Dry run** (no changes):

   ```bash
   ansible-playbook -i inventory.yml playbook.yml --check --diff --tags baseline,firewall
   ```

   On a **fresh** host, UFW rule tasks may show **`skipped`** in `--check` because `apt` does not actually install `ufw` yet (the playbook only configures UFW when `/usr/sbin/ufw` exists). That is expected — not a failure. Run step 4 once without `--check`, then `--check` can validate firewall tasks on later runs.

4. Apply baseline (packages + unattended upgrades + UFW + Fail2ban when enabled + Docker for Compose):

   ```bash
   ansible-playbook -i inventory.yml playbook.yml --tags baseline,firewall,docker
   ```

   With default vars, **Fail2ban** installs as part of tag **`baseline`** (`vps_install_fail2ban: true`). Set `vps_install_fail2ban: false` in `group_vars/all.yml` to skip it. Verify on the VPS: [Verify Fail2ban](#verify-fail2ban-on-the-vps).

   Installs **one stack** from [Docker’s official apt repository](https://docs.docker.com/engine/install/debian/): **`docker-ce`**, **`docker-ce-cli`**, **`containerd.io`**, **`docker-buildx-plugin`**, **`docker-compose-plugin`**, then enables **`docker.service`** via **systemd**.

   The playbook **removes conflicting distro packages** first (`docker.io`, **`docker-compose`**, etc.). Do **not** mix Debian’s `docker.io` with the separate `docker-compose` package — that is not the same as the Compose **plugin** and can confuse daemon vs CLI setup. Set **`vps_install_docker: false`** in `group_vars/all.yml` for binary-only or Helm paths.

   **Network:** the target host must reach `https://download.docker.com` for the GPG key and repository (your supply-chain choice; see Docker’s install docs).

   **Debian netinst:** ensure normal archive lines exist in `sources.list` (not only the install CD) so `apt` works, then run `--tags docker`.

   If you already installed **`docker.io`** during testing, the play removes it before installing **docker-ce**.

   After the play, **`ansible_user` must log out and SSH in again** (or run `newgrp docker`) before `docker compose` without sudo.

   **Verify Docker (anonymized lab example)** — after a successful `--tags docker` play, Ansible should report **`failed=0`** and tasks such as *Remove conflicting unofficial Docker packages*, *Install Docker Engine (CE)*, and *Verify docker compose v2 plugin* as **ok** or **changed**. Example recap (host name and IP are yours; shown generically):

   ```text
   PLAY RECAP ********************************************************************
   your-vps                 : ok=12   changed=6    unreachable=0    failed=0
   ```

   Open a **new** SSH session (group `docker` is applied at login), then on the VPS:

   ```bash
   docker compose version
   systemctl is-active docker
   docker run --rm hello-world
   ```

   Expected (trimmed; image digest and minor version strings vary):

   ```text
   deploy@your-vps:~$ docker compose version
   Docker Compose version v2.x.x

   deploy@your-vps:~$ systemctl is-active docker
   active

   deploy@your-vps:~$ docker run --rm hello-world
   Unable to find image 'hello-world:latest' locally
   latest: Pulling from library/hello-world
   ...
   Status: Downloaded newer image for hello-world:latest

   Hello from Docker!
   This message shows that your installation appears to be working correctly.
   ```

   On Debian **before** this playbook, `apt-cache search docker-compose` often lists only the **`docker-compose`** program (Compose v1), not **`docker-compose-plugin`**, and `dpkg` may show **`docker.io`** plus distro **`containerd`** — that mix is what the play replaces with **docker-ce** and **`docker compose`** (plugin). Do not install the standalone `docker-compose` apt package on top of `docker.io` if you want a single **systemd**-managed stack.

5. **Only when** you already log in with SSH keys and have a second session open, optional SSH hardening:

   ```bash
   ansible-playbook -i inventory.yml playbook.yml --tags ssh
   ```

## Tags

| Tag | Action |
|-----|--------|
| `baseline` | Useful packages, `unattended-upgrades` |
| `firewall` | UFW: deny incoming by default, allow `vps_allowed_tcp_ports` |
| `ssh` | `sshd` tweaks (off by default via vars — see `group_vars`) |
| `docker` | Official **docker-ce** + **docker-compose-plugin**, `docker.service` (systemd), `docker` group (`vps_install_docker`, default **true**) |
| `fail2ban` | Install and enable Fail2ban (`vps_install_fail2ban`, default **true**; also tagged `baseline` — verify `fail2ban-client status` after) |

Run baseline + firewall + Docker (typical before [Compose](../docker-compose/minimal/)):

```bash
ansible-playbook -i inventory.yml playbook.yml --tags baseline,firewall,docker
```

Host-only (no Docker — standalone binary or Kubernetes node prep):

```bash
ansible-playbook -i inventory.yml playbook.yml --tags baseline,firewall -e vps_install_docker=false
```

Without Fail2ban:

```bash
ansible-playbook -i inventory.yml playbook.yml --tags baseline,firewall,docker -e vps_install_fail2ban=false
```

## Verify Fail2ban (on the VPS)

Run on the target host after `--tags fail2ban` or `--tags baseline` (with `vps_install_fail2ban: true`). Jail names can differ by Debian/Ubuntu release; on **Debian 13 (Trixie)** in a lab test the only jail was **`sshd`**.

```bash
sudo systemctl status fail2ban --no-pager
sudo systemctl is-active fail2ban
sudo fail2ban-client status
sudo fail2ban-client status sshd
```

**Anonymized lab example** (fresh install, no bans yet):

```text
deploy@your-vps:~$ sudo systemctl is-active fail2ban
active

deploy@your-vps:~$ sudo fail2ban-client status
Status
|- Number of jail:     1
`- Jail list:  sshd

deploy@your-vps:~$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- Journal matches:  _SYSTEMD_UNIT=ssh.service + _COMM=sshd
`- Actions
   |- Currently banned: 0
   |- Total banned:     0
   `- Banned IP list:
```

If `sshd` is missing, list jails from `fail2ban-client status` and substitute the jail name in the commands below.

### Unban an IP

Replace `203.0.113.50` with the address shown under **Banned IP list** (example uses [RFC 5737 documentation space](https://datatracker.ietf.org/doc/html/rfc5737)).

```bash
# One IP, one jail (typical for SSH)
sudo fail2ban-client set sshd unbanip 203.0.113.50

# Same IP, all jails where it is banned (Fail2ban 0.10+)
sudo fail2ban-client unban 203.0.113.50

# All IPs, all jails (use with care)
sudo fail2ban-client unban --all
```

Confirm:

```bash
sudo fail2ban-client status sshd
```

**Caution:** testing a ban by failing SSH logins from your **only** admin IP can lock you out until you fix it from the provider console or another IP. Prefer a second session, a test IP, or Proxmox/serial console before deliberate ban tests.

## HTTP security scanners (CSP, Referrer-Policy, …)

Tools such as Nikto or website scanners report **missing response headers**. Those are usually configured on **your reverse proxy** (for example Traefik middleware in [`run/docker-compose/traefik/`](../docker-compose/traefik/)) or in your CDN — **not** by this playbook. This baseline reduces **host** risk; it does not make a external scanner “green” by itself.

## After the host is sane

Pick a gghstats path from the [repository README](../../README.md#pick-a-path). Examples in the root README often use **Compose** (`minimal`, Traefik, observability); extrapolate the same ideas to any mode:

| Install style | Host baseline (this tree) | App secrets / data |
|---------------|---------------------------|---------------------|
| [Compose minimal](../docker-compose/minimal/) | UFW, SSH, updates, **Docker** (`--tags docker`) | **`${GGHSTATS_HOST_DATA}/.env`**, bind mount `/data` |
| [Compose Traefik](../docker-compose/traefik/) | Same + ports 80/443 | Same |
| [`docker run`](../docker/) | Same | `-v` host dir + env file or `-e` |
| [Standalone binary](../standalone/) | Same | `GGHSTATS_DB`, token env on the host |
| [Helm / Kubernetes](../kubernetes/helm/) | Same on **nodes**; cluster firewall / NetworkPolicy are **additional** | Kubernetes Secrets, PVC for SQLite |

Keep secrets **out of the git clone** (Compose env files on the host, K8s Secrets, etc.).

## Disclaimer

These documents and the Ansible playbook express **recommendations and good practices only**. They are provided **as-is**, without warranty.

**Operator responsibility (your VPS, your choices):** analyze each step, test in your environment, and apply or skip as you see fit. You are responsible for incidents that come from **your** configuration — weak SSH, secrets on disk, opening the wrong ports, running as root in production, ignoring backups. The maintainers do not run your VPS for you.

**Maintainer responsibility (the documented path):** the [Quick start](#quick-start) flow is meant to be followed by a self-hoster the same way we validate it (fresh Debian/Ubuntu, `sudo`, inventory, `--check`, then apply). If that path fails because the playbook or instructions are wrong (for example `--check` errors on a clean netinst, missing `sudo` steps not documented, UFW tasks that always fail), **report it** — that is not covered by “host choices are your problem.” Fix the docs/playbook; do not blame the operator for following them.

**Operational caution:** wrong SSH or firewall rules can **lock you out**. Use `ansible-playbook --check`, keep an out-of-band console (provider web UI), and open a second SSH session before `--tags ssh`.

**[↑ Back to `run/`](../README.md)**

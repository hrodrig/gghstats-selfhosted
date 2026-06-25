# gghstats-selfhosted

[![Version](https://img.shields.io/badge/version-0.1.43-blue)](https://github.com/hrodrig/gghstats-selfhosted/releases)
[![Release](https://img.shields.io/github/v/release/hrodrig/gghstats-selfhosted?label=release)](https://github.com/hrodrig/gghstats-selfhosted/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![App image on GHCR](https://img.shields.io/badge/image-ghcr.io%2Fhrodrig%2Fgghstats-2496ED?logo=github)](https://github.com/hrodrig/gghstats/pkgs/container/gghstats)
[![gghstats app](https://img.shields.io/badge/app-hrodrig%2Fgghstats-181717?logo=github)](https://github.com/hrodrig/gghstats)
[![gghstats clones](https://gghstats.hermesrodriguez.com/api/v1/badge/hrodrig/gghstats-selfhosted?metric=clones)](https://gghstats.hermesrodriguez.com/hrodrig/gghstats-selfhosted)

![gghstats-selfhosted — Docker, Compose, Helm, run/](assets/gghstats-selfhosted-hero.png)

Deployment manifests for **[gghstats](https://github.com/hrodrig/gghstats)** — Compose, Helm, `docker run`, optional observability. **App source and releases:** [github.com/hrodrig/gghstats](https://github.com/hrodrig/gghstats).

**Demo:** [gghstats.hermesrodriguez.com](https://gghstats.hermesrodriguez.com) · Observability example: [gghstats-obs.hermesrodriguez.com](https://gghstats-obs.hermesrodriguez.com)

**Policies:** [Community and policies](#community-and-policies), [community standards](#community-standards) — changelog, contributing, security, code of conduct, agent guidelines.

---

## Table of contents

- [Pick a path](#pick-a-path)
- [Standalone binary](#standalone-binary)
- [Docker single container](#docker-single-container)
- [Docker Compose minimal](#docker-compose-minimal)
- [Docker Compose Traefik HTTPS](#docker-compose-traefik-https)
- [Observability optional](#observability-optional)
- [Authelia SSO (advanced)](#authelia-sso-advanced-optional)
- [Kubernetes Helm](#kubernetes-helm)
- [Recommended VPS baseline (optional)](#recommended-vps-baseline-optional)
- [Persistent data and secrets](#persistent-data-and-secrets)
- [Custom UI theme (optional)](#custom-ui-theme-optional)
- [Repository layout](#repository-layout)
- [Versioning](#versioning)
- [Validate gghstats image upgrade (Compose / Traefik)](#validate-gghstats-image-upgrade-compose--traefik)
- [Community and policies](#community-and-policies)
- [Community standards](#community-standards)
- [License](#license)

---

## Pick a path

| You want… | Section |
|-----------|---------|
| **Binary only** (no Docker) | [Standalone binary](#standalone-binary) — Linux: [systemd, `.deb`/`.rpm`, config](run/standalone/linux/README.md) |
| **Linux `.deb` / `.rpm` + systemd** | [run/standalone/linux/README.md](run/standalone/linux/README.md) |
| **Single container** (`docker run`) | [Docker single container](#docker-single-container) |
| **Compose, one service** (quick VPS) | [Docker Compose minimal](#docker-compose-minimal) |
| **HTTPS + domain** (Traefik + Let’s Encrypt) | [Docker Compose Traefik HTTPS](#docker-compose-traefik-https) |
| **Prometheus / Grafana / Loki** (after Traefik) | [Observability optional](#observability-optional) |
| **Authelia SSO + 2FA** (advanced, after Traefik) | [Authelia SSO](#authelia-sso-advanced-optional) |
| **Kubernetes** | [Kubernetes Helm](#kubernetes-helm) |
| **Harden a fresh VPS** (optional, agnostic Ansible; recommendations only) | [Recommended VPS baseline](#recommended-vps-baseline-optional) |
| **Simpler or custom dashboard look** (CSS overlay) | [Custom UI theme (optional)](#custom-ui-theme-optional) |

Shared env template for Compose: copy **[`run/common/.env.example`](run/common/.env.example)** to **`${GGHSTATS_HOST_DATA}/.env`**, set **`GGHSTATS_HOST_DATA`** inside that file, and pass **`--env-file "${GGHSTATS_HOST_DATA}/.env"`** to Compose. Deeper walkthroughs: **[`run/README.md`](run/README.md)**.

**[↑ Contents](#table-of-contents)**

---

## Standalone binary

**Goal:** run the app without Docker — tarball, **`.deb`**, **`.rpm`**, or **systemd** on Linux.

**All implementation detail** (env file paths, `systemctl`, package install, filters on a server) is in **[`run/standalone/`](run/standalone/README.md)** — start with **[Linux](run/standalone/linux/README.md)** for packages and systemd.

**Smoke test** (UI only) — minimal path to try the dashboard; **not** production. Same commands as [gghstats Quick start](https://github.com/hrodrig/gghstats#quick-start):

```bash
curl -fsSL https://raw.githubusercontent.com/hrodrig/gghstats/main/scripts/install.sh | sh
export GGHSTATS_GITHUB_TOKEN=ghp_xxx
gghstats run --open
```

**`run`** is an alias for **`serve`**; **`--open`** opens the browser when the dashboard is ready. Background sync starts automatically. Open **http://localhost:8080** if you did not use **`--open`**. Other install options (Homebrew, `.deb`, tarball): [gghstats Install](https://github.com/hrodrig/gghstats#install).

**macOS / Windows:** [run/standalone/macos](run/standalone/macos/README.md) · [run/standalone/windows](run/standalone/windows/README.md)

**[↑ Contents](#table-of-contents)**

---

## Docker single container

**Goal:** one container, no Compose file.

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"

docker run -d \
  -e GGHSTATS_GITHUB_TOKEN=ghp_xxx \
  -e GGHSTATS_FILTER="your-github-user/*" \
  -p 8080:8080 \
  -v "${GGHSTATS_HOST_DATA}:/data" \
  --name gghstats \
  ghcr.io/hrodrig/gghstats:v0.7.11
```

Use an image tag that exists on GHCR ([releases](https://github.com/hrodrig/gghstats/releases)); match **`GGHSTATS_VERSION`** in [`run/common/.env.example`](run/common/.env.example).

**Check:** `curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8080/` (expect `200` or `3xx`).

**Remove:**

```bash
docker stop gghstats && docker rm gghstats
```

**More:** [run/docker/README.md](run/docker/README.md)

**[↑ Contents](#table-of-contents)**

---

## Docker Compose minimal

**Goal:** quick stack from this repo (single service, GHCR image).

```bash
git clone https://github.com/hrodrig/gghstats-selfhosted.git
cd gghstats-selfhosted
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"
cp run/common/.env.example "${GGHSTATS_HOST_DATA}/.env"
# Edit "${GGHSTATS_HOST_DATA}/.env": GGHSTATS_GITHUB_TOKEN, GGHSTATS_VERSION, and GGHSTATS_HOST_DATA (same path as above)

docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/minimal/docker-compose.yml up -d
```

**Check:** `curl -sS -o /dev/null -w '%{http_code}\n' http://127.0.0.1:8080/` (or your `GGHSTATS_PORT`).

**Remove:**

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/minimal/docker-compose.yml down
```

**More:** [run/docker-compose/minimal/README.md](run/docker-compose/minimal/README.md)

**[↑ Contents](#table-of-contents)**

---

## Docker Compose Traefik HTTPS

**Goal:** production-style TLS on your domain (ports **80** / **443**).

**Prerequisites:** DNS **A/AAAA** for `GGHSTATS_HOSTNAME` → this host; **80** and **443** reachable.

```bash
git clone https://github.com/hrodrig/gghstats-selfhosted.git
cd gghstats-selfhosted
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"
cp run/common/.env.example "${GGHSTATS_HOST_DATA}/.env"
# Edit "${GGHSTATS_HOST_DATA}/.env": GGHSTATS_GITHUB_TOKEN, GGHSTATS_HOSTNAME, ACME_EMAIL, GGS_UID, GGS_GID,
# GGHSTATS_VERSION, and GGHSTATS_HOST_DATA (same absolute path as above — SQLite lives next to this file)

docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/traefik/docker-compose.yml up -d
```

**Check:** `curl -sS -o /dev/null -w '%{http_code}\n' https://your-hostname/` after DNS and TLS succeed.

**Remove:**

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -f run/docker-compose/traefik/docker-compose.yml down
```

**More:** [run/docker-compose/traefik/README.md](run/docker-compose/traefik/README.md)

> **Rate limiting (defence in depth):** gghstats ≥ 0.7.5 applies built-in per-IP rate limiting (120 req/min, burst 20). The Traefik compose keeps its own rate-limit middleware at the edge — together they provide layered protection. If you tune the in-app limits, you can relax the Traefik layer. See [gghstats README — Rate limiting](https://github.com/hrodrig/gghstats/blob/main/README.md#rate-limiting).
>
> **IP whitelist (≥ 0.7.6):** restrict access by IP/CIDR with `GGHSTATS_WHITELIST` and `GGHSTATS_WHITELIST_PATHS`. Non-matching IPs receive 403. Scope to specific paths (e.g. `/api/`) while keeping the dashboard public. See [gghstats README — IP whitelist](https://github.com/hrodrig/gghstats/blob/main/README.md#ip-whitelist).
>
> **Remote sync (≥ 0.7.10):** when **`GGHSTATS_API_TOKEN`** is set, dashboard **Sync all** sends `x-api-token` and bypasses the IP whitelist on protected paths — you can keep `/api/` whitelisted without opening it to the whole internet.
>
> **`/metrics` is public by default.** The Traefik compose excludes it from the public router (`!PathPrefix`). Prometheus scrapes internally via `http://gghstats:8080/metrics` on the Docker network. If you use **minimal Compose** or **`docker run`**, protect `/metrics` with a firewall or set `GGHSTATS_METRICS=false`.

**[↑ Contents](#table-of-contents)**

---

## Observability optional

**Goal:** Prometheus, Grafana, Loki, etc. **Requires** the Traefik stack above so network **`gghstats_edge`** exists. Use the **same** **`GGHSTATS_HOST_DATA`** as your main **`${GGHSTATS_HOST_DATA}/.env`** (SQLite and secrets in one host directory).

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
mkdir -p "$GGHSTATS_HOST_DATA"
cp run/docker-compose/observability/observability.env.example "${GGHSTATS_HOST_DATA}/.env.observability"
# Edit "${GGHSTATS_HOST_DATA}/.env.observability" — set GRAFANA_ADMIN_PASSWORD at minimum (must match GGHSTATS_HOST_DATA used for Traefik / main .env)
```

**Expose Grafana on HTTPS via Traefik (public hostname)** — use this if you want Grafana on the internet with the **same** Traefik / Let’s Encrypt as gghstats (recommended once DNS is ready):

1. In **`"${GGHSTATS_HOST_DATA}/.env.observability"`**, set a dedicated FQDN and matching root URL (must match what users open in the browser):

   ```bash
   GRAFANA_HOSTNAME=gghstats-obs.example.com
   GRAFANA_ROOT_URL=https://gghstats-obs.example.com
   ```

2. **DNS:** point **`GRAFANA_HOSTNAME`** to this host (A/AAAA or CNAME), same idea as **`GGHSTATS_HOSTNAME`** for the main app.

3. Start the stack with **both** Compose files (the second file adds Traefik **labels** only; it does not add another Traefik container). Use **both** `-f` lines on every `up` / `pull` / `down` that recreates Grafana, or HTTPS routing breaks until you fix it.

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs \
  -f run/docker-compose/observability/docker-compose.observability.yml \
  -f run/docker-compose/observability/docker-compose.observability.traefik.yml \
  up -d
```

**Local / LAN only (no Traefik route for Grafana)** — Grafana on **`http://localhost:${GRAFANA_PORT:-3000}`**; omit **`docker-compose.observability.traefik.yml`**:

```bash
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs \
  -f run/docker-compose/observability/docker-compose.observability.yml up -d
```

**Check / troubleshoot / SSH tunnel:** **[run/docker-compose/observability/README.md](run/docker-compose/observability/README.md)** (curl checks, `down -v`).

**Remove (containers + stack volumes):** use the **same** `-f` list you used for `up`. Examples:

```bash
# If you started with Traefik overlay (two files), remove with two files:
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs \
  -f run/docker-compose/observability/docker-compose.observability.yml \
  -f run/docker-compose/observability/docker-compose.observability.traefik.yml \
  down -v

# If you started with only the base file:
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env.observability" -p gghstats-obs \
  -f run/docker-compose/observability/docker-compose.observability.yml down -v
```

**[↑ Contents](#table-of-contents)**

---

## Kubernetes Helm

**Recommended:** install from the **Helm repository** on **GitHub Pages** ([**`index.yaml`**](https://hrodrig.github.io/gghstats-selfhosted/index.yaml); chart packages are attached to [GitHub Releases](https://github.com/hrodrig/gghstats-selfhosted/releases) as **`gghstats-<version>.tgz`**).

**GitHub Pages:** The [Pages URL](https://hrodrig.github.io/gghstats-selfhosted/) serves **`index.yaml`** for Helm and includes a short **HTML landing** for humans. **`helm repo add`** only needs the HTTPS base URL — you do not have to open the site in a browser.

**Naming (this repo vs the chart):** This GitHub repository is **`gghstats-selfhosted`** (deployment manifests only). The Helm chart lives under **`run/kubernetes/helm/gghstats/`** — the final directory name **`gghstats`** is the **chart name** (see `name:` in **`Chart.yaml`**), the same name as the **application** the chart deploys. It is **not** the repository name. Published chart packages and chart-releaser GitHub Releases use the pattern **`gghstats-<chart-version>`** (e.g. **`gghstats-0.1.7.tgz`**); **Git tags** for this repo use **`v<semver>`** (e.g. **`v0.1.8`**) per **`VERSION`**.

```bash
helm repo add gghstats https://hrodrig.github.io/gghstats-selfhosted
helm repo update
helm install gghstats gghstats/gghstats -n gghstats --create-namespace -f my-values.yaml
```

**GitHub token (recommended):** do **not** put the PAT in **`my-values.yaml`**. Create a secret that matches the chart defaults (**`secretName`:** `gghstats-secret`, **`secretKey`:** `github-token` — see **`githubToken`** in [`values.yaml`](run/kubernetes/helm/gghstats/values.yaml)). Replace **`YOUR_GITHUB_TOKEN`** with your [classic or fine-grained PAT](https://github.com/hrodrig/gghstats/blob/main/README.md) (repo scope as needed):

```bash
kubectl create namespace gghstats
kubectl create secret generic gghstats-secret \
  -n gghstats \
  --from-literal=github-token=YOUR_GITHUB_TOKEN
```

Then run **`helm install`** (omit **`--create-namespace`** if the namespace already exists). Keep **`githubToken.value:`** empty in **`my-values.yaml`** so Helm does not embed the token in a release manifest.

Use **`helm show values gghstats/gghstats`** (after `helm repo update`) or the copy in the repo browser to build **`my-values.yaml`** (image tag, persistence, resources, etc.). Pick any namespace with **`-n`** (here **`gghstats`**); if you use another name, use the same namespace in **`kubectl`** and **`helm`** and adjust **`my-values.yaml`** if you reference the secret explicitly.

If **`helm repo add`** fails (network, Pages outage, or first minutes after a new release), try again later or install **from this repository** below.

**From this repository (sources, templates, contributing):** the chart under **`run/kubernetes/helm/gghstats/`** is the same chart; clone it to inspect YAML, open issues, or install without the published repo:

```bash
git clone https://github.com/hrodrig/gghstats-selfhosted.git
cd gghstats-selfhosted
helm install gghstats ./run/kubernetes/helm/gghstats -n gghstats --create-namespace -f my-values.yaml
```

See **[`values.yaml`](run/kubernetes/helm/gghstats/values.yaml)** in-tree for defaults.

**Check:** `kubectl get pods -n gghstats -l app.kubernetes.io/name=gghstats` and your Ingress/Service URL.

**Remove:**

```bash
helm uninstall gghstats -n gghstats
```

**More:** [run/kubernetes/helm/gghstats/README.md](run/kubernetes/helm/gghstats/README.md) · [run/kubernetes/manifests](run/kubernetes/manifests/README.md)

**[↑ Contents](#table-of-contents)**

---

## Recommended VPS baseline (optional)

**Goal:** generic **host** hygiene on a Debian/Ubuntu VPS — **not** gghstats containers or Traefik labels. The playbook can optionally install **Docker Engine (CE)** for Compose; skip that tag for binary-only or Helm nodes.

If the attack vector is a **misconfigured or compromised VPS**, HTTP headers on the app will not help; operators secure **SSH**, **firewall**, and **automatic security updates** themselves. This repo ships an **optional, agnostic** Ansible playbook you run from your laptop against your server inventory.

**Operator responsibility:** content under [`run/vps-recommended/`](run/vps-recommended/) is **recommendations only** — not a managed service. You must analyze, validate, and choose what to apply on **your** VPS; outcomes are **your** responsibility. See the [full disclaimer](run/vps-recommended/README.md#disclaimer) in that README.

**Note:** step-by-step guides below often use **Docker Compose** because it is the usual path on a VPS; the baseline here is **not Compose-specific** — the same practices apply to **`docker run`**, a **standalone binary**, or **Helm on Kubernetes** (plus cluster-level controls where relevant).

| Topic | Where |
|-------|--------|
| Philosophy, tags, dry-run | [`run/vps-recommended/README.md`](run/vps-recommended/README.md) |
| Playbook | [`run/vps-recommended/ansible/playbook.yml`](run/vps-recommended/ansible/playbook.yml) |

Typical order: **(1)** VPS baseline → **(2)** pick any [install path](#pick-a-path) (Compose is the common example; others are equivalent from a host-security view) → **(3)** store secrets and SQLite outside the clone ([persistent data](#persistent-data-and-secrets) — Compose uses **`${GGHSTATS_HOST_DATA}/.env`**; Helm uses Secrets/PVC; binary uses host paths you choose).

**[↑ Contents](#table-of-contents)**

---

## Authelia SSO (advanced, optional)

**Goal:** Single Sign-On with 2FA (TOTP/WebAuthn) in front of gghstats. Protects `/api/` and `/h2h` — dashboard stays public.

**Prerequisites:** [Traefik stack](#docker-compose-traefik-https) running on `gghstats_edge`.

**[Setup guide →](run/docker-compose/authelia/README.md)**

---

## Persistent data and secrets

*Recommended on servers:* colocate SQLite and env files outside the clone (see below).

Keep **SQLite**, **`${GGHSTATS_HOST_DATA}/.env`**, and **`${GGHSTATS_HOST_DATA}/.env.observability`** in one host directory (e.g. `/home/gghstats/gghstats-data/`). Set **`GGHSTATS_HOST_DATA`** inside the main **`.env`** to that absolute path. Run Compose from the clone root with **`--env-file "${GGHSTATS_HOST_DATA}/.env"`** for the app stacks and **`--env-file "${GGHSTATS_HOST_DATA}/.env.observability"`** for observability (`-p gghstats-obs`). See [`run/common/.env.example`](run/common/.env.example) and [`run/docker-compose/observability/observability.env.example`](run/docker-compose/observability/observability.env.example). Optional helper: **[`run/scripts/compose-stack.sh`](run/scripts/compose-stack.sh)** — e.g. **`./run/scripts/compose-stack.sh full restart`** for Traefik + gghstats + observability without remembering compose order (`--help` for **`prod`** vs **`full`**).

**[↑ Contents](#table-of-contents)**

---

## Custom UI theme (optional)

**Requires** a [gghstats](https://github.com/hrodrig/gghstats) image **0.2.0** or newer (this repo’s Compose defaults use **`v0.7.11`**). The app serves an extra stylesheet at **`GET /theme/custom.css`** when **`GGHSTATS_CUSTOM_CSS`** points at a **regular `.css` file readable inside the container**.

### Where the theme file must live (bind mount vs PVC)

The path in **`GGHSTATS_CUSTOM_CSS`** / **`env.customCss`** is always **inside the container**. **Only the tree mounted at `/data`** is the stable, writable place operators should use for SQLite **and** a custom CSS file in our manifests.

**Docker Compose (minimal or Traefik)**  
Each stack bind-mounts the host directory **`${GGHSTATS_HOST_DATA}`** (or the repo’s `data/` fallback when unset) to **`/data`** in the container. On the host, put **`custom-theme.css`** next to your database directory contents — e.g. **`${GGHSTATS_HOST_DATA}/custom-theme.css`** — so it appears as **`/data/custom-theme.css`** in the container. Set **`GGHSTATS_CUSTOM_CSS=/data/custom-theme.css`** in **`${GGHSTATS_HOST_DATA}/.env`**. You do **not** need an extra volume line for the theme if it lives under that same host path.

**`docker run` (single container)**  
Mount a host directory the same way: **`-v /path/on/host:/data`**, store the **`.css`** file under **`/path/on/host/`**, then set **`GGHSTATS_CUSTOM_CSS=/data/your-theme.css`** (see [`run/docker/README.md`](run/docker/README.md)).

**Helm / Kubernetes**  
When **`persistence.enabled`** is **`true`**, the chart mounts a **PVC** at **`/data`** (see **`templates/deployment.yaml`** and **`values.yaml`** → **`persistence`**). **`env.customCss`** must be a path **on that PVC**, e.g. **`/data/custom-theme.css`**, not somewhere under the read-only container root (the chart uses **`readOnlyRootFilesystem: true`**). The SQLite file from **`env.dbPath`** is also under **`/data`**.  
If **`persistence.enabled`** is **`false`**, **`/data`** is still a writable **`emptyDir`**, but anything you put there (including a theme file) is **lost** when the Pod is deleted unless you repopulate it.  
After install, common options are **`kubectl cp`** a file into the running pod’s **`/data/`** (fix ownership/read bits for UID **1000** if your storage driver requires it), or your own **Job** / **initContainer** / GitOps pattern to populate **`/data`**. The chart does **not** bundle theme files; copy from upstream **[`contrib/themes`](https://github.com/hrodrig/gghstats/tree/main/contrib/themes)** or supply your own.

**Compose / Traefik or minimal (steps)**

1. Pin the image: set **`GGHSTATS_VERSION=v0.7.11`** in **`${GGHSTATS_HOST_DATA}/.env`** (see [`run/common/.env.example`](run/common/.env.example)).
2. Copy a starter from **[`gghstats` `contrib/themes/`](https://github.com/hrodrig/gghstats/tree/main/contrib/themes)** (or write your own) into the **host directory** that is bind-mounted to **`/data`** (same as [Persistent data and secrets](#persistent-data-and-secrets)), e.g. **`${GGHSTATS_HOST_DATA}/custom-theme.css`**.
3. Set **`GGHSTATS_CUSTOM_CSS=/data/custom-theme.css`** in that **`.env`**.
4. Recreate the app container so env and mounts apply: **`docker compose … up -d`** (not **`restart`** alone if you also changed **`GGHSTATS_VERSION`** — see [Versioning](#versioning)).

**Helm (values)**

Set **`env.customCss`** to a path **under `/data`** (e.g. **`/data/custom-theme.css`**) and ensure that file exists on the **PVC** as described above. Leave **`env.customCss`** empty to keep the stock neo-brutalist UI.

**Upstream reference:** [gghstats README — Custom UI theme (optional)](https://github.com/hrodrig/gghstats/blob/main/README.md#custom-ui-theme-optional).

**[↑ Contents](#table-of-contents)**

---

## Repository layout

```text
run/
├── vps-recommended/             # Optional agnostic VPS Ansible (not gghstats install)
├── common/.env.example          # Shared vars for Compose + image tag
├── scripts/                     # compose-stack.sh (docker compose helper)
├── standalone/{linux,macos,windows}/
├── docker/                      # docker run
├── docker-compose/
│   ├── minimal/
│   ├── traefik/
│   └── observability/
└── kubernetes/
    ├── helm/gghstats/           # Helm chart named "gghstats" (app); not the repo name
    └── manifests/
testing/
├── platforms/                   # Ansible: minimal Compose on real VPS (make test-compose-platforms)
├── kind/                        # kind + Helm smoke test docs
└── scripts/                     # test-helm-kind.sh
Makefile                         # release-check, test-compose-platforms, test-helm-kind
```

Maintainers: **`make release-check`** before tagging; optional **`testing/platforms`** and **`make test-helm-kind`** — see **[CONTRIBUTING.md](CONTRIBUTING.md)**.

**[↑ Contents](#table-of-contents)**

---

## Versioning

- **[`VERSION`](VERSION)** — semver of **this repository** (Compose, docs, `run/`, etc.). When you change it, align the **Version** badge in this README and (if you keep a release entry) **CHANGELOG.md**; on **`main`**, tag with **`v<semver>`** (e.g. `v0.1.12`). This number is **not** tied to the Helm chart on every bump.
- **Helm chart (`run/kubernetes/helm/gghstats/Chart.yaml` → `version:`)** — semver of the **chart package** published to [GitHub Pages](https://hrodrig.github.io/gghstats-selfhosted/index.yaml) / [Releases](https://github.com/hrodrig/gghstats-selfhosted/releases). Bump **`version:`** when the chart itself changes (templates, `values`, etc.). It may **lag** behind **`VERSION`** (e.g. repo `0.2.0`, chart `0.1.5` until you edit the chart). [chart-releaser](https://github.com/helm/chart-releaser) may skip publishing if **`run/kubernetes/helm/`** did not change — expected for docs-only repo releases.
- **`Chart.yaml` → `appVersion`** — **gghstats** application / image line; align with [gghstats releases](https://github.com/hrodrig/gghstats/releases) when you bump the deployed image story.
- **`GGHSTATS_VERSION`** in **`${GGHSTATS_HOST_DATA}/.env`** (or the env file you pass to Compose) — **container image** tag on GHCR ([gghstats releases](https://github.com/hrodrig/gghstats/releases)), not the same as **`VERSION`**.
- **Optional (gghstats ≥ 0.6.0):** **`GGHSTATS_DEFAULT_LOCALE`** and **`GGHSTATS_ENABLED_LOCALES`** for dashboard UI languages (API/CLI stay English). See [gghstats — Web UI languages (i18n)](https://github.com/hrodrig/gghstats/blob/main/README.md#web-ui-languages-i18n) and [`run/common/.env.example`](run/common/.env.example).

**Upgrading the app image:** (1) Set **`GGHSTATS_VERSION`** in **`${GGHSTATS_HOST_DATA}/.env`**. (2) **Pull** the image from GHCR (so the new tag exists locally). (3) Run **`up -d`** so Compose **recreates** the service with that tag — e.g. **`./run/scripts/compose-stack.sh traefik pull`** then **`… traefik up -d`**, or **`… traefik up -d --pull always`**. Optionally **`traefik down`** before pull/up if you want everything stopped first. **`docker compose restart`** / **`compose-stack.sh … restart`** only restart the **existing** container — they **do not** apply a new image tag. See **[`run/common/.env.example`](run/common/.env.example)**.

### Validate gghstats image upgrade (Compose / Traefik)

Use this checklist from the **repository clone root** after editing **`GGHSTATS_VERSION`** (Traefik + **gghstats** stack; same idea for **minimal** with **`minimal`** instead of **`traefik`** in the commands below).

1. **`GGHSTATS_HOST_DATA`** points at the directory that contains your **`.env`** (same as for normal Compose).
2. Confirm the tag in the env file:
   ```bash
   grep GGHSTATS_VERSION "${GGHSTATS_HOST_DATA}/.env"
   ```
3. Confirm Compose resolves the expected **image** line (no need to start containers):
   ```bash
   docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" \
     -f run/docker-compose/traefik/docker-compose.yml config \
     | grep -E 'image:|gghstats'
   ```
   You should see **`ghcr.io/hrodrig/gghstats:<your-tag>`** (e.g. **`v0.7.11`**).
4. **Pull** and **recreate** the service (do not rely on **`restart`** alone):
   ```bash
   ./run/scripts/compose-stack.sh traefik pull
   ./run/scripts/compose-stack.sh traefik up -d
   ```
   Or one step:
   ```bash
   ./run/scripts/compose-stack.sh traefik up -d --pull always
   ```
5. Confirm the **running** container uses that image:
   ```bash
   docker ps --format 'table {{.Names}}\t{{.Image}}' | grep gghstats
   ```
6. **Smoke check — UI:** open **`GGHSTATS_HOSTNAME`** in the browser (HTTPS if Traefik + ACME). The **gghstats** web UI shows the app version in the sidebar (must match the release you deployed).

**Optional — observability stack:** if you run Prometheus / Grafana / Loki on the same host, after the Traefik stack is healthy run **`./run/scripts/compose-stack.sh --traefik observability ps`** and open your Grafana URL (e.g. **`GF_SERVER_ROOT_URL`** / `GRAFANA_HOSTNAME`) to confirm dashboards load. Observability images are separate from **gghstats**; they only need a full cycle if *you* change those compose images.

**[↑ Contents](#table-of-contents)**

---

## Community and policies

| Document | Purpose |
|----------|---------|
| **[CHANGELOG.md](CHANGELOG.md)** | Release history and notable changes to **this** repository (manifests, docs, layout). |
| **[CONTRIBUTING.md](CONTRIBUTING.md)** | How to open issues/PRs, branch policy (`develop` → `main`), and checks before submitting. |
| **[CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md)** | Community standards (Contributor Covenant). |
| **[SECURITY.md](SECURITY.md)** | How to report security vulnerabilities responsibly. |
| **[AGENTS.md](AGENTS.md)** | Guidelines for AI coding agents (Cursor, etc.) working in this repo. |

**Application** issues (bugs, features in the Go app or UI) belong in **[gghstats](https://github.com/hrodrig/gghstats)** — not here.

**[↑ Contents](#table-of-contents)**

---

## Community standards

- License: [`LICENSE`](LICENSE)
- Contributing: [`CONTRIBUTING.md`](CONTRIBUTING.md)
- Code of conduct: [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md)
- Security policy: [`SECURITY.md`](SECURITY.md)
- Changelog: [`CHANGELOG.md`](CHANGELOG.md)
- Agent guidelines: [`AGENTS.md`](AGENTS.md)

Thanks for self-hosting **[gghstats](https://github.com/hrodrig/gghstats)** with these manifests. We would love to hear how **easy or difficult** it was to run **gghstats** self-hosted (Compose, Helm, `docker run`, observability, or anything in [`run/`](run/)). Share feedback in **[GitHub Issues](https://github.com/hrodrig/gghstats-selfhosted/issues)** or, if enabled for this repository, **Discussions**.

**[↑ Contents](#table-of-contents)**

---

## License

MIT — see [LICENSE](LICENSE).

**[↑ Contents](#table-of-contents)**

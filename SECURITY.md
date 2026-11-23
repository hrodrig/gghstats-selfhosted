# Security Policy

## Supported Versions

We support the **latest release** and the active development branch with
security updates. We use [semantic versioning](https://semver.org/)
(MAJOR.MINOR.PATCH).

| Version | Supported |
| ------- | --------- |
| Latest release | :white_check_mark: |
| Older releases | :x: |

When a vulnerability is fixed, we release a new patch version. Please upgrade
to the latest release to receive security fixes.

## Reporting a Vulnerability

**Do not open a public issue** for security vulnerabilities.

- **Preferred:** Use [GitHub Security Advisories (gghstats-selfhosted)](https://github.com/hrodrig/gghstats-selfhosted/security/advisories/new) for issues in this repository (Compose, Helm, env templates, docs, deployment layout).
- **Application (binary / `ghcr.io` image):** report via [gghstats Security Advisories](https://github.com/hrodrig/gghstats/security/advisories/new) when the flaw is in the app itself, not the manifests here.
- **Alternative:** Contact the maintainer via [github.com/hrodrig](https://github.com/hrodrig) with:
  - clear description
  - impact
  - steps to reproduce

## What to expect

- We acknowledge your report as soon as possible.
- We investigate and work on a fix.
- For accepted reports, we coordinate disclosure and credit (unless you prefer anonymity).

## Operator note: CVE-2026-98432 (Linux MPTCP / Go listeners)

**Primary fix:** patch the **Linux kernel** on every host and Kubernetes node that runs long-lived TCP listeners (Compose VM, bare-metal systemd, cluster workers). The CVE is a kernel IPv4 TCP use-after-free demonstrated via an **MPTCP listener** path — see [NVD CVE-2026-98432](https://nvd.nist.gov/vuln/detail/CVE-2026-98432) and the [Go Security Team announce](https://groups.google.com/g/golang-announce/c/PCoQcdxoScw).

Go **1.24+** enables Multipath TCP on **listen** sockets by default (`GODEBUG multipathtcp=2`). That is the precondition for the public PoC path; it is **not** a bug in gghstats itself.

**Defense in depth (fragile alone):**

| Layer | What |
|-------|------|
| Kernel | Patched hosts/nodes — **required** |
| App image **≥ v1.6.9** | `godebug multipathtcp=0` in `go.mod` + `SetMultipathTCP(false)` on the dashboard listener ([gghstats](https://github.com/hrodrig/gghstats)) |
| Env / unit | `GODEBUG=multipathtcp=0` in Compose, Helm, and systemd examples in this repo |

App/env mitigations only cover **this** process. **One forgotten MPTCP listener** from another Go binary on the same host is enough for the PoC path. Prefer **`GGHSTATS_HOST=127.0.0.1`** for bare-metal installs behind a local reverse proxy (loopback does **not** disable MPTCP; it only reduces public bind surface).

After changing `GODEBUG` or the image tag: recreate/restart the unit (`compose up -d`, `systemctl restart gghstats`, or roll the Deployment). Details: [README — Linux MPTCP / CVE-2026-98432](README.md#linux-mptcp--cve-2026-98432-operators).

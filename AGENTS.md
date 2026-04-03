# Agent Guidelines (gghstats-selfhosted)

- Use **English** for all project artifacts (code, comments, commit messages, docs, README).
- Follow **git flow**: work on `develop`; **`main`** for production snapshots; **annotated tags** `v<semver>` on `main` for infra releases (see root **`VERSION`**).
- **`VERSION`** (repository root): canonical **gghstats-selfhosted** semver (`0.1.0` style, no `v`). When it changes, align README badge, Helm **`Chart.yaml`** `version:`, optional CHANGELOG, and Git tag `v…` on **`main`** (see **Versioning** in README).
- **`GGHSTATS_VERSION`** in **`${GGHSTATS_HOST_DATA}/.env`** (recommended) or any env file passed to Compose: pins the **application** OCI image (`ghcr.io/hrodrig/gghstats:…`); align with **[gghstats](https://github.com/hrodrig/gghstats)** releases — not the same field as this repo’s **`VERSION`**.
- This repo has **no** Go `Makefile` or `make release-check`; validation is manifest/docs review and optional `docker compose … config`.
- Keep **`run/`** paths, **`GGHSTATS_HOST_DATA`**, and **`${GGHSTATS_HOST_DATA}/.env`** / **`${GGHSTATS_HOST_DATA}/.env.observability`** documentation consistent across README files (always **`--env-file`** those paths from the clone root — no default of secrets in the repository root).
- Do not commit without first showing the proposed commit message and getting **explicit user approval** (same convention as **gghstats**).

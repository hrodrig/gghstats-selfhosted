# Authelia SSO (advanced, optional)

← [Back to run/README](../../README.md).

[Authelia](https://www.authelia.com/) adds Single Sign-On with 2FA (TOTP, WebAuthn) in front of gghstats.
It runs as a Traefik `forwardAuth` middleware on the same `gghstats_edge` network.

## What this protects

| Path | Policy | Effect |
|---|---|---|
| `/auth/` | bypass | Login portal (public) |
| `/api/*` | one_factor | API endpoints require login |
| `/h2h` | one_factor | Head-to-head comparison requires login |
| Everything else | default (bypass) | Dashboard remains public |

## Prerequisites

- The [Traefik stack](../traefik/) must be running on `gghstats_edge`
- Set three secrets in `${GGHSTATS_HOST_DATA}/.env` (see below)
- DNS for `GGHSTATS_HOSTNAME` must already resolve (same cert as gghstats)

## Quick start

```bash
export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data

# 1. Copy configs
mkdir -p "${GGHSTATS_HOST_DATA}/authelia"
cp run/docker-compose/authelia/authelia/configuration.yml "${GGHSTATS_HOST_DATA}/authelia/"
cp run/docker-compose/authelia/authelia/users.yml       "${GGHSTATS_HOST_DATA}/authelia/"

# 2. Generate secrets (add to ${GGHSTATS_HOST_DATA}/.env)
AUTHELIA_JWT_SECRET=$(openssl rand -hex 32)
AUTHELIA_SESSION_SECRET=$(openssl rand -hex 32)
AUTHELIA_STORAGE_PASSWORD=$(openssl rand -hex 16)
echo "AUTHELIA_JWT_SECRET=${AUTHELIA_JWT_SECRET}"     >> "${GGHSTATS_HOST_DATA}/.env"
echo "AUTHELIA_SESSION_SECRET=${AUTHELIA_SESSION_SECRET}" >> "${GGHSTATS_HOST_DATA}/.env"
echo "AUTHELIA_STORAGE_PASSWORD=${AUTHELIA_STORAGE_PASSWORD}" >> "${GGHSTATS_HOST_DATA}/.env"

# 3. Generate a password hash for the admin user
docker run --rm authelia/authelia:4.39 \
  authelia crypto hash generate argon2 --password 'your-password-here'
# Copy the output and paste it into ${GGHSTATS_HOST_DATA}/authelia/users.yml

# 4. Start Authelia
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -p gghstats-auth \
  -f run/docker-compose/authelia/docker-compose.authelia.yml up -d

# 5. Apply the Authelia override to Traefik
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -p gghstats-edge \
  -f run/docker-compose/traefik/docker-compose.yml \
  -f run/docker-compose/authelia/docker-compose.authelia.override.yml \
  up -d
```

Or with `compose-stack.sh`:

```bash
# Start everything (Traefik + gghstats + Authelia)
./run/scripts/compose-stack.sh prod up -d
./run/scripts/compose-stack.sh authelia up -d

# Or one-shot with --with-auth (restart only)
./run/scripts/compose-stack.sh --with-auth prod restart

# Apply the override to add forwardAuth middleware
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -p gghstats-edge \
  -f run/docker-compose/traefik/docker-compose.yml \
  -f run/docker-compose/authelia/docker-compose.authelia.override.yml \
  up -d
```

## Access

- Dashboard: `https://<GGHSTATS_HOSTNAME>/` (public)
- API: `https://<GGHSTATS_HOSTNAME>/api/repos` (redirects to `/auth/?rd=...`)
- Login: `https://<GGHSTATS_HOSTNAME>/auth/` (first factor: password; second factor: TOTP)

## Adding users

```bash
# Generate a password hash
docker run --rm authelia/authelia:4.39 \
  authelia crypto hash generate argon2 --password 'new-password'

# Add to ${GGHSTATS_HOST_DATA}/authelia/users.yml
# Restart Authelia to pick up changes:
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -p gghstats-auth \
  -f run/docker-compose/authelia/docker-compose.authelia.yml restart
```

## Disabling 2FA for a user

Add to the user entry in `users.yml`:

```yaml
admin:
  ...
  totp:
    disable: true
```

## Uninstall

```bash
# Remove the forwardAuth middleware from Traefik first
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -p gghstats-edge \
  -f run/docker-compose/traefik/docker-compose.yml up -d

# Stop and remove Authelia
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" -p gghstats-auth \
  -f run/docker-compose/authelia/docker-compose.authelia.yml down

# Remove data (optional)
rm -rf "${GGHSTATS_HOST_DATA}/authelia"
```

## Architecture

```
Internet → Traefik :443
              │
              ├─ /auth/*         → Authelia :9091 (login portal)
              ├─ /api/*, /h2h    → authelia-forward@docker (verify) → gghstats :8080
              └─ /*              → gghstats :8080 (public)

Authelia ←─ Valkey (Redis) :6379 (session storage)
```

## Troubleshooting

**"No user detected" on login:**
The password hash in `users.yml` was generated with a different `--password` than what you're typing. Regenerate with the correct password.

**"Untrusted issuer" on TOTP:**
The `totp.issuer` in `configuration.yml` must be consistent. If you change it, users need to re-register their TOTP tokens.

**Redirect loop after login:**
Ensure `authelia-forward.forwardauth.address` includes `?rd=https://...` pointing to your `GGHSTATS_HOSTNAME`.

**Valkey connection refused:**
Check `AUTHELIA_STORAGE_PASSWORD` is set and matches in both the `.env` and the Valkey command in `docker-compose.authelia.yml`.

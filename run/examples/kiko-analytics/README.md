# gghstats + Kiko analytics

This example shows how to integrate [Kiko](https://kiko.analytics) (or any analytics service) with gghstats using two features added in **gghstats >= 0.7.11**:

- **`headHTML`**: inject the tracker script before `</head>` on every page.
- **`reverseProxyRules`**: proxy the analytics collection endpoint through gghstats, avoiding ad-blocker domain blocking.

## How it works

```
                     reverseProxyRules            Kiko backend
  Browser ──► /kiko/kiko.js ──► gghstats ──► https://events.example.com
                 (static)         │
                                  │ headHTML injects:
                                  │   <script defer src="/kiko/kiko.js"
                                  │            data-endpoint="/kiko">
                                  │
```

1. gghstats injects a `<script>` tag pointing to `/kiko/kiko.js` (served by Kiko or a sidecar).
2. The browser loads the tracker script from the same origin (no ad-blocker domain blocking).
3. The tracker sends events to `/kiko` — gghstats proxies these requests to the real Kiko backend via `reverseProxyRules`.

## Files

| File | Purpose |
|------|---------|
| [`docker-compose.kiko.yml`](docker-compose.kiko.yml) | Docker Compose override — apply on top of any gghstats compose stack. |
| [`kiko-helm-values.yaml`](kiko-helm-values.yaml) | Helm values overlay — merge with your main values.yaml or pass with `-f`. |

## Prerequisites

- gghstats image **>= 0.7.11** (currently `v0.8.1` in defaults — upgrade `GGHSTATS_VERSION` or `image.tag` if pinned lower).
- A Kiko (or compatible analytics) account and backend URL.

## Usage

### Docker Compose

From the repository root, with `GGHSTATS_HOST_DATA` set:

```bash
# Apply the kiko override on top of your existing stack (e.g. traefik):
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml \
  -f run/examples/kiko-analytics/docker-compose.kiko.yml \
  up -d

# Or override env vars to point to your own analytics backend:
GGHSTATS_HEAD_HTML='<script defer src="/custom/analytics.js" data-endpoint="/custom"></script>' \
GGHSTATS_REVERSE_PROXY_RULES='[{"local":"/custom","url":"https://my-analytics.example.com","headers":{"Host":"my-analytics.example.com"}}]' \
docker compose --env-file "${GGHSTATS_HOST_DATA}/.env" \
  -f run/docker-compose/traefik/docker-compose.yml \
  -f run/examples/kiko-analytics/docker-compose.kiko.yml \
  up -d
```

### Helm

**From a git clone** (always works, no published chart needed):

```bash
helm upgrade --install gghstats ./run/kubernetes/helm/gghstats \
  -f my-values.yaml \
  -f run/examples/kiko-analytics/kiko-helm-values.yaml \
  -n gghstats
```

If you prefer using the published charts, try:

```bash
helm repo add gghstats https://hrodrig.github.io/gghstats-selfhosted
helm repo update
helm upgrade --install gghstats gghstats/gghstats \
  -f my-values.yaml \
  -f run/examples/kiko-analytics/kiko-helm-values.yaml \
  -n gghstats
```

Edit [`kiko-helm-values.yaml`](kiko-helm-values.yaml) to replace the example backend URL and Host header with your own.

## Customisation

- **Different analytics provider**: replace the `headHTML` script URL and `reverseProxyRules` backend.
- **Multiple scripts**: concatenate multiple `<script>` tags in `headHTML`.
- **No reverse proxy**: if your analytics script loads from a CDN (not self-hosted), you may only need `headHTML` and can skip `reverseProxyRules` entirely.

---

[↑ Back to examples](../README.md)

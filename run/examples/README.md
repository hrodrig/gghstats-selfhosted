# Integration examples

Real-world scenarios combining **gghstats** with external services, using the app's built-in features:

- **`headHTML`** (gghstats >= 0.7.11): inject custom HTML before `</head>` — analytics snippets, extra CSS, meta tags.
- **`reverseProxyRules`** (gghstats >= 0.7.11): proxy local path prefixes to a remote backend — sidecar services, analytics endpoints, etc.

## Available examples

| Example | What it shows |
|---------|---------------|
| [`kiko-analytics/`](kiko-analytics/) | Integrate [Kiko](https://kiko.hermesrodriguez.com) (or any analytics script) via `headHTML`, proxy the collection endpoint via `reverseProxyRules`. Covers both **Docker Compose** and **Helm**. |

## How to use

Each example folder contains its own README with prerequisites, configuration, and step-by-step instructions for both Compose and Helm deployments.

---

[↑ Back to run/README](../README.md)

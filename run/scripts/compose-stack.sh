#!/usr/bin/env bash
# Wrapper for docker compose: correct --env-file, -f paths, and project name from repo root.
# See run/README.md and per-stack READMEs under run/docker-compose/.

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
TRAEFIK_OVERLAY=0
WITH_OBS=0
DATA_DIR=""

usage() {
  cat <<EOF
Usage: $(basename "$0") [options] <stack> <compose-subcommand> [arguments...]

Run from any directory; paths are resolved relative to the repository clone.

Stacks:
  minimal         run/docker-compose/minimal/docker-compose.yml
  traefik         run/docker-compose/traefik/docker-compose.yml
  observability   run/docker-compose/observability/docker-compose.observability.yml (project: gghstats-obs)
  prod            Traefik + gghstats only: up | down | restart (no ordering puzzle for a single compose file)
  full            Same as --with-obs prod: Traefik + gghstats, then observability (Grafana overlay to Traefik)

  For Traefik + gghstats + observability on the shared Docker network (gghstats_edge):
  start the traefik stack first, then observability. The observability stack does not
  start Traefik or gghstats; the observability Traefik overlay adds Grafana behind your edge.

  Order-safe shortcuts (subcommands: up | down | restart only):
    prod up -d              → traefik up -d
    prod restart            → traefik restart
    full up -d              → traefik up -d, then observability (+ Traefik overlay) up -d
    full down               → observability down, then traefik down
    full restart            → traefik restart, then observability restart
    --with-obs prod …       → same as full … (for users who prefer a flag over the "full" name)

Options:
  --data-dir DIR   Set GGHSTATS_HOST_DATA for this invocation (otherwise use env GGHSTATS_HOST_DATA)
  --with-obs       (prod only; place before "prod") Same as stack "full" — include observability in the ordered steps
  --traefik        (observability only) Also load docker-compose.observability.traefik.yml (Grafana via Traefik)
  -h, --help       Show this help

Environment:
  GGHSTATS_HOST_DATA   Host directory for operator files (required):
                       - minimal, traefik:  \${GGHSTATS_HOST_DATA}/.env
                       - observability:     \${GGHSTATS_HOST_DATA}/.env.observability

Examples:
  export GGHSTATS_HOST_DATA=/home/gghstats/gghstats-data
  $(basename "$0") minimal up -d
  $(basename "$0") traefik down
  $(basename "$0") traefik restart
  # Traefik only, or Traefik + observability (typical production with metrics stack):
  $(basename "$0") prod restart
  $(basename "$0") full restart
  $(basename "$0") full up -d
  $(basename "$0") --with-obs prod up -d   # equivalent to: full up -d
  # Manual order (same as "full"):
  $(basename "$0") traefik up -d
  $(basename "$0") --traefik observability up -d
  $(basename "$0") observability logs grafana -f

Note: After changing GGHSTATS_VERSION in .env — pull the image from GHCR, then traefik up -d (not restart). restart does not apply a new tag.
EOF
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --with-obs)
      WITH_OBS=1
      shift
      ;;
    --traefik)
      TRAEFIK_OVERLAY=1
      shift
      ;;
    --data-dir)
      [[ -n "${2:-}" ]] || {
        echo "error: --data-dir requires a path" >&2
        exit 1
      }
      DATA_DIR="$2"
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      break
      ;;
  esac
done

if [[ -n "$DATA_DIR" ]]; then
  export GGHSTATS_HOST_DATA="$DATA_DIR"
fi

if [[ -z "${GGHSTATS_HOST_DATA:-}" ]]; then
  echo "error: set GGHSTATS_HOST_DATA or pass --data-dir DIR" >&2
  usage >&2
  exit 1
fi

if [[ $# -lt 2 ]]; then
  echo "error: expected <stack> <compose-subcommand> [...]" >&2
  usage >&2
  exit 1
fi

STACK="$1"
shift
if [[ "$STACK" == "full" ]]; then
  WITH_OBS=1
  STACK=prod
fi

if [[ "$WITH_OBS" -eq 1 && "$STACK" != "prod" ]]; then
  echo "error: --with-obs applies only to stack prod (or use stack: full for Traefik + observability)" >&2
  exit 1
fi

COMPOSE_SUBCMD="$1"
shift

MAIN_ENV="${GGHSTATS_HOST_DATA}/.env"
OBS_ENV="${GGHSTATS_HOST_DATA}/.env.observability"

compose_traefik() {
  docker compose --env-file "$MAIN_ENV" -f "$ROOT/run/docker-compose/traefik/docker-compose.yml" "$@"
}

compose_obs_traefik_overlay() {
  docker compose --env-file "$OBS_ENV" -p gghstats-obs \
    -f "$ROOT/run/docker-compose/observability/docker-compose.observability.yml" \
    -f "$ROOT/run/docker-compose/observability/docker-compose.observability.traefik.yml" "$@"
}

COMPOSE_ARGS=()

case "$STACK" in
  prod)
    [[ -f "$MAIN_ENV" ]] || {
      echo "error: missing main env file: $MAIN_ENV" >&2
      exit 1
    }
    case "$COMPOSE_SUBCMD" in
      up | down | restart) ;;
      *)
        echo "error: stack prod only supports compose subcommands up, down, restart (got: $COMPOSE_SUBCMD)" >&2
        exit 1
        ;;
    esac
    if [[ "$WITH_OBS" -eq 1 ]]; then
      [[ -f "$OBS_ENV" ]] || {
        echo "error: missing observability env file: $OBS_ENV (required for --with-obs / stack full)" >&2
        exit 1
      }
    fi
    cd "$ROOT"
    case "$COMPOSE_SUBCMD" in
      up)
        compose_traefik up "$@"
        if [[ "$WITH_OBS" -eq 1 ]]; then
          compose_obs_traefik_overlay up "$@"
        fi
        ;;
      down)
        if [[ "$WITH_OBS" -eq 1 ]]; then
          compose_obs_traefik_overlay down "$@"
        fi
        compose_traefik down "$@"
        ;;
      restart)
        compose_traefik restart "$@"
        if [[ "$WITH_OBS" -eq 1 ]]; then
          compose_obs_traefik_overlay restart "$@"
        fi
        ;;
    esac
    exit 0
    ;;
  minimal)
    [[ -f "$MAIN_ENV" ]] || {
      echo "error: missing main env file: $MAIN_ENV" >&2
      exit 1
    }
    COMPOSE_ARGS+=(--env-file "$MAIN_ENV" -f "$ROOT/run/docker-compose/minimal/docker-compose.yml")
    ;;
  traefik)
    [[ -f "$MAIN_ENV" ]] || {
      echo "error: missing main env file: $MAIN_ENV" >&2
      exit 1
    }
    COMPOSE_ARGS+=(--env-file "$MAIN_ENV" -f "$ROOT/run/docker-compose/traefik/docker-compose.yml")
    ;;
  observability)
    [[ -f "$OBS_ENV" ]] || {
      echo "error: missing observability env file: $OBS_ENV" >&2
      exit 1
    }
    COMPOSE_ARGS+=(--env-file "$OBS_ENV" -p gghstats-obs -f "$ROOT/run/docker-compose/observability/docker-compose.observability.yml")
    if [[ "$TRAEFIK_OVERLAY" -eq 1 ]]; then
      COMPOSE_ARGS+=(-f "$ROOT/run/docker-compose/observability/docker-compose.observability.traefik.yml")
    fi
    ;;
  *)
    echo "error: unknown stack: $STACK (use minimal, traefik, observability, prod, or full)" >&2
    usage >&2
    exit 1
    ;;
esac

if [[ "$STACK" != "observability" && "$TRAEFIK_OVERLAY" -eq 1 ]]; then
  echo "error: --traefik applies only to the observability stack" >&2
  exit 1
fi

cd "$ROOT"
exec docker compose "${COMPOSE_ARGS[@]}" "$COMPOSE_SUBCMD" "$@"

#!/usr/bin/env bash
# kind + Helm smoke test for gghstats (see Makefile: test-helm-kind).
# Requires: docker, kind, kubectl, helm; GGHSTATS_HELM_E2E_GITHUB_TOKEN with repo read access.
set -euo pipefail

CLUSTER_NAME="${GGHSTATS_HELM_E2E_CLUSTER:-gghstats-helm-e2e}"
ROLLOUT_TIMEOUT="${GGHSTATS_HELM_E2E_ROLLOUT_TIMEOUT:-300s}"
LOG_WAIT_SECS="${GGHSTATS_HELM_E2E_LOG_WAIT_SECS:-120}"
GITHUB_TOKEN="${GGHSTATS_HELM_E2E_GITHUB_TOKEN:-}"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"
CHART_DIR="$REPO_ROOT/run/kubernetes/helm/gghstats"
NS_GGHSTATS="gghstats"
LABEL_GGHSTATS="app.kubernetes.io/name=gghstats"

dump_gghstats_diagnostics() {
  echo ""
  echo "========== gghstats diagnostics (namespace $NS_GGHSTATS) =========="
  kubectl get pods -n "$NS_GGHSTATS" -o wide 2>/dev/null || true
  echo ""
  kubectl describe pod -n "$NS_GGHSTATS" -l "$LABEL_GGHSTATS" 2>/dev/null || true
  echo ""
  kubectl logs -n "$NS_GGHSTATS" -l "$LABEL_GGHSTATS" --tail=120 2>/dev/null || true
  echo ""
  kubectl logs -n "$NS_GGHSTATS" -l "$LABEL_GGHSTATS" --previous --tail=120 2>/dev/null || true
  echo ""
  kubectl get events -n "$NS_GGHSTATS" --sort-by='.lastTimestamp' 2>/dev/null | tail -40 || true
  echo "========== end diagnostics =========="
  echo ""
}

cleanup() {
  if [[ -n "${GGHSTATS_HELM_E2E_NO_CLEANUP:-}" ]]; then
    echo "GGHSTATS_HELM_E2E_NO_CLEANUP is set; keeping kind cluster: $CLUSTER_NAME"
    echo "  kubectl config use-context kind-$CLUSTER_NAME"
    return 0
  fi
  echo "Cleaning up: kind delete cluster --name $CLUSTER_NAME"
  kind delete cluster --name "$CLUSTER_NAME" 2>/dev/null || true
}
trap cleanup EXIT

for cmd in docker kind kubectl helm; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "error: '$cmd' not found on PATH"
    exit 1
  }
done

test -d "$CHART_DIR" || {
  echo "error: chart directory not found: $CHART_DIR"
  exit 1
}

if [[ -z "$GITHUB_TOKEN" ]]; then
  echo "error: set GGHSTATS_HELM_E2E_GITHUB_TOKEN (GitHub PAT with repo read for your filter)."
  exit 1
fi

echo "Creating kind cluster: $CLUSTER_NAME"
kind create cluster --name "$CLUSTER_NAME" --wait 60s

echo "Installing gghstats chart (sync on startup disabled for a faster smoke test)..."
helm upgrade --install gghstats "$CHART_DIR" \
  -n "$NS_GGHSTATS" --create-namespace \
  --set githubToken.value="$GITHUB_TOKEN" \
  --set env.syncOnStartup=false \
  --set resources.requests.memory="96Mi" \
  --set resources.requests.cpu="50m" \
  --set resources.limits.memory="256Mi" \
  --set resources.limits.cpu="500m"

echo "Waiting for gghstats rollout (timeout $ROLLOUT_TIMEOUT)..."
if ! kubectl rollout status deployment/gghstats -n "$NS_GGHSTATS" --timeout="$ROLLOUT_TIMEOUT"; then
  echo "error: gghstats Deployment did not become ready."
  dump_gghstats_diagnostics
  exit 1
fi

echo "--- gghstats logs (tail) ---"
kubectl logs -n "$NS_GGHSTATS" -l "$LABEL_GGHSTATS" --tail=80

echo "Checking logs for HTTP listener..."
deadline=$((SECONDS + LOG_WAIT_SECS))
ok=0
while (( SECONDS < deadline )); do
  if kubectl logs -n "$NS_GGHSTATS" -l "$LABEL_GGHSTATS" --tail=200 2>/dev/null | grep -q 'listening'; then
    ok=1
    break
  fi
  sleep 2
done
if [[ "$ok" != "1" ]]; then
  echo "error: did not see 'listening' in gghstats logs within ${LOG_WAIT_SECS}s."
  dump_gghstats_diagnostics
  exit 1
fi
echo "Log check OK (server listening)."

echo ""
echo "kind + gghstats (Helm) smoke test passed."

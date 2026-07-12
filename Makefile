# gghstats-selfhosted — deployment manifests (Compose, Helm, lab tests)
# Primary validation: Helm workflow (CI), Compose on real hosts.

.DEFAULT_GOAL := help

LIMIT ?=

CHART_DIR ?= run/kubernetes/helm/gghstats
KUBERNETES_VERSION ?= 1.30.0

# Single source of truth: VERSION file at repo root (this repo's semver, not GGHSTATS_VERSION).
VERSION_RAW ?= $(shell cat VERSION 2>/dev/null | tr -d '\n\r')
VERSION     := $(patsubst v%,%,$(VERSION_RAW))
TAG         := v$(VERSION)

.PHONY: help release-check test-compose-platforms test-helm-kind

GREEN  := \033[0;32m
YELLOW := \033[0;33m
RESET  := \033[0m

help:
	@echo "$(GREEN)gghstats-selfhosted$(RESET) — Compose / Helm / platform lab for gghstats"
	@echo ""
	@echo "Usage: make [target]"
	@echo ""
	@echo "$(YELLOW)Quality:$(RESET)"
	@echo "  $(GREEN)release-check$(RESET)            Local gate before tagging: helm lint, helm template +"
	@echo "                             kubeconform (same scenarios as CI), minimal Compose config."
	@echo "                             Requires: helm, kubeconform, docker (compose plugin)."
	@echo ""
	@echo "$(YELLOW)Helm:$(RESET)"
	@echo "  $(GREEN)test-helm-kind$(RESET)           kind + Helm install gghstats + /api/v1/healthz check."
	@echo "                             Requires: Docker, kind, kubectl, helm."
	@echo "                             Env: GGHSTATS_HELM_E2E_GITHUB_TOKEN (fine-grained PAT, repo read)."
	@echo "                             Optional: GGHSTATS_HELM_E2E_CLUSTER, GGHSTATS_HELM_E2E_ROLLOUT_TIMEOUT,"
	@echo "                             GGHSTATS_HELM_E2E_LOG_WAIT_SECS, GGHSTATS_HELM_E2E_NO_CLEANUP"
	@echo ""
	@echo "$(YELLOW)Compose / platforms:$(RESET)"
	@echo "  $(GREEN)test-compose-platforms$(RESET)   Ansible full-cycle on lab hosts (testing/platforms/)."
	@echo "                             Requires inventory: testing/platforms/inventory/hosts.yml"
	@echo "                             Optional: LIMIT=hostname for --limit"
	@echo ""
	@echo "Current version: $(VERSION) (tag: $(TAG))"
	@echo ""
	@echo "Examples:"
	@echo "  make release-check"
	@echo "  make test-helm-kind"
	@echo "  make test-compose-platforms"
	@echo "  make test-compose-platforms LIMIT=vps-ubuntu"

release-check:
	@command -v helm >/dev/null 2>&1 || { echo "helm not found"; exit 1; }
	@command -v kubeconform >/dev/null 2>&1 || { echo "kubeconform not found (brew install kubeconform — see CONTRIBUTING.md)"; exit 1; }
	@command -v docker >/dev/null 2>&1 || { echo "docker not found"; exit 1; }
	@echo "release-check: helm lint $(CHART_DIR)..."
	@helm lint "$(CHART_DIR)"
	@echo "release-check: helm template + kubeconform (default values)..."
	@helm template test-rel "$(CHART_DIR)" --namespace test-ns | \
		kubeconform -strict -kubernetes-version "$(KUBERNETES_VERSION)" -summary -
	@echo "release-check: helm template + kubeconform (persistence disabled)..."
	@helm template test-rel "$(CHART_DIR)" --namespace test-ns \
		--set persistence.enabled=false | \
		kubeconform -strict -kubernetes-version "$(KUBERNETES_VERSION)" -summary -
	@echo "release-check: helm template + kubeconform (inline GitHub token Secret)..."
	@helm template test-rel "$(CHART_DIR)" --namespace test-ns \
		--set githubToken.value=ci-placeholder-token | \
		kubeconform -strict -kubernetes-version "$(KUBERNETES_VERSION)" -summary -
	@echo "release-check: helm template + kubeconform (existing Secret for token)..."
	@helm template test-rel "$(CHART_DIR)" --namespace test-ns \
		--set githubToken.existingSecret=my-imported-secret | \
		kubeconform -strict -kubernetes-version "$(KUBERNETES_VERSION)" -summary -
	@echo "release-check: docker compose config (minimal, placeholder token)..."
	@GGHSTATS_GITHUB_TOKEN=ghp_placeholder \
		docker compose --env-file run/common/.env.example \
		-f run/docker-compose/minimal/docker-compose.yml config >/dev/null
	@echo "release-check passed."

test-helm-kind:
	@command -v docker >/dev/null 2>&1 || { echo "docker not found"; exit 1; }
	@command -v kind >/dev/null 2>&1 || { echo "kind not found (https://kind.sigs.k8s.io/docs/user/quick-start/#installation)"; exit 1; }
	@command -v kubectl >/dev/null 2>&1 || { echo "kubectl not found"; exit 1; }
	@command -v helm >/dev/null 2>&1 || { echo "helm not found"; exit 1; }
	@chmod +x testing/scripts/test-helm-kind.sh
	@testing/scripts/test-helm-kind.sh

test-compose-platforms:
	@command -v ansible-playbook >/dev/null 2>&1 || { echo "ansible-playbook not found; install Ansible 2.14+ (e.g. pip install ansible)"; exit 1; }
	@test -f testing/platforms/inventory/hosts.yml || { echo "Missing testing/platforms/inventory/hosts.yml — copy hosts.yml.example and edit."; exit 1; }
	cd testing/platforms && ansible-playbook playbooks/full-cycle.yml $(if $(LIMIT),--limit $(LIMIT),)

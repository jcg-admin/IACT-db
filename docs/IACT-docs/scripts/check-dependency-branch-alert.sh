#!/bin/bash
# scripts/check-dependency-branch-alert.sh
# Detect dependency lock changes in PRs targeting main and emit branch sync alerts.

set -euo pipefail

EVENT_PATH="${GITHUB_EVENT_PATH:-}"

if ! command -v jq >/dev/null 2>&1; then
  echo "::error::jq is required but not available in the runner."
  exit 1
fi

if [ -z "$EVENT_PATH" ] || [ ! -f "$EVENT_PATH" ]; then
  echo "::error::GITHUB_EVENT_PATH is not available."
  exit 1
fi

# Optional override variables from the caller workflow.
# If unset, values are read from GITHUB_EVENT_PATH.
BASE_SHA="${GITHUB_BASE_SHA:-}"
HEAD_SHA="${GITHUB_HEAD_SHA:-}"

if [ -z "$BASE_SHA" ]; then
  BASE_SHA="$(jq -r '.pull_request.base.sha // empty' "$EVENT_PATH")"
fi

if [ -z "$HEAD_SHA" ]; then
  HEAD_SHA="$(jq -r '.pull_request.head.sha // empty' "$EVENT_PATH")"
fi

if [ -z "$BASE_SHA" ] || [ -z "$HEAD_SHA" ]; then
  echo "::error::Unable to resolve BASE_SHA and HEAD_SHA from event payload."
  exit 1
fi

if ! git rev-parse --verify --quiet "${BASE_SHA}^{commit}" >/dev/null; then
  echo "::error::Base SHA '${BASE_SHA}' is not available in local git history."
  exit 1
fi

if ! git rev-parse --verify --quiet "${HEAD_SHA}^{commit}" >/dev/null; then
  echo "::error::Head SHA '${HEAD_SHA}' is not available in local git history."
  exit 1
fi

CHANGED_FILES="$(git diff --name-only "$BASE_SHA" "$HEAD_SHA")"

CHANGED_PYPROJECT=false
CHANGED_UV_LOCK=false

if echo "$CHANGED_FILES" | grep -qx 'pyproject.toml'; then
  CHANGED_PYPROJECT=true
fi

if echo "$CHANGED_FILES" | grep -qx 'uv.lock'; then
  CHANGED_UV_LOCK=true
fi

ALERT_REQUIRED=false
if [ "$CHANGED_PYPROJECT" = true ] || [ "$CHANGED_UV_LOCK" = true ]; then
  ALERT_REQUIRED=true
fi

ALERT_MESSAGE=""
if [ "$ALERT_REQUIRED" = true ]; then
  ALERT_MESSAGE="$(cat <<'EOF'
⚠️ **Branch synchronization alert**

This PR modifies locked dependencies (**pyproject.toml**/**uv.lock**).
Other active branches should **merge/rebase with main** to avoid dependency drift and future lockfile conflicts.
EOF
)"

  if [ "$CHANGED_PYPROJECT" = true ] && [ "$CHANGED_UV_LOCK" = false ]; then
    ALERT_MESSAGE="$ALERT_MESSAGE

❗ **pyproject.toml** changed without **uv.lock**. Recommendation: regenerate the lockfile before merge."
  fi

  if [ "$CHANGED_PYPROJECT" = false ] && [ "$CHANGED_UV_LOCK" = true ]; then
    ALERT_MESSAGE="$ALERT_MESSAGE

ℹ️ Only **uv.lock** changed. Verify this matches an intentional dependency resolution update."
  fi

  echo "::warning::Dependency lockfiles changed; branch sync alert generated."
fi

{
  echo "alert_required=$ALERT_REQUIRED"
  echo "changed_pyproject=$CHANGED_PYPROJECT"
  echo "changed_uv_lock=$CHANGED_UV_LOCK"
  echo "message<<EOF"
  printf '%s\n' "$ALERT_MESSAGE"
  echo "EOF"
} >> "$GITHUB_OUTPUT"

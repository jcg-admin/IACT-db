#!/usr/bin/env bash
# Activa los hooks de .githooks/ en este clone.
# Idempotente — seguro de re-ejecutar.
set -euo pipefail

REPO_ROOT="$(git rev-parse --show-toplevel)"
cd "$REPO_ROOT"

if [ ! -d .githooks ]; then
  echo "ERROR: .githooks/ no existe en $REPO_ROOT" >&2
  exit 1
fi

git config core.hooksPath .githooks
chmod +x .githooks/* 2>/dev/null || true

echo "OK: core.hooksPath = $(git config core.hooksPath)"
echo "Hooks activos:"
ls -1 .githooks/

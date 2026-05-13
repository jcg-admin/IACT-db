#!/bin/bash
# set-session-phase.sh — actualiza now.md::phase in-place (sin append)
# Uso: bash .claude/scripts/set-session-phase.sh "Phase N"
# Fix de Bug 1: reemplaza el campo existente en lugar de hacer echo >>

set -e

if [ -z "$1" ]; then
  echo "Usage: set-session-phase.sh <phase-name>" >&2
  exit 1
fi

PHASE="$1"
NOW_FILE=".thyrox/context/now.md"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if [ ! -f "$NOW_FILE" ]; then
  echo "Error: $NOW_FILE not found" >&2
  exit 1
fi

sed -i \
  -e "s|^phase: .*|phase: $PHASE|" \
  -e "s|^updated_at: .*|updated_at: $DATE|" \
  "$NOW_FILE"

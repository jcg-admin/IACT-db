#!/usr/bin/env bash
# PreToolUse hook — verifica I-001 antes de crear task-plan en plan-execution/
# Bloquea si el WP no tiene discover/ con -analysis.md

set -euo pipefail

INPUT=$(cat)
TOOL_NAME=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_name',''))" 2>/dev/null || echo "")

if [ "$TOOL_NAME" != "Write" ] && [ "$TOOL_NAME" != "Edit" ]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

FILE_PATH=$(echo "$INPUT" | python3 -c "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null || echo "")

# Solo interceptar escrituras en plan-execution/
if ! echo "$FILE_PATH" | grep -q "plan-execution/"; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'
  exit 0
fi

# Extraer directorio del WP (2 niveles arriba de plan-execution/)
WP_DIR=$(dirname "$(dirname "$FILE_PATH")")

# Verificar que existe discover/ con un -analysis.md
if [ ! -d "$WP_DIR/discover" ] || ! ls "$WP_DIR/discover/"*-analysis.md 2>/dev/null | head -1 | grep -q "."; then
  REASON="I-001 VIOLADO: No existe discover/*-analysis.md en el WP.
WP: $WP_DIR
THYROX requiere Stage 1 DISCOVER completo antes de crear task-plan en plan-execution/.
Completar Stage 1 y crear {wp-name}-analysis.md antes de continuar."
  echo "{\"hookSpecificOutput\":{\"hookEventName\":\"PreToolUse\",\"permissionDecision\":\"deny\",\"reason\":\"$REASON\"}}"
  exit 0
fi

echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"allow"}}'

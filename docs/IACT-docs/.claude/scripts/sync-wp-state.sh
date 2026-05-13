#!/bin/bash
# sync-wp-state.sh — PostToolUse hook: sincroniza now.md::current_work
# Llamado por settings.json PostToolUse Write hook
# Recibe JSON del evento en stdin, extrae file_path, actualiza current_work si es WP
# Fix de Bug 2: current_work se actualiza deterministicamente, no via instruccion LLM

INPUT=$(cat)
NOW_FILE=".thyrox/context/now.md"

# Extraer file_path — jq con fallback a python3
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty' 2>/dev/null)
if [ -z "$FILE_PATH" ]; then
  FILE_PATH=$(echo "$INPUT" | python3 -c \
    "import sys,json; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" \
    2>/dev/null || true)
fi

# Si no se pudo extraer o no es archivo WP, salir sin cambios
if [[ "$FILE_PATH" != *"/.thyrox/context/work/"* ]]; then
  exit 0
fi

# Extraer WP path relativo (.thyrox/context/work/YYYY-MM-DD-HH-MM-SS-nombre)
# Sin trailing slash — consistente con validate-session-close.sh [ -d "$CURRENT_WORK" ]
WP_PATH=$(echo "$FILE_PATH" | grep -oP '\.thyrox/context/work/[^/]+')

if [ -z "$WP_PATH" ]; then
  exit 0
fi

# Leer current_work actual
if [ ! -f "$NOW_FILE" ]; then
  exit 0
fi

CURRENT=$(grep "^current_work:" "$NOW_FILE" | sed 's/current_work: //' | tr -d '[:space:]')

# Solo actualizar si cambio el WP (idempotente)
if [ "$CURRENT" = "$WP_PATH" ]; then
  exit 0
fi

DATE=$(date '+%Y-%m-%d %H:%M:%S')
sed -i \
  -e "s|^current_work: .*|current_work: $WP_PATH|" \
  -e "s|^updated_at: .*|updated_at: $DATE|" \
  "$NOW_FILE"

# T-050: Al detectar cambio de current_work, marcar stage_sync_required
# para que session-start.sh alerte al agente sobre posible desincronizacion de stage.
if grep -q "^stage_sync_required:" "$NOW_FILE" 2>/dev/null; then
  sed -i "s|^stage_sync_required:.*|stage_sync_required: true|" "$NOW_FILE"
else
  echo "stage_sync_required: true" >> "$NOW_FILE"
fi

# T-038: Observabilidad — append transición a phase-history.jsonl
HISTORY_FILE=".thyrox/context/phase-history.jsonl"
FLOW=$(grep "^flow:" "$NOW_FILE" 2>/dev/null | sed 's/flow: *//' | tr -d '[:space:]')
METHODOLOGY_STEP=$(grep "^methodology_step:" "$NOW_FILE" 2>/dev/null | sed 's/methodology_step: *//')
WP_NAME=$(basename "$WP_PATH")
EPIC=$(echo "$WP_NAME" | grep -oP '^\d+' || echo "")
printf '{"timestamp":"%s","from":"%s","to":"%s","flow":"%s","epic":"%s","wp":"%s"}\n' \
  "$DATE" "$CURRENT" "$WP_PATH" "${FLOW:-null}" "${EPIC:-null}" "$WP_NAME" \
  >> "$HISTORY_FILE" 2>/dev/null || true

exit 0

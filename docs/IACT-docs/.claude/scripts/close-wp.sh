#!/bin/bash
# close-wp.sh — limpia now.md al cerrar un WP
# Uso: bash .claude/scripts/close-wp.sh (script manual — NO es hook)
# Llamar DESPUES del ultimo Write al WP (lessons-learned, final-report)

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
NOW_FILE="${PROJECT_ROOT}/.thyrox/context/now.md"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

if [ ! -f "$NOW_FILE" ]; then
  echo "Error: $NOW_FILE not found" >&2
  exit 1
fi

# A-4: resetear campos de estado (stage: primario, phase: retrocompat, flow, methodology_step)
sed -i'' -e "s|^current_work: .*|current_work: null|" \
         -e "s|^stage: .*|stage: null|" \
         -e "s|^phase: .*|phase: null|" \
         -e "s|^flow: .*|flow: null|" \
         -e "s|^methodology_step: .*|methodology_step: null|" \
         -e "s|^updated_at: .*|updated_at: $DATE|" \
         "$NOW_FILE"

# A-5: limpiar body "# Contexto" — bash-puro sin python3 (DS-02)
CONTEXTO_LINE=$(grep -n "^# Contexto" "$NOW_FILE" | head -1 | cut -d: -f1)
if [ -n "$CONTEXTO_LINE" ]; then
    KEEP=$((CONTEXTO_LINE - 1))
    head -n "$KEEP" "$NOW_FILE" > "${NOW_FILE}.tmp"
    printf '# Contexto\n\n' >> "${NOW_FILE}.tmp"
    mv "${NOW_FILE}.tmp" "$NOW_FILE"
fi

# A-6: sincronizar project-state.md
bash "${PROJECT_ROOT}/.claude/scripts/update-state.sh" || true

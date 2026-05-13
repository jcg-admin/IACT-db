#!/usr/bin/env bash
# update-state.sh — Regenera project-state.md desde el estado real del repo
#
# Uso:
#   bash .claude/scripts/update-state.sh            # escribe project-state.md
#   bash .claude/scripts/update-state.sh --dry-run  # muestra sin escribir
#
# Lee:
#   .claude/agents/*.md       → agentes nativos activos
#   CHANGELOG.md              → versión actual del framework
#   ROADMAP.md                → FASEs completadas
#
# Escribe:
#   .thyrox/context/project-state.md

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"
AGENTS_DIR="${PROJECT_ROOT}/.claude/agents"
CHANGELOG="${PROJECT_ROOT}/CHANGELOG.md"
ROADMAP="${PROJECT_ROOT}/ROADMAP.md"
OUTPUT="${PROJECT_ROOT}/.thyrox/context/project-state.md"
DRY_RUN=false
TODAY=$(date '+%Y-%m-%d %H:%M:%S')
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')

if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

# --- Leer agentes activos ---
AGENTS=()
if [ -d "$AGENTS_DIR" ]; then
    while IFS= read -r f; do
        name=$(basename "$f" .md)
        # Leer descripción desde el frontmatter YAML (campo description:)
        desc=$(grep -m1 "^description:" "$f" 2>/dev/null | sed 's/description: *//;s/^"//;s/"$//' | cut -c1-80 || echo "")
        AGENTS+=("- \`${name}\` — ${desc}")
    done < <(ls -1 "${AGENTS_DIR}"/*.md 2>/dev/null | sort)
fi

AGENTS_COUNT="${#AGENTS[@]}"
AGENTS_LIST=$(printf '%s\n' "${AGENTS[@]}")

# --- Leer versión actual desde CHANGELOG ---
VERSION="unknown"
if [ -f "$CHANGELOG" ]; then
    VERSION=$(grep -m1 "^## \[" "$CHANGELOG" 2>/dev/null | sed 's/## \[\(.*\)\].*/\1/' || echo "unknown")
fi

# --- Leer FASEs completadas desde ROADMAP ---
FASES_COMPLETADAS=()
if [ -f "$ROADMAP" ]; then
    while IFS= read -r line; do
        # Líneas del tipo: ## FASE N: descripción (fecha)
        if echo "$line" | grep -qE "^## FASE [0-9]+:"; then
            FASES_COMPLETADAS+=("$line")
        fi
    done < "$ROADMAP"
fi
FASES_COUNT="${#FASES_COMPLETADAS[@]}"

# --- Construir contenido ---
CONTENT="$(cat <<HEREDOC
\`\`\`yml
type: Dashboard de Proyecto
category: Estado Actual
version: ${VERSION}
purpose: Dashboard del proyecto THYROX — estado actual y navegación
goal: Punto de entrada para entender estado actual y próximos pasos
updated_at: ${TODAY}
\`\`\`

# Project State — THYROX

## Status General

**Versión:** ${VERSION}
**Estado:** Activo — framework thyrox con ${FASES_COUNT} FASEs completadas
**Última actualización:** ${TODAY}
**Branch activo:** \`${CURRENT_BRANCH}\`

---

## Agentes nativos (\`${AGENTS_COUNT}\` agentes en \`.claude/agents/\`)

${AGENTS_LIST}

---

## FASEs completadas (${FASES_COUNT} total)

$(printf '%s\n' "${FASES_COMPLETADAS[@]}" | sed 's/^## /| /' | sed 's/$/ |/')

Ver ROADMAP.md para detalle de cada FASE.

---

## Componentes del framework

### Skills activos (\`.claude/skills/\`)
- \`thyrox/\` — Framework principal 7 fases (motor del proyecto)
- Tech skills: backend-nodejs, db-mysql, db-postgresql, frontend-react, frontend-webpack, python-mcp, sphinx

### MCP servers
- \`thyrox-memory\` — Memoria semántica FAISS (store/retrieve)
- \`thyrox-executor\` — Ejecución subprocess con blocklist

### Scripts de gestión (\`.claude/skills/thyrox/scripts/\`)
- \`update-state.sh\` — Regenera este archivo desde el repo real
- \`validate-session-close.sh\` — Valida cierre de sesión
- \`validate-phase-readiness.sh\` — Valida readiness por fase
- \`session-start.sh\` — Hook SessionStart (inyecta contexto)
- \`lint-agents.py\` — Valida formato de agentes nativos

---

## Deuda técnica registrada

Ver \`.thyrox/context/technical-debt.md\` para TD-001 a TD-007.

---

## Próximos pasos

Ver ROADMAP.md sección "sin completar" y \`context/focus.md\` para WP activo.
HEREDOC
)"

if $DRY_RUN; then
    echo "=== DRY RUN — no se escribirá ningún archivo ==="
    echo ""
    echo "Destino: ${OUTPUT}"
    echo "Agentes detectados: ${AGENTS_COUNT}"
    echo "Versión detectada: ${VERSION}"
    echo "FASEs detectadas: ${FASES_COUNT}"
    echo ""
    echo "--- Contenido que se escribiría ---"
    echo "$CONTENT"
else
    echo "$CONTENT" > "$OUTPUT"
    echo "[OK] project-state.md actualizado"
    echo "   Agentes: ${AGENTS_COUNT}"
    echo "   Versión: ${VERSION}"
    echo "   FASEs: ${FASES_COUNT}"
    echo "   Archivo: ${OUTPUT}"
fi

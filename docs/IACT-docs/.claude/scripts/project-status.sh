#!/usr/bin/env bash
# project-status.sh
# Resumen del estado del proyecto en <50 líneas.
# Uso: bash .claude/skills/thyrox/scripts/project-status.sh

set -euo pipefail

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
CONTEXT_DIR="${PROJECT_ROOT}/.thyrox/context"

echo "=== THYROX Project Status ==="
echo ""

# 1. Session state — parallel or single agent
# Estado de agentes activos (paralelo o single)
if ls "${CONTEXT_DIR}"/now-*.md 2>/dev/null | grep -q .; then
    echo "=== Agentes activos ==="
    for f in "${CONTEXT_DIR}"/now-*.md; do
        agent_id=$(basename "$f" .md | sed 's/now-//')
        status=$(grep "^status:" "$f" 2>/dev/null | head -1 | cut -d' ' -f2-)
        work=$(grep "^current_work:" "$f" 2>/dev/null | head -1 | cut -d' ' -f2-)
        echo "  $agent_id: $status — $work"
    done
elif [ -f "${CONTEXT_DIR}/now.md" ]; then
    echo "=== Estado actual (single agent) ==="
    grep -E "^(status|current_work|phase):" "${CONTEXT_DIR}/now.md"
fi

echo ""

# 2. Focus summary (first non-YAML, non-header content line)
if [ -f "${CONTEXT_DIR}/focus.md" ]; then
    echo "--- Focus ---"
    # Extract the first paragraph after # Focus header
    sed -n '/^# Focus/,/^##/{/^#/d; /^$/d; /^```/d; /^type:/d; /^version:/d; /^updated_at:/d; p;}' "${CONTEXT_DIR}/focus.md" | head -3
fi

echo ""

# 3. Active work package — next incomplete task
if [ -f "${CONTEXT_DIR}/now.md" ]; then
    CURRENT_WORK=$(grep "^current_work:" "${CONTEXT_DIR}/now.md" 2>/dev/null | head -1 | sed 's/current_work: *//' || echo "null")
    if [ "$CURRENT_WORK" != "null" ] && [ -n "$CURRENT_WORK" ]; then
        WP_DIR="${PROJECT_ROOT}/${CURRENT_WORK}"
        # New naming: *-task-plan.md; legacy fallback: tasks.md / plan.md
        TARGET=$(find "$WP_DIR" -maxdepth 1 -name "*-task-plan.md" 2>/dev/null | head -1)
        [ -z "$TARGET" ] && [ -f "${WP_DIR}tasks.md" ] && TARGET="${WP_DIR}tasks.md"
        [ -z "$TARGET" ] && [ -f "${WP_DIR}plan.md" ] && TARGET="${WP_DIR}plan.md"

        if [ -n "$TARGET" ]; then
            TOTAL=$(grep -c '^\- \[' "$TARGET" 2>/dev/null || echo 0)
            DONE=$(grep -c '^\- \[x\]' "$TARGET" 2>/dev/null || echo 0)
            NEXT=$(grep '^\- \[ \]' "$TARGET" 2>/dev/null | head -1 || echo "none")

            echo "--- Work Package Progress ---"
            echo "Tasks: $DONE/$TOTAL completed"
            echo "Next:  $NEXT"
        fi
        # Alerta B-08: WP activo no aparece en ROADMAP.md (TD-014, SPEC-003)
        WP_NAME=$(basename "$CURRENT_WORK")
        if [ -f "${PROJECT_ROOT}/ROADMAP.md" ]; then
            if ! grep -q "$WP_NAME" "${PROJECT_ROOT}/ROADMAP.md" 2>/dev/null; then
                echo ""
                echo "⚠  ALERTA B-08: El WP activo '${WP_NAME}' no aparece en ROADMAP.md."
                echo "   Agregar entrada en ROADMAP.md antes de continuar."
            fi
        fi
    fi
fi

echo ""

# 4. Recent commits (last 5)
echo "--- Recent Commits ---"
git -C "$PROJECT_ROOT" log --oneline -5 2>/dev/null || echo "No git history"

echo ""

# 5. ROADMAP progress summary
if [ -f "${PROJECT_ROOT}/ROADMAP.md" ]; then
    echo "--- ROADMAP ---"
    grep -E '^\s*(FASE|FASE )' "${PROJECT_ROOT}/ROADMAP.md" 2>/dev/null | head -10 || true
fi

echo ""

# 6. REGLA-LONGEV-001: alertar si archivos vivos superan 25,000 bytes
echo "--- Tamaño archivos vivos ---"
LONGEV_WARNED=0
for f in \
    "${PROJECT_ROOT}/ROADMAP.md" \
    "${PROJECT_ROOT}/CHANGELOG.md" \
    "${CONTEXT_DIR}/technical-debt.md" \
    "${PROJECT_ROOT}/.claude/references/conventions.md"; do
    [ -f "$f" ] || continue
    size=$(wc -c < "$f")
    label=$(basename "$f")
    if [ "$size" -gt 25000 ]; then
        echo "⚠ REGLA-LONGEV-001: $label supera 25,000 bytes (${size} bytes) — considerar split"
        LONGEV_WARNED=1
    else
        echo "  ✓ $label: ${size} bytes"
    fi
done
[ "$LONGEV_WARNED" -eq 0 ] && echo "  Todos los archivos vivos dentro del límite."

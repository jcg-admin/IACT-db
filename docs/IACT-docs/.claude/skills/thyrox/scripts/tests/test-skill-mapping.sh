#!/usr/bin/env bash
# test-skill-mapping.sh
# Tests para verify-skill-mapping.sh y estructura de SKILL.md
# Verifica: references enlazadas, assets enlazados, naming en tipos, tamaño < 500 líneas.
#
# Uso: bash .claude/skills/thyrox/scripts/tests/test-skill-mapping.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILL_DIR="${SCRIPT_DIR}/../.."
SKILL_FILE="${SKILL_DIR}/SKILL.md"
VERIFY_SCRIPT="${SCRIPT_DIR}/../verify-skill-mapping.sh"

PASS=0
FAIL=0

assert_pass() {
    local name="$1"
    local exit_code="$2"
    if [ "$exit_code" -eq 0 ]; then
        echo "  [OK] PASS: $name"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] FAIL: $name (expected 0, got $exit_code)"
        FAIL=$((FAIL + 1))
    fi
}

assert_true() {
    local name="$1"
    local condition="$2"
    if [ "$condition" -eq 1 ] 2>/dev/null || [ "$condition" = "true" ] 2>/dev/null; then
        echo "  [OK] PASS: $name"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] FAIL: $name"
        FAIL=$((FAIL + 1))
    fi
}

check_contains() {
    local name="$1"
    local pattern="$2"
    if grep -q "$pattern" "$SKILL_FILE" 2>/dev/null; then
        echo "  [OK] PASS: $name"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] FAIL: $name — pattern not found: $pattern"
        FAIL=$((FAIL + 1))
    fi
}

check_not_contains() {
    local name="$1"
    local pattern="$2"
    if ! grep -q "$pattern" "$SKILL_FILE" 2>/dev/null; then
        echo "  [OK] PASS: $name"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] FAIL: $name — unexpected pattern found: $pattern"
        FAIL=$((FAIL + 1))
    fi
}

# ── Verify script runs clean ──────────────────────────────────────────────────

echo ""
echo "=== verify-skill-mapping.sh ==="

exit_code=0
bash "$VERIFY_SCRIPT" > /dev/null 2>&1 || exit_code=$?
assert_pass "verify-skill-mapping.sh exits 0" "$exit_code"

# ── SKILL.md size ─────────────────────────────────────────────────────────────

echo ""
echo "=== SKILL.md tamaño ==="

LINES=$(wc -l < "$SKILL_FILE")
if [ "$LINES" -le 500 ]; then
    echo "  [OK] PASS: SKILL.md tamaño ($LINES líneas ≤ 500)"
    PASS=$((PASS + 1))
else
    echo "  [ERROR] FAIL: SKILL.md demasiado largo ($LINES líneas > 500)"
    FAIL=$((FAIL + 1))
fi

# ── Templates mapeados en SKILL.md ───────────────────────────────────────────

echo ""
echo "=== Templates mapeados en SKILL.md ==="

# Phase 1 templates
check_contains "Phase 1: introduction.md.template" "assets/introduction.md.template"
check_contains "Phase 1: risk-register.md.template" "assets/risk-register.md.template"
check_contains "Phase 1: exit-conditions.md.template" "assets/exit-conditions.md.template"
check_contains "Phase 1: constitution.md.template" "assets/constitution.md.template"
check_contains "Phase 1: basic-usage.md.template" "assets/basic-usage.md.template"
check_contains "Phase 1: stakeholders.md.template" "assets/stakeholders.md.template"
check_contains "Phase 1: requirements-analysis.md.template" "assets/requirements-analysis.md.template"
check_contains "Phase 1: use-cases.md.template" "assets/use-cases.md.template"
check_contains "Phase 1: quality-goals.md.template" "assets/quality-goals.md.template"
check_contains "Phase 1: constraints.md.template" "assets/constraints.md.template"
check_contains "Phase 1: context.md.template" "assets/context.md.template"
check_contains "Phase 1-2: adr.md.template" "assets/adr.md.template"
check_contains "Phase 2: solution-strategy.md.template" "assets/solution-strategy.md.template"
check_contains "Phase 3: epic.md.template" "assets/epic.md.template"
check_contains "Phase 4: requirements-specification.md.template" "assets/requirements-specification.md.template"
check_contains "Phase 4: spec-quality-checklist.md.template" "assets/spec-quality-checklist.md.template"
check_contains "Phase 4: design.md.template" "assets/design.md.template"
check_contains "Phase 5: tasks.md.template" "assets/tasks.md.template"
check_contains "Phase 6: execution-log.md.template" "assets/execution-log.md.template"
check_contains "Phase 6: error-report.md.template" "assets/error-report.md.template"
check_contains "Phase 7: lessons-learned.md.template" "assets/lessons-learned.md.template"
check_contains "Phase 7: changelog.md.template" "assets/changelog.md.template"
check_contains "Phase 7: final-report.md.template" "assets/final-report.md.template"

# ── Naming conventions en SKILL.md ───────────────────────────────────────────

echo ""
echo "=== Naming conventions ==="

check_contains "Tipo 'design' en lista de tipos" "design"
check_contains "Tipo 'exit-conditions' en lista de tipos" "exit-conditions"
check_contains "Tipo 'final-report' en lista de tipos" "final-report"
check_contains "Patrón {nombre-wp}-{tipo}.md documentado" "{nombre-wp}-{tipo}.md"
check_contains "Ejemplo con WP timestamp" "pagos-stripe"

# ── Artefactos en tabla de fases ─────────────────────────────────────────────

echo ""
echo "=== Tabla de artefactos por fase ==="

check_contains "Phase 4 design en tabla" "Diseño técnico"
check_contains "Phase 1 exit-conditions en tabla" "exit-conditions.md.template"
check_contains "Phase 7 final-report en tabla" "final-report.md.template"
check_contains "Phase 1 constitution en tabla" "constitution.md.template"

# ── Estructura work package ───────────────────────────────────────────────────

echo ""
echo "=== Estructura work package ==="

check_contains "exit-conditions en WP structure" "{nombre}-exit-conditions.md"
check_contains "design en WP structure" "{nombre}-design.md"
check_contains "final-report en WP structure" "{nombre}-final-report.md"

# ── No referencias rotas a rutas antiguas ────────────────────────────────────

echo ""
echo "=== Sin paths legacy rotos ==="

check_not_contains "No usa context/epics (legacy path)" "context/epics"
check_not_contains "No hardcodea introduction.md como nombre de output" "work/\.\.\./introduction\.md"

# ── Summary ──────────────────────────────────────────────────────────────────

echo ""
echo "============================================"
TOTAL=$((PASS + FAIL))
echo " Results: $PASS/$TOTAL passed"
echo "============================================"
if [ "$FAIL" -eq 0 ]; then
    echo " PASS"
    exit 0
else
    echo " FAIL ($FAIL failures)"
    exit 1
fi

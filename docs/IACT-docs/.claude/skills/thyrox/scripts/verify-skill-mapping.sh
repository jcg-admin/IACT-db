#!/usr/bin/env bash
# verify-skill-mapping.sh
# Verifica que SKILL.md enlaza a todas las references y detecta >300 líneas sin TOC.
#
# Uso:
#   bash .claude/skills/thyrox/scripts/verify-skill-mapping.sh

set -euo pipefail

SKILL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SKILL_FILE="${SKILL_DIR}/SKILL.md"
REFS_DIR="${SKILL_DIR}/references"
ASSETS_DIR="${SKILL_DIR}/assets"

PASS=0
FAIL=0
WARN=0

echo "=== Verificación de SKILL.md mapping ==="
echo ""

# 1. Verificar que todas las references están enlazadas en SKILL.md
echo "--- References enlazadas en SKILL.md ---"
for ref in "${REFS_DIR}"/*.md; do
    name=$(basename "$ref")
    if grep -q "references/${name}" "$SKILL_FILE" 2>/dev/null; then
        echo "  [OK] ${name}"
        PASS=$((PASS + 1))
    else
        echo "  [ERROR] ${name} — NO enlazada en SKILL.md"
        FAIL=$((FAIL + 1))
    fi
done
echo ""

# 2. Detectar references >300 líneas sin TOC
echo "--- References >300 líneas (necesitan TOC) ---"
for ref in "${REFS_DIR}"/*.md; do
    name=$(basename "$ref")
    lines=$(wc -l < "$ref")
    if [ "$lines" -gt 300 ]; then
        if grep -qi "table of contents\|tabla de contenidos\|## TOC\|## Contenido" "$ref" 2>/dev/null; then
            echo "  [OK] ${name} (${lines} líneas, tiene TOC)"
            PASS=$((PASS + 1))
        else
            echo "  [WARN]  ${name} (${lines} líneas, SIN TOC)"
            WARN=$((WARN + 1))
        fi
    fi
done
echo ""

# 3. Verificar que YAML frontmatter tiene name y description
echo "--- YAML frontmatter ---"
if head -5 "$SKILL_FILE" | grep -q "^name:"; then
    echo "  [OK] name field presente"
    PASS=$((PASS + 1))
else
    echo "  [ERROR] name field ausente"
    FAIL=$((FAIL + 1))
fi

if head -5 "$SKILL_FILE" | grep -q "^description:"; then
    echo "  [OK] description field presente"
    PASS=$((PASS + 1))
else
    echo "  [ERROR] description field ausente"
    FAIL=$((FAIL + 1))
fi
echo ""

# 4. Contar líneas del SKILL
SKILL_LINES=$(wc -l < "$SKILL_FILE")
echo "--- Tamaño del SKILL ---"
if [ "$SKILL_LINES" -le 500 ]; then
    echo "  [OK] ${SKILL_LINES} líneas (< 500)"
    PASS=$((PASS + 1))
else
    echo "  [ERROR] ${SKILL_LINES} líneas (> 500)"
    FAIL=$((FAIL + 1))
fi
echo ""

# 5. Verificar assets existen
echo "--- Assets ---"
ASSET_COUNT=$(find "$ASSETS_DIR" -name "*.template" -o -name "*.md.template" | wc -l)
echo "    ${ASSET_COUNT} templates en assets/"
echo ""

# 6. Verificar scripts existen
echo "--- Scripts ---"
SCRIPT_COUNT=$(find "${SKILL_DIR}/scripts" -name "*.sh" -o -name "*.py" | wc -l)
echo "    ${SCRIPT_COUNT} scripts"
echo ""

# Resumen
echo "=== Resumen ==="
echo "  [OK] Passed: ${PASS}"
echo "  [ERROR] Failed: ${FAIL}"
echo "  [WARN]  Warnings: ${WARN}"
echo ""

if [ "$FAIL" -eq 0 ]; then
    echo "PASS: Todas las verificaciones pasaron."
    exit 0
else
    echo "FAIL: ${FAIL} verificaciones fallaron."
    exit 1
fi

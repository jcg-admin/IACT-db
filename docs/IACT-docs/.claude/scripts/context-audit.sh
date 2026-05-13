#!/usr/bin/env bash
# context-audit.sh — Audita el presupuesto de contexto del WP activo por fase
# Uso: bash .claude/scripts/context-audit.sh [--verbose]

set -euo pipefail

WP_DIR=".thyrox/context/work"
VERBOSE="${1:-}"

# Colores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

# Budget por cajón (tokens aproximados)
declare -A BUDGETS=(
  ["discover"]=5000
  ["measure"]=3000
  ["analyze"]=20000
  ["constraints"]=5000
  ["strategy"]=8000
  ["plan"]=5000
  ["design"]=10000
  ["plan-execution"]=8000
  ["pilot"]=5000
  ["execute"]=5000
  ["track"]=5000
  ["standardize"]=3000
)

# Chars-to-tokens ratio aproximado
CHARS_PER_TOKEN=4

# WP activo
ACTIVE_WP=$(ls -t "$WP_DIR" 2>/dev/null | head -1)
if [ -z "$ACTIVE_WP" ]; then
  echo -e "${YELLOW}No hay work package activo en $WP_DIR${NC}"
  exit 0
fi

WP_PATH="$WP_DIR/$ACTIVE_WP"
echo -e "${CYAN}=== Context Audit: $ACTIVE_WP ===${NC}"
echo ""

TOTAL_TOKENS=0
WARNINGS=0

# Auditar cada cajón
for CAJON in discover measure analyze constraints strategy plan design plan-execution pilot execute track standardize; do
  CAJON_PATH="$WP_PATH/$CAJON"

  if [ ! -d "$CAJON_PATH" ]; then
    [ "$VERBOSE" == "--verbose" ] && echo -e "  ${NC}$CAJON/${NC}: (vacío)"
    continue
  fi

  # Calcular tamaño total del cajón
  TOTAL_CHARS=$(find "$CAJON_PATH" -name "*.md" -exec wc -c {} + 2>/dev/null | tail -1 | awk '{print $1}')
  TOTAL_CHARS=${TOTAL_CHARS:-0}
  TOKENS=$((TOTAL_CHARS / CHARS_PER_TOKEN))
  TOTAL_TOKENS=$((TOTAL_TOKENS + TOKENS))

  BUDGET=${BUDGETS[$CAJON]:-5000}
  FILE_COUNT=$(find "$CAJON_PATH" -name "*.md" | wc -l)

  if [ "$TOKENS" -gt "$BUDGET" ]; then
    echo -e "  ${RED}⚠ $CAJON/${NC}: ${TOKENS}t / ${BUDGET}t budget — ${RED}EXCEDE${NC} (${FILE_COUNT} archivos)"
    WARNINGS=$((WARNINGS + 1))
  elif [ "$TOKENS" -gt $((BUDGET * 80 / 100)) ]; then
    echo -e "  ${YELLOW}~ $CAJON/${NC}: ${TOKENS}t / ${BUDGET}t budget — ${YELLOW}CERCA del límite${NC} (${FILE_COUNT} archivos)"
  else
    echo -e "  ${GREEN}✓ $CAJON/${NC}: ${TOKENS}t / ${BUDGET}t budget (${FILE_COUNT} archivos)"
  fi
done

# Artefactos raíz
ROOT_CHARS=$(find "$WP_PATH" -maxdepth 1 -name "*.md" -exec wc -c {} + 2>/dev/null | tail -1 | awk '{print $1}')
ROOT_CHARS=${ROOT_CHARS:-0}
ROOT_TOKENS=$((ROOT_CHARS / CHARS_PER_TOKEN))
TOTAL_TOKENS=$((TOTAL_TOKENS + ROOT_TOKENS))
ROOT_COUNT=$(find "$WP_PATH" -maxdepth 1 -name "*.md" | wc -l)
echo -e "  ${GREEN}✓ raíz/${NC}: ${ROOT_TOKENS}t (${ROOT_COUNT} artefactos: risk-register, exit-conditions)"

echo ""
echo -e "${CYAN}Total WP: ${TOTAL_TOKENS}t / 200000t contexto disponible ($(( TOTAL_TOKENS * 100 / 200000 ))%)${NC}"

if [ "$WARNINGS" -gt 0 ]; then
  echo -e "${RED}⚠ $WARNINGS cajón(es) exceden presupuesto — considerar sintetizar o resumir${NC}"
  exit 1
else
  echo -e "${GREEN}✓ Presupuesto de contexto OK${NC}"
  exit 0
fi

#!/usr/bin/env bash
# count-requirements.sh — Count requirements by state in a traceability matrix markdown file.
#
# Usage:
#   ./count-requirements.sh <traceability_file> [--summary]
#
# Arguments:
#   traceability_file   Path to the requirements traceability matrix (.md file)
#   --summary           Print only the totals table (suppress per-state detail lines)
#
# States detected (RTM lifecycle):
#   Propuesto, En análisis, Aprobado, Rechazado, Diferido,
#   Implementando, Implementado, En prueba, Verificado, Obsoleto
#
# Also detects status icons: ✅ ⏳ ❌ 🔵 🔄 ⚠️
#
# Exit codes:
#   0 — file parsed successfully
#   1 — file not found or invalid

set -euo pipefail

RTM_FILE="${1:-}"
SUMMARY_ONLY=false
[[ "${2:-}" == "--summary" ]] && SUMMARY_ONLY=true

if [[ -z "$RTM_FILE" ]]; then
    echo "Usage: $0 <traceability_file> [--summary]" >&2
    echo "  traceability_file: path to RTM markdown file" >&2
    exit 1
fi

if [[ ! -f "$RTM_FILE" ]]; then
    echo "ERROR: File not found: $RTM_FILE" >&2
    exit 1
fi

# ─── Count functions ─────────────────────────────────────────────────────────

count_state() {
    local pattern="$1"
    grep -ciE "$pattern" "$RTM_FILE" 2>/dev/null || echo "0"
}

count_req_ids() {
    # Count unique REQ-NNN or RF-NNN or RNF-NNN entries
    grep -oE "(REQ|RF|RNF|US|UC|R)-[0-9]+" "$RTM_FILE" 2>/dev/null | sort -u | wc -l | tr -d ' '
}

# ─── Header ─────────────────────────────────────────────────────────────────

echo ""
echo "============================================================"
echo "  Requirements Count by State — RTM Analysis"
echo "============================================================"
echo "  File: $RTM_FILE"
echo ""

# ─── State counts ────────────────────────────────────────────────────────────

# Text-based states (case-insensitive)
N_PROPUESTO=$(count_state "Propuesto|Proposed")
N_ANALISIS=$(count_state "En an[aá]lisis|In analysis|Under review")
N_APROBADO=$(count_state "Aprobado|Approved")
N_RECHAZADO=$(count_state "Rechazado|Rejected")
N_DIFERIDO=$(count_state "Diferido|Deferred|Backlog")
N_IMPLEMENTANDO=$(count_state "Implementando|In progress|In development")
N_IMPLEMENTADO=$(count_state "Implementado[^s]|Implemented[^s]|✅.*Implementado|Implementado.*✅")
N_EN_PRUEBA=$(count_state "En prueba|In testing|Under test")
N_VERIFICADO=$(count_state "Verificado|Verified|Validated")
N_OBSOLETO=$(count_state "Obsoleto|Obsolete|Deprecated|Cancelled")

# Icon-based detection (may overlap with text — used for cross-check)
N_CHECK=$(count_state "✅")
N_PENDING=$(count_state "⏳")
N_CROSS=$(count_state "❌")
N_BLUE=$(count_state "🔵")
N_CYCLE=$(count_state "🔄")
N_WARN=$(count_state "⚠️")

# Unique requirement IDs
TOTAL_IDS=$(count_req_ids)

# ─── Output ─────────────────────────────────────────────────────────────────

if [[ "$SUMMARY_ONLY" == "false" ]]; then
    echo "  Text-based state detection:"
    echo ""
    printf "  %-20s %5s\n" "State" "Count"
    printf "  %-20s %5s\n" "--------------------" "-----"
    printf "  %-20s %5s\n" "Propuesto"      "$N_PROPUESTO"
    printf "  %-20s %5s\n" "En análisis"    "$N_ANALISIS"
    printf "  %-20s %5s\n" "Aprobado"       "$N_APROBADO"
    printf "  %-20s %5s\n" "Rechazado"      "$N_RECHAZADO"
    printf "  %-20s %5s\n" "Diferido"       "$N_DIFERIDO"
    printf "  %-20s %5s\n" "Implementando"  "$N_IMPLEMENTANDO"
    printf "  %-20s %5s\n" "Implementado"   "$N_IMPLEMENTADO"
    printf "  %-20s %5s\n" "En prueba"      "$N_EN_PRUEBA"
    printf "  %-20s %5s\n" "Verificado"     "$N_VERIFICADO"
    printf "  %-20s %5s\n" "Obsoleto"       "$N_OBSOLETO"
    echo ""
    echo "  Icon-based counts (cross-check):"
    printf "  %-20s %5s\n" "✅ (verified/done)"  "$N_CHECK"
    printf "  %-20s %5s\n" "⏳ (pending)"        "$N_PENDING"
    printf "  %-20s %5s\n" "❌ (rejected)"       "$N_CROSS"
    printf "  %-20s %5s\n" "🔵 (deferred)"       "$N_BLUE"
    printf "  %-20s %5s\n" "🔄 (in progress)"    "$N_CYCLE"
    printf "  %-20s %5s\n" "⚠️  (at risk)"       "$N_WARN"
    echo ""
fi

# ─── Totals and coverage ────────────────────────────────────────────────────

ACTIVE=$(( N_APROBADO + N_IMPLEMENTANDO + N_IMPLEMENTADO + N_EN_PRUEBA + N_VERIFICADO ))
CLOSED=$(( N_RECHAZADO + N_OBSOLETO ))
IN_FLIGHT=$(( N_PROPUESTO + N_ANALISIS + N_DIFERIDO ))

echo "------------------------------------------------------------"
echo "  Summary"
echo "------------------------------------------------------------"
printf "  %-30s %5s\n" "Unique Requirement IDs found"  "$TOTAL_IDS"
printf "  %-30s %5s\n" "Active (Approved→Verified)"    "$ACTIVE"
printf "  %-30s %5s\n" "In-flight (Proposed/Analysis)" "$IN_FLIGHT"
printf "  %-30s %5s\n" "Closed (Rejected/Obsolete)"    "$CLOSED"
echo ""

# ─── Coverage metrics ───────────────────────────────────────────────────────

if [[ "$TOTAL_IDS" -gt 0 ]]; then
    VERIFIED_PCT=$(( N_VERIFICADO * 100 / TOTAL_IDS ))
    IMPL_PCT=$(( N_IMPLEMENTADO * 100 / TOTAL_IDS ))
    ACTIVE_PCT=$(( ACTIVE * 100 / TOTAL_IDS ))
    echo "  Coverage (based on unique IDs: $TOTAL_IDS):"
    printf "  %-30s %4s%%\n" "  Verified / Done"         "$VERIFIED_PCT"
    printf "  %-30s %4s%%\n" "  Implemented (not verified)" "$IMPL_PCT"
    printf "  %-30s %4s%%\n" "  Active total"            "$ACTIVE_PCT"
    echo ""
fi

# ─── Health signals ─────────────────────────────────────────────────────────

echo "  Health signals:"

# Signal 1: anything still Propuesto/En análisis during implementation?
if [[ "$N_PROPUESTO" -gt 5 ]]; then
    echo "  ⚠️  $N_PROPUESTO requirements still in Propuesto — baseline may not be stable"
fi

# Signal 2: Verificado coverage
if [[ "$TOTAL_IDS" -gt 0 && "$VERIFIED_PCT" -lt 50 && "$N_IMPLEMENTADO" -gt 0 ]]; then
    echo "  ⚠️  Only $VERIFIED_PCT% verified — testing coverage may be insufficient"
fi

# Signal 3: High Diferido rate
if [[ "$N_DIFERIDO" -gt 3 ]]; then
    echo "  ⚠️  $N_DIFERIDO requirements deferred — review backlog at next release planning"
fi

# Signal 4: No Verificado at all
if [[ "$N_VERIFICADO" -eq 0 && "$N_IMPLEMENTADO" -gt 0 ]]; then
    echo "  ⚠️  0 Verificado but $N_IMPLEMENTADO Implementado — test phase not recorded in RTM"
fi

# All clear?
if [[ "$N_PROPUESTO" -le 5 && "$N_DIFERIDO" -le 3 ]] && \
   { [[ "$TOTAL_IDS" -eq 0 ]] || [[ "$VERIFIED_PCT" -ge 50 ]] || [[ "$N_IMPLEMENTADO" -eq 0 ]]; } && \
   { [[ "$N_VERIFICADO" -gt 0 ]] || [[ "$N_IMPLEMENTADO" -eq 0 ]]; }; then
    echo "  ✅ No health issues detected"
fi

echo ""
echo "============================================================"
echo ""

exit 0

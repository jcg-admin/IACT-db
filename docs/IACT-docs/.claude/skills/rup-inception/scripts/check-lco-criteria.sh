#!/usr/bin/env bash
# check-lco-criteria.sh — Verify LCO milestone readiness in a THYROX work package.
#
# Usage:
#   ./check-lco-criteria.sh <wp_dir>
#
# Arguments:
#   wp_dir   Path to the work package directory (e.g. .thyrox/context/work/YYYY-MM-DD-HH-MM-SS-name/)
#
# LCO Criteria checked (all 5 must pass):
#   1. Vision Document approved (rup-inception.md exists with sign-off indicator)
#   2. Business Case present and contains ROI or cost data
#   3. Risk List with at least 3 risks identified
#   4. Use Case Model with at least 1 UC entry
#   5. Project plan with phase milestones (LCA, IOC, PD targets)
#
# Exit codes:
#   0 — all LCO criteria met
#   1 — one or more criteria missing

set -euo pipefail

WP_DIR="${1:-}"

if [[ -z "$WP_DIR" ]]; then
    echo "Usage: $0 <wp_dir>" >&2
    echo "  wp_dir: path to work package directory" >&2
    exit 1
fi

if [[ ! -d "$WP_DIR" ]]; then
    echo "ERROR: Directory not found: $WP_DIR" >&2
    exit 1
fi

# ─── Helpers ────────────────────────────────────────────────────────────────

PASS=0
FAIL=0

check() {
    local label="$1"
    local result="$2"   # "ok" or "fail"
    local detail="${3:-}"

    if [[ "$result" == "ok" ]]; then
        printf "  ✅ PASS  %s\n" "$label"
        (( PASS++ )) || true
    else
        printf "  ❌ FAIL  %s\n" "$label"
        [[ -n "$detail" ]] && printf "         → %s\n" "$detail"
        (( FAIL++ )) || true
    fi
}

find_artifact() {
    # Find a file matching glob pattern in wp dir; print path or empty
    local pattern="$1"
    find "$WP_DIR" -maxdepth 2 -name "$pattern" 2>/dev/null | head -1
}

count_pattern_in_file() {
    local file="$1"
    local pattern="$2"
    grep -c "$pattern" "$file" 2>/dev/null || echo "0"
}

# ─── Header ─────────────────────────────────────────────────────────────────

echo ""
echo "============================================================"
echo "  RUP LCO Milestone Readiness Check"
echo "============================================================"
echo "  Work Package: $WP_DIR"
echo ""

# ─── Criterion 1: Vision Document (rup-inception.md exists) ─────────────────

INCEPTION_FILE=$(find_artifact "rup-inception.md")

if [[ -n "$INCEPTION_FILE" ]]; then
    # Check for approval indicators: "aprobado", "approved", sign-off, LCO keyword
    if grep -qiE "(aprobado|approved|sign.?off|LCO|stakeholders.*valid)" "$INCEPTION_FILE" 2>/dev/null; then
        check "Vision Document present and contains approval indicator" "ok"
    else
        check "Vision Document present and contains approval indicator" "fail" \
            "rup-inception.md found but no approval/LCO keyword detected — add stakeholder sign-off"
    fi
else
    check "Vision Document present (rup-inception.md)" "fail" \
        "File not found in $WP_DIR — create using rup-inception-template.md"
fi

# ─── Criterion 2: Business Case with ROI or cost data ───────────────────────

if [[ -n "$INCEPTION_FILE" ]]; then
    # Look for ROI indicators: ROI, cost, $, €, budget, inversión, beneficio, payback
    ROI_MATCHES=$(grep -ciE "(ROI|costo|cost|beneficio|budget|inversion|inversión|payback|\\\$|€)" \
        "$INCEPTION_FILE" 2>/dev/null || echo "0")
    if [[ "$ROI_MATCHES" -ge 2 ]]; then
        check "Business Case contains cost/ROI data (≥2 financial references)" "ok"
    else
        check "Business Case contains cost/ROI data (≥2 financial references)" "fail" \
            "Found $ROI_MATCHES financial reference(s) — Business Case needs quantified ROI or cost of problem"
    fi
else
    check "Business Case contains cost/ROI data" "fail" \
        "Cannot check — rup-inception.md not found"
fi

# ─── Criterion 3: Risk List with ≥3 risks ───────────────────────────────────

if [[ -n "$INCEPTION_FILE" ]]; then
    # Count risk entries: lines with R-00N pattern or "| R" table rows
    RISK_COUNT=$(grep -cE "R-[0-9]{3}|^\|.*[Rr]isk|^\|.*[Rr]iesgo|\bR-0[0-9][0-9]\b" \
        "$INCEPTION_FILE" 2>/dev/null || echo "0")
    if [[ "$RISK_COUNT" -ge 3 ]]; then
        check "Risk List with ≥3 risks identified (Risk IDs found: $RISK_COUNT)" "ok"
    else
        check "Risk List with ≥3 risks identified" "fail" \
            "Found $RISK_COUNT risk entry/entries — RUP requires minimum 3 risks in Inception"
    fi
else
    check "Risk List with ≥3 risks identified" "fail" \
        "Cannot check — rup-inception.md not found"
fi

# ─── Criterion 4: Use Case Model with ≥1 UC entry ───────────────────────────

if [[ -n "$INCEPTION_FILE" ]]; then
    UC_COUNT=$(grep -cE "UC-[0-9]+|Use Case [0-9]|Caso de Uso|^\|.*UC[- ][0-9]" \
        "$INCEPTION_FILE" 2>/dev/null || echo "0")
    if [[ "$UC_COUNT" -ge 1 ]]; then
        check "Use Case Model with ≥1 UC entry (UC entries found: $UC_COUNT)" "ok"
    else
        check "Use Case Model with ≥1 UC entry" "fail" \
            "No UC entries found — Inception requires ≥10% Use Case Model (critical UCs named)"
    fi
else
    check "Use Case Model with ≥1 UC entry" "fail" \
        "Cannot check — rup-inception.md not found"
fi

# ─── Criterion 5: Project plan with phase milestones ────────────────────────

if [[ -n "$INCEPTION_FILE" ]]; then
    # LCA, IOC, PD are the three post-Inception milestones
    MILESTONE_COUNT=$(grep -cE "\b(LCA|IOC|PD)\b" "$INCEPTION_FILE" 2>/dev/null || echo "0")
    if [[ "$MILESTONE_COUNT" -ge 2 ]]; then
        check "Project plan with phase milestones (LCA/IOC/PD — found: $MILESTONE_COUNT)" "ok"
    else
        check "Project plan with phase milestones (LCA/IOC/PD)" "fail" \
            "Found $MILESTONE_COUNT milestone reference(s) — plan needs LCA, IOC and PD target dates"
    fi
else
    check "Project plan with phase milestones" "fail" \
        "Cannot check — rup-inception.md not found"
fi

# ─── Summary ────────────────────────────────────────────────────────────────

TOTAL=$(( PASS + FAIL ))
echo ""
echo "------------------------------------------------------------"
echo "  Results: $PASS/$TOTAL criteria met"
echo ""

if [[ "$FAIL" -eq 0 ]]; then
    echo "  🎯 LCO READY — All criteria satisfied."
    echo "  Proceed to rup:elaboration."
    EXITCODE=0
else
    echo "  ⚠️  LCO NOT READY — $FAIL criterion/criteria missing."
    echo "  Resolve failures before scheduling the LCO review."
    echo ""
    echo "  Common actions:"
    echo "    • Add stakeholder approval section to rup-inception.md"
    echo "    • Quantify Business Case with ROI/cost numbers"
    echo "    • Expand Risk List to ≥3 risks with R-00N IDs"
    echo "    • Name at least 1 architecturally-significant Use Case"
    echo "    • Add LCA/IOC/PD target dates to the project plan section"
    EXITCODE=1
fi

echo "============================================================"
echo ""

exit $EXITCODE

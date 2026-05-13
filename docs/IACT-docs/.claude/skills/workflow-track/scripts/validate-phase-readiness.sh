#!/usr/bin/env bash
# validate-phase-readiness.sh
# Verifica que los artefactos requeridos existen para avanzar a una fase.
# Retorna exit 0 si ready, exit 1 si falta algo.
#
# Uso:
#   ./validate-phase-readiness.sh <phase-number> [wp-dir]
#   ./validate-phase-readiness.sh 2                          # ¿Listo para Phase 2?
#   ./validate-phase-readiness.sh 11 context/work/2026-04-01-18-39-56-mi-feature/

set -euo pipefail

PHASE="${1:-}"
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || echo .)"
WP_DIR="${2:-}"

if [ -z "$PHASE" ]; then
    echo "Usage: validate-phase-readiness.sh <phase-number> [wp-dir]"
    echo "Phases: 1=DISCOVER, 2=BASELINE, 3=DIAGNOSE, 4=CONSTRAINTS, 5=STRATEGY,"
    echo "        6=SCOPE, 7=DESIGN/SPECIFY, 8=PLAN_EXECUTION, 9=PILOT/VALIDATE,"
    echo "        10=IMPLEMENT, 11=TRACK/EVALUATE, 12=STANDARDIZE"
    exit 1
fi

# Auto-detect latest work package if not provided
if [ -z "$WP_DIR" ]; then
    WP_DIR=$(find "$REPO_ROOT/.thyrox/context/work" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | sort -r | head -1)
fi

BOLD='\033[1m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

PASS=0
FAIL=0

check() {
    local desc="$1"
    local path="$2"

    if [ -e "$path" ]; then
        echo -e "  [OK] $desc"
        PASS=$((PASS + 1))
    else
        echo -e "  [FAIL] $desc — ${RED}MISSING: $path${NC}"
        FAIL=$((FAIL + 1))
    fi
}

check_glob() {
    local desc="$1"
    local dir="$2"
    local pattern="$3"

    local match
    match=$(find "$dir" -maxdepth 1 -name "$pattern" 2>/dev/null | head -1)
    if [ -n "$match" ]; then
        echo -e "  [OK] $desc ($match)"
        PASS=$((PASS + 1))
    else
        echo -e "  [FAIL] $desc — ${RED}no file matching '$pattern' in $dir${NC}"
        FAIL=$((FAIL + 1))
    fi
}

check_no_pattern() {
    local desc="$1"
    local dir="$2"
    local pattern="$3"

    if grep -qlr "$pattern" "$dir" 2>/dev/null; then
        local count
        count=$(grep -rl "$pattern" "$dir" 2>/dev/null | wc -l | tr -d ' ')
        echo -e "  [FAIL] $desc — ${RED}$count files with '$pattern'${NC}"
        FAIL=$((FAIL + 1))
    else
        echo -e "  [OK] $desc"
        PASS=$((PASS + 1))
    fi
}

check_content() {
    local desc="$1"
    local path="$2"
    local pattern="$3"

    if [ -e "$path" ] && grep -qi "$pattern" "$path" 2>/dev/null; then
        echo -e "  [OK] $desc"
        PASS=$((PASS + 1))
    else
        echo -e "  [FAIL] $desc — ${RED}pattern '$pattern' not found in $path${NC}"
        FAIL=$((FAIL + 1))
    fi
}

PHASE_NAMES=("" "DISCOVER" "BASELINE" "DIAGNOSE" "CONSTRAINTS" "STRATEGY" "SCOPE" "DESIGN/SPECIFY" "PLAN_EXECUTION" "PILOT/VALIDATE" "IMPLEMENT" "TRACK/EVALUATE" "STANDARDIZE")
echo -e "${BOLD}Checking readiness for Phase $PHASE: ${PHASE_NAMES[$PHASE]:-UNKNOWN}${NC}"
echo -e "Work package: ${WP_DIR:-none detected}"
echo ""

case "$PHASE" in
    1)
        echo "Phase 1: DISCOVER — analysis document + risk register"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-analysis.md" "$WP_DIR/discover" "*-analysis.md"
            check_glob "*-risk-register.md" "$WP_DIR" "*-risk-register.md"
            if [ -d "$WP_DIR/discover" ]; then
                check_no_pattern "No [NEEDS CLARIFICATION] in discover/" "$WP_DIR/discover" "\[NEEDS CLARIFICATION\]"
            fi
        else
            echo -e "  [FAIL] No work package directory found in context/work/"
            FAIL=$((FAIL + 3))
        fi
        ;;
    2)
        echo "Stage 2: BASELINE — baseline document with quantitative data"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-baseline.md" "$WP_DIR/measure" "*-baseline.md"
            local_file=$(find "$WP_DIR/measure" -maxdepth 1 -name "*-baseline.md" 2>/dev/null | head -1)
            if [ -n "$local_file" ]; then
                check_content "Métrica de éxito documentada" "$local_file" "mejorará\|target\|baseline\|métrica"
                check_content "Método de medición documentado" "$local_file" "medido por\|método\|cómo\|verificar"
            fi
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 3))
        fi
        ;;
    3)
        echo "Stage 3: DIAGNOSE — domain analysis with synthesis"
        if [ -n "$WP_DIR" ]; then
            if [ -d "$WP_DIR/analyze" ]; then
                local count
                count=$(find "$WP_DIR/analyze" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
                if [ "$count" -gt 0 ]; then
                    echo -e "  [OK] analyze/ has $count document(s)"
                    PASS=$((PASS + 1))
                else
                    echo -e "  [FAIL] analyze/ exists but has no .md files"
                    FAIL=$((FAIL + 1))
                fi
            else
                echo -e "  [FAIL] analyze/ directory missing in WP"
                FAIL=$((FAIL + 1))
            fi
            check_glob "*-analyze-synthesis.md" "$WP_DIR/analyze" "*-analyze-synthesis.md"
            check_glob "*-risk-register.md updated" "$WP_DIR" "*-risk-register.md"
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 3))
        fi
        ;;
    4)
        echo "Phase 4: CONSTRAINTS — constraints document (HARD vs SOFT)"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-constraints.md" "$WP_DIR/constraints" "*-constraints.md"
            local_file=$(find "$WP_DIR/constraints" -maxdepth 1 -name "*-constraints.md" 2>/dev/null | head -1)
            if [ -n "$local_file" ]; then
                check_content "HARD constraints documented" "$local_file" "HARD\|hard\|dura"
                check_content "SOFT constraints documented" "$local_file" "SOFT\|soft\|blanda"
            fi
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 3))
        fi
        ;;
    5)
        echo "Phase 5: STRATEGY — solution strategy with research and decisions"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-solution-strategy.md" "$WP_DIR/strategy" "*-solution-strategy.md"
            local_file=$(find "$WP_DIR/strategy" -maxdepth 1 -name "*-solution-strategy.md" 2>/dev/null | head -1)
            if [ -n "$local_file" ]; then
                check_content "Key Ideas documented" "$local_file" "[Kk]ey [Ii]dea\|ideas clave"
                check_content "Research documented" "$local_file" "research\|Research\|alternativ\|unknown"
                check_content "Decisions documented" "$local_file" "[Dd]ecision\|decisión"
            fi
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 4))
        fi
        ;;
    6)
        echo "Stage 6: SCOPE — scope approved + ROADMAP updated"
        check "ROADMAP.md" "$REPO_ROOT/ROADMAP.md"
        if [ -n "$WP_DIR" ]; then
            WP_NAME=$(basename "$WP_DIR")
            check_content "ROADMAP references work package" "$REPO_ROOT/ROADMAP.md" "$WP_NAME"
            check_glob "*-plan.md exists" "$WP_DIR/plan" "*-plan.md"
            local_plan=$(find "$WP_DIR/plan" -maxdepth 1 -name "*-plan.md" 2>/dev/null | head -1)
            if [ -n "$local_plan" ]; then
                check_content "Scope aprobado [x] en plan.md" "$local_plan" "\[x\].*[Aa]probado\|[Aa]probado.*[0-9]\{4\}"
            fi
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 3))
        fi
        ;;
    7)
        echo "Phase 7: DESIGN/SPECIFY — requirements spec without [NEEDS CLARIFICATION]"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-requirements-spec.md" "$WP_DIR/design" "*-requirements-spec.md"
            check_no_pattern "No [NEEDS CLARIFICATION] markers" "$WP_DIR/design" "\[NEEDS CLARIFICATION\]"
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 2))
        fi
        ;;
    8)
        echo "Phase 8: PLAN EXECUTION — task plan with IDs and checkboxes"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-task-plan.md" "$WP_DIR/plan-execution" "*-task-plan.md"
            local_file=$(find "$WP_DIR/plan-execution" -maxdepth 1 -name "*-task-plan.md" 2>/dev/null | head -1)
            if [ -n "$local_file" ]; then
                check_content "Tasks have IDs [T-NNN]" "$local_file" "\[T-[0-9]"
                check_content "Tasks have checkboxes" "$local_file" "^\- \["
                check_content "DAG documented (mermaid)" "$local_file" "mermaid\|flowchart\|graph"
            fi
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 4))
        fi
        ;;
    9)
        echo "Phase 9: PILOT/VALIDATE — pilot report with GO/NO-GO decision"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-pilot-report.md" "$WP_DIR/pilot" "*-pilot-report.md"
            local_file=$(find "$WP_DIR/pilot" -maxdepth 1 -name "*-pilot-report.md" 2>/dev/null | head -1)
            if [ -n "$local_file" ]; then
                check_content "GO/NO-GO decision documented" "$local_file" "GO\|NO-GO\|no-go"
            fi
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 2))
        fi
        ;;
    10)
        echo "Stage 10: IMPLEMENT — all tasks completed"
        if [ -n "$WP_DIR" ]; then
            local_file=$(find "$WP_DIR/plan-execution" -maxdepth 1 -name "*-task-plan.md" 2>/dev/null | head -1)
            if [ -n "$local_file" ]; then
                TOTAL=$(grep -c '^\- \[' "$local_file" 2>/dev/null || echo 0)
                DONE=$(grep -c '^\- \[x\]' "$local_file" 2>/dev/null || echo 0)
                if [ "$TOTAL" -gt 0 ] && [ "$TOTAL" -eq "$DONE" ]; then
                    echo -e "  [OK] All tasks complete ($DONE/$TOTAL)"
                    PASS=$((PASS + 1))
                else
                    echo -e "  [FAIL] Tasks incomplete ($DONE/$TOTAL)"
                    FAIL=$((FAIL + 1))
                fi
            else
                echo -e "  [FAIL] No *-task-plan.md found in plan-execution/"
                FAIL=$((FAIL + 1))
            fi
            check_glob "*-execution-log.md" "$WP_DIR/execute" "*-execution-log.md"
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 2))
        fi
        check_content "ROADMAP has completed tasks" "$REPO_ROOT/ROADMAP.md" "\[x\]"
        ;;
    11)
        echo "Phase 11: TRACK/EVALUATE — lessons learned + changelog"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-lessons-learned.md" "$WP_DIR/track" "*-lessons-learned.md"
            check_glob "*-changelog.md" "$WP_DIR/track" "*-changelog.md"
            check_glob "*-risk-register.md updated" "$WP_DIR" "*-risk-register.md"
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 3))
        fi
        ;;
    12)
        echo "Phase 12: STANDARDIZE — patterns document + WP closure"
        if [ -n "$WP_DIR" ]; then
            check_glob "*-patterns.md" "$WP_DIR/standardize" "*-patterns.md"
            check_content "ROADMAP has WP marked complete" "$REPO_ROOT/ROADMAP.md" "\[x\]"
        else
            echo -e "  [FAIL] No work package directory found"
            FAIL=$((FAIL + 2))
        fi
        ;;
    *)
        echo "Invalid phase: $PHASE (use 1-12)"
        exit 1
        ;;
esac

echo ""
echo -e "${BOLD}Result: ${GREEN}$PASS passed${NC}, ${RED}$FAIL failed${NC}"

if [ "$FAIL" -eq 0 ]; then
    echo -e "${GREEN}PASS: Ready for Phase $PHASE${NC}"
    exit 0
else
    echo -e "${RED}FAIL: Not ready for Phase $PHASE — $FAIL items missing${NC}"
    exit 1
fi

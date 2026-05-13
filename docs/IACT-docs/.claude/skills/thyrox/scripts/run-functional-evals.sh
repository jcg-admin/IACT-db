#!/usr/bin/env bash
# run-functional-evals.sh
# Ejecuta los 3 functional evals en workspace simulado (aislado del repo real).
#
# Uso:
#   bash .claude/skills/thyrox/scripts/run-functional-evals.sh
#   bash .claude/skills/thyrox/scripts/run-functional-evals.sh FE-02  # solo uno

set -euo pipefail

WORKSPACE="/tmp/thyrox-functional-eval-workspace"
PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../../.." && cd .. && pwd)"
SKILL_DIR="${PROJECT_ROOT}/.claude/skills/thyrox"
SPECIFIC_EVAL="${1:-all}"

TOTAL_PASS=0
TOTAL_FAIL=0
TOTAL_EVALS=0

setup_workspace() {
    local eval_id="$1"
    local dir="${WORKSPACE}/${eval_id}"
    rm -rf "$dir"
    mkdir -p "$dir/.claude/skills/thyrox"
    cp "$SKILL_DIR/SKILL.md" "$dir/.claude/skills/thyrox/"
    cp "${PROJECT_ROOT}/.claude/CLAUDE.md" "$dir/.claude/"
    mkdir -p "$dir/.thyrox/context"
    echo "$dir"
}

check_expectation() {
    local result="$1"
    local pattern="$2"
    local description="$3"

    if echo "$result" | grep -qi "$pattern"; then
        echo "    [OK] $description"
        TOTAL_PASS=$((TOTAL_PASS + 1))
        return 0
    else
        echo "    [ERROR] $description"
        TOTAL_FAIL=$((TOTAL_FAIL + 1))
        return 1
    fi
}

check_negative() {
    local result="$1"
    local pattern="$2"
    local description="$3"

    if echo "$result" | grep -qi "$pattern"; then
        echo "    [ERROR] $description (found when shouldn't)"
        TOTAL_FAIL=$((TOTAL_FAIL + 1))
        return 1
    else
        echo "    [OK] $description"
        TOTAL_PASS=$((TOTAL_PASS + 1))
        return 0
    fi
}

# ===== FE-01: Nuevo proyecto — debe analizar primero =====
run_FE01() {
    local dir
    dir=$(setup_workspace "FE-01")

    # Simular un proyecto vacío (nuevo) — solo SKILL + CLAUDE.md
    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
Proyecto nuevo. Sin trabajo previo.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: true
last_session: null
current_work: null
phase: null
blockers: []
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== FE-01: Nuevo proyecto — analizar primero ==="

    local result
    result=$(cd "$dir" && claude -p "Quiero crear un sistema de inventario para una tienda pequeña. Manejaría productos, categorías, stock, y alertas cuando un producto está por agotarse. La tienda tiene 2 empleados y unos 500 productos. Ayúdame a empezar." 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "analiz\|entender\|investigar\|Phase 1\|ANALYZE\|antes de\|primero" "Prioriza entender antes de planificar" || true
    check_expectation "$result" "document\|registr\|organiz\|directorio\|carpeta\|work\|crear.*estructura\|guardar" "Propone documentar/organizar los hallazgos" || true
    check_expectation "$result" "?\|requisit\|usuario\|limitac\|stakeholder\|constraint\|pregunt\|aclarar\|definir\|plataforma\|stack\|acceso" "Hace preguntas para entender el problema" || true
    check_negative "$result" "function \|class \|import \|def \|const \|npm install\|pip install" "NO genera código de implementación" || true
    check_negative "$result" "aquí.*código\|implementación\|ya.*puedes.*usar\|listo.*para.*producción" "NO salta directo a implementar" || true
}

# ===== FE-02: Status check — datos reales del proyecto =====
run_FE02() {
    local dir
    dir=$(setup_workspace "FE-02")

    # Simular proyecto con progreso real
    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
API de pagos en desarrollo. Phase 6 en progreso.

## Completado
- Auth system (login, registro, JWT)
- CRUD de productos
- Carrito de compras

## Pendiente
1. Integración Stripe (en progreso)
2. Webhooks de Stripe
3. Tests de integración
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: true
last_session: 2026-03-27
current_work: work/2026-03-25-140000-pagos-stripe/
phase: execute
blockers: []
EOF

    mkdir -p "$dir/.thyrox/context/work/2026-03-25-140000-pagos-stripe"
    cat > "$dir/.thyrox/context/work/2026-03-25-140000-pagos-stripe/plan.md" << 'EOF'
# Plan: Integración Stripe

- [x] [T-001] Configurar cuenta Stripe y API keys (R-01)
- [x] [T-002] Crear endpoint POST /payments/create-intent (R-02)
- [x] [T-003] Implementar checkout flow frontend (R-02)
- [ ] [T-004] Webhooks para confirmar pagos (R-03)
- [ ] [T-005] Manejo de errores y reintentos (R-04)
- [ ] [T-006] Tests de integración con Stripe test mode (R-05)
EOF

    cat > "$dir/ROADMAP.md" << 'EOF'
# ROADMAP

## FASE 1: Base — 100% ok
- [x] Auth system (2026-03-10)
- [x] CRUD productos (2026-03-15)
- [x] Carrito (2026-03-20)

## FASE 2: Pagos — 50%
- [x] Setup Stripe (2026-03-25)
- [x] Checkout flow (2026-03-26)
- [ ] Webhooks
- [ ] Tests
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== FE-02: Status check con contexto simulado ==="

    local result
    result=$(cd "$dir" && claude -p "¿En qué punto estamos del proyecto? ¿Qué debería hacer ahora?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "Stripe\|pago\|payment\|FASE 2\|checkout\|webhook" "Datos específicos del proyecto (Stripe/pagos)" || true
    check_expectation "$result" "T-004\|webhook\|3.*6\|50%\|progreso\|completad" "Basado en datos reales del plan" || true
    check_expectation "$result" "siguiente\|próxim\|debería\|recomend\|ahora\|acción\|T-004\|webhook" "Sugiere acción concreta" || true
    check_expectation "$result" "fase\|phase\|SDLC\|EXECUTE\|execute\|ejecuci" "Identifica fase SDLC (execute)" || true
}

# ===== FE-03: Descomposición directa =====
run_FE03() {
    local dir
    dir=$(setup_workspace "FE-03")

    # Simular proyecto de app donde i18n tiene sentido
    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
App de e-commerce móvil. 30 pantallas en React Native.
Textos hardcodeados en español. Se necesita soporte multi-idioma.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: true
last_session: 2026-03-27
current_work: null
phase: null
blockers: []
EOF

    # Simular que hay código de app (no solo docs)
    mkdir -p "$dir/src/screens"
    echo "// LoginScreen.tsx" > "$dir/src/screens/LoginScreen.tsx"
    echo "// HomeScreen.tsx" > "$dir/src/screens/HomeScreen.tsx"
    echo "// ProductScreen.tsx" > "$dir/src/screens/ProductScreen.tsx"
    echo '{"name": "mi-app", "dependencies": {"react-native": "0.73"}}' > "$dir/package.json"

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== FE-03: Descomposición directa (con contexto de app) ==="

    local result
    result=$(cd "$dir" && claude -p "Necesito agregar soporte multi-idioma a la aplicación. Los textos están hardcodeados en español por todo el código. Hay unas 30 pantallas. Descompón esto en tareas que pueda ir haciendo." 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "\[T-[0-9]\|T-00\|T-01\|\- \[ \].*[0-9]\|\- \[ \]" "Tareas tienen IDs o checkboxes" || true
    check_expectation "$result" "1\.\|primero\|antes\|luego\|después\|orden\|secuenc\|fase\|etapa\|paso\|Fase\|Lote\|Bloque" "Orden lógico de ejecución" || true
    check_expectation "$result" "i18n\|react-i18next\|localiz\|traducción\|locale\|string\|texto\|idioma" "Tareas específicas del dominio (i18n)" || true
    check_expectation "$result" "30.*pantalla\|pantalla\|screen\|lote\|grupo\|módulo\|bloque" "Considera la escala (30 pantallas) en la descomposición" || true
    check_negative "$result" "no.*tiene.*código\|no.*encontr\|no.*existe.*app\|aclarar.*qué.*proyecto" "NO cuestiona si el proyecto existe" || true
}

# ===== MAIN =====
echo "============================================"
echo " Functional Evals — thyrox (isolated)"
echo "============================================"

if [ "$SPECIFIC_EVAL" = "all" ]; then
    run_FE01
    run_FE02
    run_FE03
else
    case "$SPECIFIC_EVAL" in
        FE-01) run_FE01 ;;
        FE-02) run_FE02 ;;
        FE-03) run_FE03 ;;
        *) echo "Unknown eval: $SPECIFIC_EVAL. Options: FE-01, FE-02, FE-03"; exit 1 ;;
    esac
fi

echo ""
echo "============================================"
echo " Results"
echo "============================================"
echo ""
echo "  Evals run:    ${TOTAL_EVALS}"
echo "  Passed:       ${TOTAL_PASS}"
echo "  Failed:       ${TOTAL_FAIL}"
TOTAL=$((TOTAL_PASS + TOTAL_FAIL))
if [ "$TOTAL" -gt 0 ]; then
    RATE=$(echo "scale=1; $TOTAL_PASS * 100 / $TOTAL" | bc)
    echo "  Pass rate:    ${RATE}%"
fi
echo ""

# Cleanup
rm -rf "$WORKSPACE"
echo "Workspace cleaned."

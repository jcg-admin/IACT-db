#!/usr/bin/env bash
# run-multi-evals.sh
# Ejecuta los 7 evals automatizados de multi-interaction con contexto simulado.
#
# Uso:
#   bash .claude/skills/thyrox/scripts/run-multi-evals.sh
#   bash .claude/skills/thyrox/scripts/run-multi-evals.sh MI-05  # solo uno

set -euo pipefail

WORKSPACE="/tmp/thyrox-eval-workspace"
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

run_eval() {
    local eval_id="$1"
    local prompt="$2"
    local dir
    dir=$(setup_workspace "$eval_id")

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== ${eval_id} ==="
    echo "  Prompt: ${prompt:0:80}..."

    local result
    result=$(cd "$dir" && claude -p "$prompt" 2>/dev/null) || result=""

    if [ -z "$result" ]; then
        echo "    [WARN]  Empty response"
        return
    fi

    echo "  Response: ${result:0:120}..."
    echo "  Checking expectations:"

    echo "$result" > "${dir}/response.txt"
}

# ===== MI-01: Reanudar trabajo =====
run_MI01() {
    local dir
    dir=$(setup_workspace "MI-01")

    mkdir -p "$dir/.thyrox/context/work/2026-03-25-100000-migracion-db"

    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
Dirección: migración de base de datos PostgreSQL a nueva versión.
Phase 6 en progreso. T-002 completado.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: false
last_session: 2026-03-27
current_work: work/2026-03-25-100000-migracion-db/
phase: execute
EOF

    cat > "$dir/.thyrox/context/work/2026-03-25-100000-migracion-db/plan.md" << 'EOF'
# Plan: Migración DB

- [x] [T-001] Backup de datos existentes (R-01)
- [x] [T-002] Crear schema nuevo en PostgreSQL 16 (R-01)
- [ ] [T-003] Migrar tabla usuarios (R-02)
- [ ] [T-004] Migrar tabla productos (R-02)
- [ ] [T-005] Verificar integridad de datos (R-03)
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-01: Reanudar trabajo interrumpido ==="

    local result
    result=$(cd "$dir" && claude -p "Ayer estábamos trabajando en la migración de la base de datos, ¿dónde quedamos?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "focus\|now\|plan\|migración\|migraci" "Lee o menciona archivos de estado" || true
    check_expectation "$result" "migración\|migraci\|base de datos\|PostgreSQL" "Identifica work package de migración" || true
    check_expectation "$result" "T-003\|tabla usuarios\|siguiente\|próxim" "Identifica T-003 como siguiente" || true
    check_negative "$result" "empezar de nuevo\|crear.*nuevo.*proyecto\|desde cero" "NO propone empezar de nuevo" || true
}

# ===== MI-02: Cold boot existente =====
run_MI02() {
    local dir
    dir=$(setup_workspace "MI-02")

    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
5 work packages completados. Proyecto de e-commerce en desarrollo.

## Próximo
Implementar sistema de pagos (Phase 3: PLAN pendiente).
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: true
last_session: 2026-03-20
current_work: null
phase: plan
EOF

    cat > "$dir/ROADMAP.md" << 'EOF'
# ROADMAP

## FASE 1: Base
- [x] Setup proyecto (2026-03-10)
- [x] Auth system (2026-03-15)
- [x] CRUD productos (2026-03-18)

## FASE 2: Pagos
- [ ] Integración Stripe
- [ ] Checkout flow
- [ ] Webhooks
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-02: Cold boot en proyecto existente ==="

    local result
    result=$(cd "$dir" && claude -p "Hola, acabo de abrir el proyecto. ¿En qué estamos?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "work.*package\|completad\|existente\|progreso\|FASE" "Menciona trabajo existente" || true
    check_expectation "$result" "focus\|now\|ROADMAP\|estado" "Lee archivos de estado" || true
    check_negative "$result" "crear.*estructura\|inicializar\|setup.*inicial\|desde cero" "NO propone crear desde cero" || true
    check_expectation "$result" "pago\|Stripe\|FASE 2\|siguiente" "Identifica pagos como próximo" || true
}

# ===== MI-05: Phase 6 interrumpida =====
run_MI05() {
    local dir
    dir=$(setup_workspace "MI-05")

    mkdir -p "$dir/.thyrox/context/work/2026-03-27-090000-auth-system"

    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
Auth system en Phase 6. T-005 completado. Siguiente: T-006 refresh tokens.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: false
last_session: 2026-03-27
current_work: work/2026-03-27-090000-auth-system/
phase: execute
EOF

    cat > "$dir/.thyrox/context/work/2026-03-27-090000-auth-system/plan.md" << 'EOF'
# Plan: Sistema de Autenticación

- [x] [T-001] Setup proyecto base (R-01)
- [x] [T-002] Schema de usuarios en PostgreSQL (R-01)
- [x] [T-003] Endpoint POST /auth/register (R-02)
- [x] [T-004] Endpoint POST /auth/login (R-03)
- [x] [T-005] JWT token generation (R-04)
- [ ] [T-006] Refresh tokens con rotación (R-04)
- [ ] [T-007] Roles y permisos RBAC (R-05)
- [ ] [T-008] Tests de integración (R-06)
- [ ] [T-009] Documentación API (R-07)
- [ ] [T-010] Code review final (R-08)
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-05: Phase 6 interrumpida ==="

    local result
    result=$(cd "$dir" && claude -p "Vengo a seguir con las tareas del sistema de autenticación. ¿Cuál es la siguiente?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "T-006\|refresh\|token.*rotaci" "Identifica T-006 como siguiente" || true
    check_expectation "$result" "T-001.*completad\|5.*completad\|T-005.*completad\|ya.*hecho" "Menciona que T-001-T-005 están hechos" || true
    check_negative "$result" "re-analizar\|volver.*analizar\|descomponer.*nuevo\|Phase 1\|Phase 4" "NO propone re-analizar" || true
    check_expectation "$result" "continu\|siguient\|refresh\|T-006" "Continúa desde donde se quedó" || true
}

# ===== MI-13: Implementación falló =====
run_MI13() {
    local dir
    dir=$(setup_workspace "MI-13")

    mkdir -p "$dir/.thyrox/context/work/2026-03-27-090000-auth-system"

    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
Auth system. T-006 refresh tokens FALLÓ.
Error: token expiry calculation incorrect — tests failing.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: false
last_session: 2026-03-28
current_work: work/2026-03-27-090000-auth-system/
phase: execute
blockers: [T-006 failed]
EOF

    cat > "$dir/.thyrox/context/work/2026-03-27-090000-auth-system/plan.md" << 'EOF'
# Plan: Sistema de Autenticación

- [x] [T-001] Setup proyecto base (R-01)
- [x] [T-002] Schema de usuarios (R-01)
- [x] [T-003] Endpoint register (R-02)
- [x] [T-004] Endpoint login (R-03)
- [x] [T-005] JWT generation (R-04)
- [-] [T-006] Refresh tokens — FAILED: token expiry calculation (R-04)
- [ ] [T-007] Roles RBAC (R-05)
- [ ] [T-008] Tests integración (R-06)
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-13: Implementación falló ==="

    local result
    result=$(cd "$dir" && claude -p "Los tests no pasan después de implementar T-006 refresh tokens. El error dice que el token expiry no se calcula bien. ¿Qué hacemos?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "T-006\|falló\|fall\|error\|expiry" "Identifica que T-006 falló" || true
    check_negative "$result" "T-007\|siguiente.*tarea\|continuar.*con\|avanzar" "NO continúa con T-007" || true
    check_expectation "$result" "investig\|debug\|revisar\|corregir\|expiry\|cálculo" "Investiga el error" || true
}

# ===== MI-21: Segunda interacción — proponer avance =====
run_MI21() {
    local dir
    dir=$(setup_workspace "MI-21")

    mkdir -p "$dir/.thyrox/context/work/2026-03-28-inventario/analysis"

    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
Sistema de inventario. Phase 1 ANALYZE completado.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: false
last_session: 2026-03-28
current_work: work/2026-03-28-inventario/
phase: analyze (completed)
EOF

    cat > "$dir/.thyrox/context/work/2026-03-28-inventario/analysis/requirements.md" << 'EOF'
# Análisis: Sistema de Inventario

## Respuestas del usuario
- Tienda de ropa, 500 productos, 2 empleados
- Necesita: stock, alertas, reportes, solo web
- Stack: por definir

## Requisitos identificados
- R-01: Gestión de productos (CRUD)
- R-02: Control de stock (entradas/salidas)
- R-03: Alertas de stock bajo (< umbral configurable)
- R-04: Reportes básicos (stock actual, movimientos, productos bajo mínimo)
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-21: Segunda interacción — proponer avance ==="

    local result
    result=$(cd "$dir" && claude -p "OK, la tienda es de ropa, 500 productos, 2 empleados. Necesito stock, alertas y reportes. Solo web. ¿Qué sigue?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "Phase [23]\|PLAN\|SOLUTION\|siguiente.*fase\|estrategia\|planific" "Propone avanzar de fase (no más análisis)" || true
    check_negative "$result" "qué tipo de tienda\|cuántos producto\|cuántas persona" "NO hace más preguntas de análisis" || true
    check_expectation "$result" "R-01\|R-02\|R-03\|R-04\|requisito\|CRUD\|stock\|alerta" "Usa requisitos identificados" || true
}

# ===== MI-22: Status con plan activo =====
run_MI22() {
    local dir
    dir=$(setup_workspace "MI-22")

    mkdir -p "$dir/.thyrox/context/work/2026-03-26-cache-system"

    cat > "$dir/.thyrox/context/focus.md" << 'EOF'
# Focus
Sistema de caché Redis en Phase 6. T-003 completado.
EOF

    cat > "$dir/.thyrox/context/now.md" << 'EOF'
cold_boot: false
last_session: 2026-03-28
current_work: work/2026-03-26-cache-system/
phase: execute
EOF

    cat > "$dir/.thyrox/context/work/2026-03-26-cache-system/plan.md" << 'EOF'
# Plan: Sistema de Caché Redis

- [x] [T-001] Evaluar Redis vs Memcached (R-01)
- [x] [T-002] Instalar y configurar Redis (R-01)
- [x] [T-003] Implementar cache de sesiones de usuario (R-02)
- [ ] [T-004] Implementar cache de queries frecuentes a DB (R-03)
- [ ] [T-005] Configurar TTL por tipo de dato (R-04)
- [ ] [T-006] Tests de invalidación de caché (R-05)
- [ ] [T-007] Dashboard de monitoreo hit rate (R-06)
EOF

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-22: Status con plan activo ==="

    local result
    result=$(cd "$dir" && claude -p "¿Cuál es la siguiente tarea que tengo que hacer?" 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "T-004\|cache.*queries\|queries.*DB\|frecuent" "Identifica T-004 como siguiente" || true
    check_expectation "$result" "3.*7\|3.*completad\|tres.*completad\|progreso" "Reporta progreso 3/7" || true
    check_expectation "$result" "caché\|cache\|Redis" "Menciona contexto cache system" || true
    check_expectation "$result" "T-004\|siguiente\|ahora\|implement" "Dice qué hacer ahora" || true
}

# ===== MI-23: Descomposición con trazabilidad =====
run_MI23() {
    local dir
    dir=$(setup_workspace "MI-23")

    TOTAL_EVALS=$((TOTAL_EVALS + 1))
    echo ""
    echo "=== MI-23: Descomposición con trazabilidad ==="

    local result
    result=$(cd "$dir" && claude -p "Descompón la implementación de un sistema de búsqueda con Elasticsearch. Requisitos: R-01 búsqueda full-text en productos, R-02 filtros facetados por categoría/precio/marca, R-03 autocompletado en barra de búsqueda. Necesito poder rastrear cada tarea hasta su requisito original." 2>/dev/null) || result=""

    echo "  Response: ${result:0:150}..."
    echo "  Expectations:"

    check_expectation "$result" "T-[0-9]\|T-00\|\[T-\|Tarea.*[0-9]" "Tareas tienen IDs" || true
    check_expectation "$result" "R-01\|R-02\|R-03" "Referencias a requisitos" || true
    check_expectation "$result" "(R-01)\|(R-02)\|(R-03)\|requisito.*R-\|traz" "Trazabilidad visible" || true
    check_expectation "$result" "1\.\|primero\|antes\|luego\|después\|fase\|etapa" "Orden lógico" || true
}

# ===== MAIN =====
echo "============================================"
echo " Multi-Interaction Evals — thyrox"
echo "============================================"

if [ "$SPECIFIC_EVAL" = "all" ]; then
    run_MI01
    run_MI02
    run_MI05
    run_MI13
    run_MI21
    run_MI22
    run_MI23
else
    case "$SPECIFIC_EVAL" in
        MI-01) run_MI01 ;;
        MI-02) run_MI02 ;;
        MI-05) run_MI05 ;;
        MI-13) run_MI13 ;;
        MI-21) run_MI21 ;;
        MI-22) run_MI22 ;;
        MI-23) run_MI23 ;;
        *) echo "Unknown eval: $SPECIFIC_EVAL"; exit 1 ;;
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

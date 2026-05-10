#!/bin/bash
# =============================================================================
# scripts/provision-mariadb.sh — Provisionamiento completo de MariaDB
# =============================================================================
# Ejecuta todos los pasos de provisionamiento de MariaDB en orden:
#
#   1. Arranca MariaDB si no esta corriendo  (via start.sh mariadb)
#   2. setup.sh         — BD ivr_legacy + usuario django_user + grants
#   3. schema_historico — Tablas tbl_historico_tN_YYYY (con seed si aplica)
#   4. schema_seed      — tbl_temp_prueba_ivr (3000 registros de prueba)
#   5. SPs              — funciones_utilidad, sp_etl_pipeline, sp_rpt_reportes
#
# IDEMPOTENTE: se puede ejecutar N veces sin efectos adversos.
#   Los pasos detectan si ya se aplicaron y los omiten.
#
# USO:
#   sudo bash scripts/provision-mariadb.sh             # completo
#   sudo bash scripts/provision-mariadb.sh --skip-seed # sin re-sembrar datos
#
# REQUISITOS:
#   - MariaDB 10.11 instalado (ver provisioners/mariadb/install.sh)
#   - Archivo .env configurado (cp .env.example .env)
#   - Ejecutar como root
#
# DIFERENCIA con bootstrap.sh:
#   bootstrap.sh instala MariaDB desde cero (apt-get install).
#   Este script asume que MariaDB ya esta instalado y solo provisiona la BD.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/validation.sh"
source "${PROJECT_ROOT}/utils/database.sh"

ENV_FILE="${PROJECT_ROOT}/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Archivo .env no encontrado — ejecuta: cp .env.example .env"
    exit 1
fi
set -a; source "$ENV_FILE"; set +a

# Argumentos
SKIP_SEED="${SKIP_SEED:-0}"
for arg in "$@"; do
    case "$arg" in
        --skip-seed) SKIP_SEED=1 ;;
        --help|-h)
            echo "Uso: sudo bash scripts/provision-mariadb.sh [--skip-seed]"
            exit 0 ;;
    esac
done

PROV="${PROJECT_ROOT}/provisioners/mariadb"

log_header "IACT-db — Provisionamiento MariaDB"
log_info "PROJECT_ROOT: ${PROJECT_ROOT}"
log_info "SKIP_SEED:    ${SKIP_SEED}"

# ── PASO 0: Arrancar MariaDB ──────────────────────────────────────────────────
log_step 0 5 "Arrancar MariaDB"
bash "${PROJECT_ROOT}/start.sh" mariadb 2>&1

# Verificar que responde
if ! mariadb_is_running; then
    log_fatal "MariaDB no esta disponible tras start.sh"
fi

# Con skip-grant-tables, FLUSH PRIVILEGES habilita el sistema de permisos
mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;" 2>/dev/null || true
log_success "MariaDB lista"

# ── PASO 1: setup.sh ─────────────────────────────────────────────────────────
log_step 1 5 "BD + usuario + grants (setup.sh)"
bash "${PROV}/setup.sh"
log_success "setup.sh completado"

# ── PASO 2: schema_historico.sh ──────────────────────────────────────────────
log_step 2 5 "Tablas tbl_historico_* (schema_historico.sh)"
SKIP_SEED="${SKIP_SEED}" bash "${PROV}/schema_historico.sh"
log_success "schema_historico.sh completado"

# ── PASO 3: schema_seed.sh ───────────────────────────────────────────────────
log_step 3 5 "Tabla de prueba tbl_temp_prueba_ivr (schema_seed.sh)"
bash "${PROV}/schema_seed.sh"
log_success "schema_seed.sh completado"

# ── PASO 4: Stored Procedures ─────────────────────────────────────────────────
log_step 4 5 "Stored Procedures"
SOCK="/run/mysqld/mysqld.sock"
DB="${DB_MARIADB_NAME:-ivr_legacy}"

for sql in funciones_utilidad.sql sp_etl_pipeline.sql sp_rpt_reportes.sql; do
    SQL_PATH="${PROV}/${sql}"
    if [[ -f "$SQL_PATH" ]]; then
        log_info "  -> ${sql}"
        mysql --socket="$SOCK" "$DB" < "$SQL_PATH" 2>&1
        log_success "  ${sql}"
    else
        log_warn "  ${sql} no encontrado — omitido"
    fi
done

# ── PASO 5: Verificacion final ────────────────────────────────────────────────
log_step 5 5 "Verificacion"

SP_COUNT=$(mysql --socket="$SOCK" "$DB" -N -e \
    "SELECT COUNT(*) FROM information_schema.routines
     WHERE routine_schema='${DB}';" 2>/dev/null)

TABLE_COUNT=$(mysql --socket="$SOCK" "$DB" -N -e \
    "SELECT COUNT(*) FROM information_schema.tables
     WHERE table_schema='${DB}' AND table_type='BASE TABLE';" 2>/dev/null)

log_info "Tablas: ${TABLE_COUNT}"
log_info "Stored Procedures + Functions: ${SP_COUNT}"

mysql --socket="$SOCK" "$DB" -e "
SELECT routine_type AS tipo, routine_name AS nombre
FROM information_schema.routines
WHERE routine_schema='${DB}'
ORDER BY routine_type, routine_name;" 2>/dev/null

log_success "Provisionamiento completado — ${SP_COUNT} routines, ${TABLE_COUNT} tablas"
echo ""
log_info "Para verificar el entorno completo: bash verify.sh"

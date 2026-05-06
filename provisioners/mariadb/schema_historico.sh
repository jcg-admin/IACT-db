#!/bin/bash
# =============================================================================
# provisioners/mariadb/schema_historico.sh
# Crea y siembra las tablas tbl_historico_tN_YYYY en ivr_legacy
# =============================================================================
# Ejecuta en orden:
#   1. schema_historico.sql  — CREATE TABLE IF NOT EXISTS (idempotente)
#   2. seed_historico.sql    — Siembra datos representativos
#
# Las tablas replican la estructura real del IVR del cliente:
#   · tbl_historico_t1_2025  Q1 2025  (2025-01-01 → 2025-03-31)
#   · tbl_historico_t2_2025  Q2 2025  (2025-04-01 → 2025-06-30)
#   · tbl_historico_t3_2025  Q3 2025  (2025-07-01 → 2025-09-30)
#   · tbl_historico_t4_2025  Q4 2025  (2025-10-01 → 2025-12-31)
#   · tbl_historico_t1_2026  Q1 2026  (2026-01-01 → 2026-03-31)
#   · tbl_historico_t2_2026  Q2 2026  (2026-04-01 → en curso, datos hasta 2026-05-06)
#
# Columnas reales (confirmadas en analisis 2026-05-02):
#   dFecha, dHoraInicio, dHoraFin, cDID_800Transfer,
#   cDID_Centro_Transferencia, cMenu, cOpcion,
#   cTelefono_Origen, cTelefono_Digitado, cEtiquetacliente
#
# Sin indices (produccion opera con full table scans — CNST-ETL-005)
#
# USO:
#   sudo bash provisioners/mariadb/schema_historico.sh
#   # o con conteo personalizado:
#   SEED_ROWS=50000 sudo bash provisioners/mariadb/schema_historico.sh
#
# SEED_ROWS (filas por quarter, default 5000):
#   Desarrollo:   5000   (~5  seg)
#   Integracion: 50000   (~1  min)
#   Staging:    500000   (~10 min)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

ENV_FILE="${PROJECT_ROOT}/.env"
if [[ -f "$ENV_FILE" ]]; then set -a; source "$ENV_FILE"; set +a; fi

# ---------------------------------------------------------------------------
# Configuracion
# ---------------------------------------------------------------------------
DB_NAME="${DB_MARIADB_NAME:-ivr_legacy}"
DB_USER="${DB_MARIADB_USER:-django_user}"
DB_PASS="${DB_MARIADB_PASSWORD:-django_pass}"
DB_HOST="${MARIADB_HOST:-127.0.0.1}"
DB_PORT="${MARIADB_PORT:-3306}"
SEED_ROWS="${SEED_ROWS:-5000}"

SCHEMA_SQL="${SCRIPT_DIR}/schema_historico.sql"
SEED_SQL="${SCRIPT_DIR}/seed_historico.sql"

# ---------------------------------------------------------------------------
# Helper MySQL
# ---------------------------------------------------------------------------
my_exec() {
    mysql --batch \
          -h "${DB_HOST}" -P "${DB_PORT}" \
          -u "${DB_USER}" -p"${DB_PASS}" \
          "${DB_NAME}" "$@" 2>&1
}

my_exec_file() {
    mysql --batch \
          -h "${DB_HOST}" -P "${DB_PORT}" \
          -u "${DB_USER}" -p"${DB_PASS}" \
          "${DB_NAME}" < "$1" 2>&1
}

# ---------------------------------------------------------------------------
main() {
    log_header "IVR Historico — Schema y Seed"

    # Paso 1: verificar acceso
    log_step 1 3 "Verificar acceso a MariaDB"
    if ! my_exec -e "SELECT 1;" > /dev/null; then
        log_fatal "No se puede conectar a ${DB_HOST}:${DB_PORT} como ${DB_USER}"
    fi
    log_success "Acceso OK — ${DB_HOST}:${DB_PORT} ${DB_NAME}"

    # Paso 2: crear tablas
    log_step 2 3 "Crear tablas tbl_historico_tN_2025"

    if [[ ! -f "$SCHEMA_SQL" ]]; then
        log_fatal "No se encontro: ${SCHEMA_SQL}"
    fi

    my_exec_file "$SCHEMA_SQL"
    log_success "Tablas creadas (o ya existentes)"

    # Mostrar estado antes del seed
    EXISTING=$(my_exec -e \
        "SELECT SUM(t.cnt) FROM (
             SELECT COUNT(*) cnt FROM tbl_historico_t1_2025
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t2_2025
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t3_2025
         ) t;" | tail -1)
    log_info "Registros existentes en las 3 tablas: ${EXISTING}"

    # Paso 3: sembrar datos
    log_step 3 3 "Sembrar datos (${SEED_ROWS} registros por quarter)"

    if [[ ! -f "$SEED_SQL" ]]; then
        log_fatal "No se encontro: ${SEED_SQL}"
    fi

    # Inyectar SEED_ROWS en el SQL via variable de sesion
    my_exec -e "SET @SEED_ROWS = ${SEED_ROWS};" 2>/dev/null || true

    my_exec_file "$SEED_SQL"

    # Resumen final
    Q1_25=$(my_exec -e "SELECT COUNT(*) FROM tbl_historico_t1_2025;" | tail -1)
    Q2_25=$(my_exec -e "SELECT COUNT(*) FROM tbl_historico_t2_2025;" | tail -1)
    Q3_25=$(my_exec -e "SELECT COUNT(*) FROM tbl_historico_t3_2025;" | tail -1)
    Q4_25=$(my_exec -e "SELECT COUNT(*) FROM tbl_historico_t4_2025;" | tail -1)
    Q1_26=$(my_exec -e "SELECT COUNT(*) FROM tbl_historico_t1_2026;" | tail -1)
    Q2_26=$(my_exec -e "SELECT COUNT(*) FROM tbl_historico_t2_2026;" | tail -1)
    TOTAL=$(my_exec -e \
        "SELECT SUM(t.cnt) FROM (
             SELECT COUNT(*) cnt FROM tbl_historico_t1_2025
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t2_2025
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t3_2025
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t4_2025
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t1_2026
             UNION ALL SELECT COUNT(*) FROM tbl_historico_t2_2026
         ) t;" | tail -1)

    echo ""
    log_success "Schema y seed completados"
    log_info "  tbl_historico_t1_2025 (Q1 2025):         ${Q1_25} registros"
    log_info "  tbl_historico_t2_2025 (Q2 2025):         ${Q2_25} registros"
    log_info "  tbl_historico_t3_2025 (Q3 2025):         ${Q3_25} registros"
    log_info "  tbl_historico_t4_2025 (Q4 2025):         ${Q4_25} registros"
    log_info "  tbl_historico_t1_2026 (Q1 2026):         ${Q1_26} registros"
    log_info "  tbl_historico_t2_2026 (Q2 2026 parcial): ${Q2_26} registros"
    log_info "  Total: ${TOTAL} registros"
    echo ""
    log_info "Verificar con Django:"
    log_info "  cd IACT-api/callcentersite && source venv/bin/activate"
    log_info "  python manage.py check --database ivr"
}

main

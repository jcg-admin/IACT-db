#!/bin/bash
# =============================================================================
# verify.sh — IACT-db: verifica conectividad y estado de las BDs
# =============================================================================
# Uso:
#   bash verify.sh                # sin root (solo conectividad)
#
# Comprueba:
#   1. MariaDB responde en MARIADB_HOST:MARIADB_PORT
#   2. PostgreSQL responde en POSTGRES_HOST:POSTGRES_PORT
#   3. Conexión con credenciales Django (MariaDB)
#   4. Conexión con credenciales Django (PostgreSQL)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/database.sh"

ENV_FILE="${PROJECT_ROOT}/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    log_error "Archivo .env no encontrado — crea: cp .env.example .env"
    exit 1
fi

set -a; source "$ENV_FILE"; set +a

MARIADB_HOST="${MARIADB_HOST:-127.0.0.1}"
MARIADB_PORT="${MARIADB_PORT:-3306}"
POSTGRES_HOST="${POSTGRES_HOST:-127.0.0.1}"
POSTGRES_PORT="${POSTGRES_PORT:-5432}"

DB_MARIADB_NAME="${DB_MARIADB_NAME:-ivr_legacy}"
DB_MARIADB_USER="${DB_MARIADB_USER:-django_user}"
DB_MARIADB_PASSWORD="${DB_MARIADB_PASSWORD:-django_pass}"
DB_POSTGRES_NAME="${DB_POSTGRES_NAME:-iact_analytics}"
DB_POSTGRES_USER="${DB_POSTGRES_USER:-django_user}"
DB_POSTGRES_PASSWORD="${DB_POSTGRES_PASSWORD:-django_pass}"

PASS=0
FAIL=0

check() {
    local desc="$1"
    local cmd="$2"

    if eval "$cmd" &>/dev/null; then
        log_success "$desc"
        (( PASS++ ))
    else
        log_error "$desc"
        (( FAIL++ ))
    fi
}

log_header "IACT-db — Verificación de conectividad"

echo "  MariaDB:    ${MARIADB_HOST}:${MARIADB_PORT} / BD: ${DB_MARIADB_NAME}"
echo "  PostgreSQL: ${POSTGRES_HOST}:${POSTGRES_PORT} / BD: ${DB_POSTGRES_NAME}"
echo ""

check "MariaDB responde" \
    "mariadb_is_running '${MARIADB_HOST}' '${MARIADB_PORT}'"

check "PostgreSQL responde" \
    "pg_is_running '${POSTGRES_HOST}' '${POSTGRES_PORT}'"

check "Conexión Django → MariaDB (${DB_MARIADB_USER}@${DB_MARIADB_NAME})" \
    "mysql -h '${MARIADB_HOST}' -P '${MARIADB_PORT}' \
         -u '${DB_MARIADB_USER}' -p'${DB_MARIADB_PASSWORD}' \
         -e 'SELECT 1;' '${DB_MARIADB_NAME}'"

check "Conexión Django → PostgreSQL (${DB_POSTGRES_USER}@${DB_POSTGRES_NAME})" \
    "PGPASSWORD='${DB_POSTGRES_PASSWORD}' psql \
         -h '${POSTGRES_HOST}' -p '${POSTGRES_PORT}' \
         -U '${DB_POSTGRES_USER}' -d '${DB_POSTGRES_NAME}' \
         -c 'SELECT 1;'"

echo ""
echo "  Resultado: ${PASS} OK / ${FAIL} FALLOS"
echo ""

if [[ $FAIL -gt 0 ]]; then
    log_error "Hay ${FAIL} verificación(es) fallida(s)"
    echo "  Revisa: sudo bash bootstrap.sh"
    exit 1
fi

log_success "Todas las verificaciones pasaron"
echo ""
echo "  Django settings:"
echo "    DB ivr (MariaDB):       ${MARIADB_HOST}:${MARIADB_PORT} / ${DB_MARIADB_NAME}"
echo "    DB default (PostgreSQL): ${POSTGRES_HOST}:${POSTGRES_PORT} / ${DB_POSTGRES_NAME}"

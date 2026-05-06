#!/bin/bash
# =============================================================================
# verify.sh — IACT-db: verifica estado completo de las bases de datos
# =============================================================================
# Uso:
#   bash verify.sh               # sin root, verifica conectividad y .env
#
# Comprueba en orden:
#   1. Variables requeridas en .env
#   2. Herramientas CLI disponibles (mysql, psql, pg_isready)
#   3. MariaDB responde (socket Unix → TCP)
#   4. PostgreSQL responde (pg_isready → TCP)
#   5. Conexión Django → ivr_legacy (READ-ONLY — CNST-003)
#   6. Conexión Django → iact_analytics (READ+WRITE)
#   7. tbl_temp_prueba_ivr existe y tiene registros (si aplica)
#
# Muestra resumen final con contadores OK / WARN / ERROR.
# Equivalente a la sección "check_database_connectivity" de IACT-api check_tools.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$SCRIPT_DIR"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/database.sh"

# =============================================================================
# Cargar .env
# =============================================================================
ENV_FILE="${PROJECT_ROOT}/.env"
if [[ ! -f "$ENV_FILE" ]]; then
    echo "[ERROR] Archivo .env no encontrado"
    echo "  Crea tu configuración: cp .env.example .env"
    exit 1
fi
set -a; source "$ENV_FILE"; set +a

# Valores con defaults
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

# =============================================================================
# Contadores
# =============================================================================
OK=0; WARN=0; ERR=0

ok()   { log_success "$1"; (( OK++ ));   }
warn() { log_warn    "$1"; (( WARN++ )); }
fail() { log_error   "$1"; (( ERR++ ));  }

# =============================================================================
# Sección 1 — Variables de .env
# =============================================================================
check_env_vars() {
    log_header "1/7 Variables de entorno (.env)"

    local required=(
        "MARIADB_HOST" "MARIADB_PORT"
        "DB_MARIADB_NAME" "DB_MARIADB_USER" "DB_MARIADB_PASSWORD"
        "POSTGRES_HOST" "POSTGRES_PORT"
        "DB_POSTGRES_NAME" "DB_POSTGRES_USER" "DB_POSTGRES_PASSWORD"
    )

    for var in "${required[@]}"; do
        if [[ -n "${!var:-}" ]]; then
            ok "  ${var}=${!var}"
        else
            fail "  ${var} no configurado en .env"
        fi
    done
}

# =============================================================================
# Sección 2 — Herramientas CLI
# =============================================================================
check_tools() {
    log_header "2/7 Herramientas CLI"

    local tools=(
        "mysqladmin:MariaDB health check"
        "mysql:MariaDB client"
        "pg_isready:PostgreSQL health check"
        "psql:PostgreSQL client"
    )

    for entry in "${tools[@]}"; do
        local cmd="${entry%%:*}"
        local desc="${entry##*:}"
        if command -v "$cmd" &>/dev/null; then
            ok "  ${cmd} disponible (${desc})"
        else
            warn "  ${cmd} no encontrado — instala: sudo bash scripts/install-clients.sh"
        fi
    done
}

# =============================================================================
# Sección 3 — MariaDB activo
# =============================================================================
check_mariadb_running() {
    log_header "3/7 MariaDB — conectividad"

    # Intentar socket Unix primero
    local socket_ok=false
    for sock in /run/mysqld/mysqld.sock /var/run/mysqld/mysqld.sock; do
        if [[ -S "$sock" ]] && \
           mysqladmin --socket="$sock" ping --silent >/dev/null 2>&1; then
            ok "MariaDB activo via socket: ${sock}"
            socket_ok=true
            break
        fi
    done

    if [[ "$socket_ok" == "false" ]]; then
        if mariadb_is_running "$MARIADB_HOST" "$MARIADB_PORT"; then
            ok "MariaDB activo via TCP: ${MARIADB_HOST}:${MARIADB_PORT}"
        else
            fail "MariaDB NO responde en ${MARIADB_HOST}:${MARIADB_PORT}"
            warn "  Arranca con: sudo bash bootstrap.sh"
        fi
    fi
}

# =============================================================================
# Sección 4 — PostgreSQL activo
# =============================================================================
check_postgres_running() {
    log_header "4/7 PostgreSQL — conectividad"

    if command -v pg_isready &>/dev/null && \
       pg_isready -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" -q 2>/dev/null; then
        ok "PostgreSQL activo (pg_isready): ${POSTGRES_HOST}:${POSTGRES_PORT}"
    elif pg_is_running "$POSTGRES_HOST" "$POSTGRES_PORT"; then
        ok "PostgreSQL activo via TCP: ${POSTGRES_HOST}:${POSTGRES_PORT}"
    else
        fail "PostgreSQL NO responde en ${POSTGRES_HOST}:${POSTGRES_PORT}"
        warn "  Arranca con: sudo bash bootstrap.sh"
    fi
}

# =============================================================================
# Sección 5 — Conexión Django → ivr_legacy (READ-ONLY)
# =============================================================================
check_mariadb_django() {
    log_header "5/7 Django → ivr_legacy (READ-ONLY — CNST-003)"

    if ! command -v mysql &>/dev/null; then
        warn "mysql CLI no disponible — saltar verificación"
        warn "  Instala: sudo bash scripts/install-clients.sh"
        return
    fi

    local result
    result=$(mysql -h "$MARIADB_HOST" -P "$MARIADB_PORT" \
        -u "$DB_MARIADB_USER" -p"${DB_MARIADB_PASSWORD}" \
        --batch --silent --skip-column-names \
        -e "SELECT CONCAT(DATABASE(), '@', USER());" \
        "$DB_MARIADB_NAME" 2>&1) \
    && ok "Conexion Django a ivr_legacy OK: ${result}" \
    || fail "No se pudo conectar a ivr_legacy como ${DB_MARIADB_USER}"

    # Verificar que es READ-ONLY (CNST-003)
    if command -v mysql &>/dev/null; then
        local write_privs
        write_privs=$(mysql -h "$MARIADB_HOST" -P "$MARIADB_PORT" \
            -u "$DB_MARIADB_USER" -p"${DB_MARIADB_PASSWORD}" \
            --batch --silent --skip-column-names \
            -e "SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
                WHERE GRANTEE LIKE \"'${DB_MARIADB_USER}'%\"
                AND PRIVILEGE_TYPE IN
                    ('INSERT','UPDATE','DELETE','DROP','CREATE','ALTER');" \
            2>/dev/null || echo "?")

        if [[ "$write_privs" == "0" ]]; then
            ok "CNST-003: ${DB_MARIADB_USER} es READ-ONLY en ${DB_MARIADB_NAME}"
        elif [[ "$write_privs" == "?" ]]; then
            warn "CNST-003: no se pudo verificar privilegios de escritura"
        else
            fail "CNST-003: ${DB_MARIADB_USER} tiene ${write_privs} privilegio(s) de ESCRITURA en ${DB_MARIADB_NAME}"
        fi
    fi
}

# =============================================================================
# Sección 6 — Conexión Django → iact_analytics (READ+WRITE)
# =============================================================================
check_postgres_django() {
    log_header "6/7 Django → iact_analytics (READ+WRITE)"

    if ! command -v psql &>/dev/null; then
        warn "psql CLI no disponible — saltar verificación"
        warn "  Instala: sudo bash scripts/install-clients.sh"
        return
    fi

    local result
    result=$(PGPASSWORD="$DB_POSTGRES_PASSWORD" \
        psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" \
        -U "$DB_POSTGRES_USER" -d "$DB_POSTGRES_NAME" \
        -tAq -c "SELECT current_database() || '@' || current_user;" 2>&1) \
    && ok "Conexion Django a iact_analytics OK: ${result}" \
    || fail "No se pudo conectar a iact_analytics como ${DB_POSTGRES_USER}"

    # Verificar que puede crear tablas (necesario para migrate)
    if command -v psql &>/dev/null && PGPASSWORD="$DB_POSTGRES_PASSWORD" \
        psql -h "$POSTGRES_HOST" -p "$POSTGRES_PORT" \
        -U "$DB_POSTGRES_USER" -d "$DB_POSTGRES_NAME" \
        -c "CREATE TABLE IF NOT EXISTS _verify_tmp (id SERIAL PRIMARY KEY);
            DROP TABLE IF EXISTS _verify_tmp;" \
        &>/dev/null 2>&1; then
        ok "Permisos DDL OK (puede crear tablas — necesario para migrate)"
    else
        warn "No se pudo verificar permisos DDL en iact_analytics"
    fi
}

# =============================================================================
# Sección 7 — tbl_temp_prueba_ivr (datos de prueba ivr_legacy)
# =============================================================================
check_seed_table() {
    log_header "7/7 tbl_temp_prueba_ivr (datos de prueba ivr_legacy)"

    if ! command -v mysql &>/dev/null; then
        warn "mysql CLI no disponible — saltar verificación"
        return
    fi

    local count
    count=$(mysql -h "$MARIADB_HOST" -P "$MARIADB_PORT" \
        -u "$DB_MARIADB_USER" -p"${DB_MARIADB_PASSWORD}" \
        --batch --silent --skip-column-names \
        -e "SELECT COUNT(*) FROM tbl_temp_prueba_ivr;" \
        "$DB_MARIADB_NAME" 2>/dev/null || echo "-1")

    if [[ "$count" -ge 3000 ]]; then
        ok "tbl_temp_prueba_ivr: ${count} registros disponibles"
    elif [[ "$count" -ge 0 ]]; then
        warn "tbl_temp_prueba_ivr: solo ${count} registros (esperado 3000+)"
        warn "  Ejecuta: sudo bash provisioners/mariadb/schema_seed.sh"
    else
        warn "tbl_temp_prueba_ivr no existe o no es accesible"
        warn "  Ejecuta: sudo bash provisioners/mariadb/schema_seed.sh"
    fi
}

# =============================================================================
# MAIN
# =============================================================================
log_header "IACT-db — Verificación completa"

echo "  MariaDB:    ${MARIADB_HOST}:${MARIADB_PORT} / ${DB_MARIADB_NAME}"
echo "  PostgreSQL: ${POSTGRES_HOST}:${POSTGRES_PORT} / ${DB_POSTGRES_NAME}"
echo ""

check_env_vars
echo ""
check_tools
echo ""
check_mariadb_running
echo ""
check_postgres_running
echo ""
check_mariadb_django
echo ""
check_postgres_django
echo ""
check_seed_table

# =============================================================================
# Resumen
# =============================================================================
echo ""
log_separator 60 "="
echo ""
log_success  "OK:           ${OK}"
log_warn     "Advertencias: ${WARN}"
[[ $ERR -gt 0 ]] && log_error "Errores:      ${ERR}" || log_success "Errores:      ${ERR}"
echo ""

if [[ $ERR -eq 0 && $WARN -eq 0 ]]; then
    log_success "Entorno listo para desarrollo."
elif [[ $ERR -eq 0 ]]; then
    log_warn "Entorno funcional con advertencias — revisar items marcados."
    echo ""
    log_info "  sudo bash scripts/install-clients.sh  # si faltan clientes CLI"
    log_info "  sudo bash provisioners/mariadb/schema_seed.sh  # si faltan datos"
else
    log_error "Entorno incompleto — corregir errores antes de continuar."
    echo ""
    log_info "  sudo bash bootstrap.sh  # reinstalar y configurar todo"
fi

exit $(( ERR > 0 ? 1 : 0 ))

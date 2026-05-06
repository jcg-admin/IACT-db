#!/bin/bash
# =============================================================================
# provisioners/mariadb/setup.sh — Crea BD y usuario para Django
# =============================================================================
# IDEMPOTENTE: se puede ejecutar N veces sin efectos adversos.
#   · Si la BD ya existe      → sin cambios
#   · Si el usuario ya existe → actualiza contraseña
#   · GRANT es idempotente en MariaDB — se re-aplica siempre
#
# ivr_legacy es READ-ONLY para Django (solo SELECT — CNST-003).
# El usuario también recibe CREATE/DROP sobre test_ivr_legacy (para pytest).
#
# NO instala MariaDB. Requiere que MariaDB esté corriendo.
# Portado de IACT-api provisioners/mariadb/db_setup.sh (v1.0.0)
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/database.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

main() {
    log_header "MariaDB Database Setup"

    if ! validate_root; then
        log_fatal "Este script debe ejecutarse como root (sudo)"
    fi

    require_vars DB_MARIADB_NAME DB_MARIADB_USER DB_MARIADB_PASSWORD \
                 DB_CHARSET DB_COLLATION

    ensure_dir "${PROJECT_ROOT}/logs"

    local db_name="${DB_MARIADB_NAME}"
    local db_user="${DB_MARIADB_USER}"
    local db_pass="${DB_MARIADB_PASSWORD}"
    local charset="${DB_CHARSET:-utf8mb4}"
    local collation="${DB_COLLATION:-utf8mb4_unicode_ci}"
    local test_db_name="test_${db_name}"

    # --- Helper: ejecutar SQL como root via socket (sin contraseña) ---
    my_root()        { sudo mysql --batch "$@" 2>&1; }
    my_root_silent() { sudo mysql --batch --silent --skip-column-names "$@" 2>/dev/null; }

    # PASO 1 — Verificar acceso root
    log_step 1 5 "Verificando acceso root a MariaDB"

    if ! my_root_silent -e "SELECT 1;" >/dev/null; then
        log_fatal "No hay acceso root a MariaDB via socket unix"
    fi
    log_success "MariaDB accesible"

    # PASO 2 — Crear base de datos
    log_step 2 5 "Base de datos: ${db_name}"

    local exists
    exists=$(my_root_silent -e \
        "SELECT COUNT(*) FROM information_schema.SCHEMATA
         WHERE SCHEMA_NAME = '${db_name}';" || echo "0")

    if [[ "$exists" -gt 0 ]]; then
        log_info "Base de datos ya existe — sin cambios"
    else
        my_root -e \
            "CREATE DATABASE \`${db_name}\`
             CHARACTER SET ${charset}
             COLLATE ${collation};" >/dev/null
        log_success "Base de datos ${db_name} creada (${charset}/${collation})"
    fi

    # PASO 3 — Crear / actualizar usuario
    log_step 3 5 "Usuario: ${db_user}"

    for host in "%" "localhost"; do
        local user_exists
        user_exists=$(my_root_silent -e \
            "SELECT COUNT(*) FROM mysql.user
             WHERE User = '${db_user}' AND Host = '${host}';" || echo "0")

        if [[ "$user_exists" -gt 0 ]]; then
            my_root -e \
                "ALTER USER '${db_user}'@'${host}'
                 IDENTIFIED BY '${db_pass}';" >/dev/null
            log_info "Usuario ${db_user}@${host} ya existe — contraseña sincronizada"
        else
            my_root -e \
                "CREATE USER '${db_user}'@'${host}'
                 IDENTIFIED BY '${db_pass}';" >/dev/null
            log_success "Usuario ${db_user}@${host} creado"
        fi
    done

    # PASO 4 — Otorgar privilegios
    log_step 4 5 "Privilegios: ${db_user} en ${db_name} y ${test_db_name}"

    for host in "%" "localhost"; do
        # Producción: solo lectura (CNST-003)
        my_root -e \
            "GRANT SELECT ON \`${db_name}\`.* TO '${db_user}'@'${host}';" >/dev/null
        # Tests: pytest necesita crear y destruir test_ivr_legacy
        my_root -e \
            "GRANT CREATE, DROP, INDEX, ALTER ON \`${test_db_name}\`.* \
             TO '${db_user}'@'${host}';" >/dev/null
    done

    my_root -e "FLUSH PRIVILEGES;" >/dev/null
    log_success "Privilegios aplicados: SELECT en ${db_name} + CREATE/DROP en ${test_db_name}"

    # PASO 5 — Verificar conexión con credenciales Django
    log_step 5 5 "Verificando conexión Django"

    local host="${MARIADB_HOST:-127.0.0.1}"
    local port="${MARIADB_PORT:-3306}"

    local result
    result=$(mysql -h "$host" -P "$port" \
        -u "$db_user" -p"${db_pass}" \
        --batch --silent --skip-column-names \
        -e "SELECT CONCAT(DATABASE(), '@', USER());" \
        "$db_name" 2>&1) || {
        log_error "No se pudo conectar como ${db_user}: ${result}"
        return 1
    }

    log_success "Conexión OK: ${result}"

    echo ""
    log_success "Setup MariaDB completado. Base ${db_name} lista (READ-ONLY para Django)."
    echo ""
    echo "  Django settings:"
    echo "    DATABASE ivr: HOST=${host} PORT=${port} NAME=${db_name} USER=${db_user}"
}

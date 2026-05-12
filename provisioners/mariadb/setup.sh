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
#
# H-MDB-005: main() NO se llama incondicionalmente.
#   · Ejecucion directa  (bash setup.sh)    → guard activa main()
#   · Source desde bootstrap.sh             → bootstrap.sh llama main() explicitamente
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

source "${PROJECT_ROOT}/utils/logging.sh"
source "${PROJECT_ROOT}/utils/core.sh"
source "${PROJECT_ROOT}/utils/network.sh"
source "${PROJECT_ROOT}/utils/database.sh"
source "${PROJECT_ROOT}/utils/validation.sh"

# Cargar .env si las variables no vienen del entorno (ejecución directa)
ENV_FILE="${PROJECT_ROOT}/.env"
if [[ -f "$ENV_FILE" ]]; then set -a; source "$ENV_FILE"; set +a; fi

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
    my_root()        { mysql --batch "$@" 2>&1; }
    my_root_silent() { mysql --batch --silent --skip-column-names "$@" 2>/dev/null; }

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
        log_error "No se pudo conectar como ${db_user} via TCP: ${result}"
        return 1
    }

    log_success "Conexión TCP OK: ${result}"

    # H-MDB-013: verificar conexión via socket Unix — método que usa IACT-api en producción
    # IVR_DB_SOCKET=/run/mysqld/mysqld.sock en el .env de IACT-api
    local socket_path="${IVR_DB_SOCKET:-/run/mysqld/mysqld.sock}"
    if [[ -S "$socket_path" ]]; then
        local socket_result
        socket_result=$(mysql --socket="$socket_path" \
            -u "$db_user" -p"${db_pass}" \
            --batch --silent --skip-column-names \
            -e "SELECT CONCAT(DATABASE(), '@', USER());" \
            "$db_name" 2>&1) || {
            log_warn "Conexión socket Unix fallida: ${socket_result}"
            log_warn "  IACT-api producción usa IVR_DB_SOCKET=${socket_path}"
            log_warn "  Verifica permisos del socket: ls -la ${socket_path}"
        }
        if [[ -n "$socket_result" ]] && ! echo "$socket_result" | grep -q "ERROR"; then
            log_success "Conexión socket Unix OK: ${socket_result}"
        fi
    else
        log_warn "Socket ${socket_path} no encontrado — solo TCP verificado"
        log_warn "  IACT-api producción requiere el socket para IVR_DB_SOCKET"
    fi

    # Verificar CNST-003: reportar tablas con escritura directa (TABLE_PRIVILEGES).
    # BUG-003: la versión anterior consultaba USER_PRIVILEGES, que solo ve grants
    # globales (ON *.*). Los grants de tabla (GRANT INSERT ON ivr_legacy.etl_runs)
    # son invisibles a USER_PRIVILEGES — la verificación siempre retornaba 0
    # aunque existieran grants de escritura a nivel de tabla.
    # TABLE_PRIVILEGES refleja el estado real de privilegios por tabla.
    #
    # Nota de visibilidad: un usuario sin privilegios especiales solo puede
    # consultar sus propios grants en TABLE_PRIVILEGES. Conectando como django_user
    # vía TCP (autenticado como @'%'), la vista no muestra los grants de @'localhost'.
    # Por eso se usa my_root_silent (root vía socket) que ve TODOS los GRANTEEs.
    # GROUP_CONCAT DISTINCT deduplica INSERT/UPDATE que aparecen dos veces
    # (una por @'%' y otra por @'localhost').
    #
    # Esta verificación es de OBSERVABILIDAD, no de ENFORCEMENT.
    # El enforcement lo garantiza la arquitectura de FASE 6+7 del plan de
    # corrección: provision-mariadb.sh con lista explícita + REVOKE en BD.
    #
    # Estado esperado tras provision-mariadb.sh:
    #   etl_runs — INSERT, UPDATE  (extensión operacional documentada: run_etl.py)
    # Cualquier otra tabla con escritura directa es inesperada y debe revisarse.
    local write_tbls
    write_tbls=$(my_root_silent \
        -e "SELECT TABLE_NAME,
                   GROUP_CONCAT(DISTINCT PRIVILEGE_TYPE ORDER BY PRIVILEGE_TYPE) AS privs
            FROM information_schema.TABLE_PRIVILEGES
            WHERE GRANTEE LIKE \"'${db_user}'%\"
            AND TABLE_SCHEMA = '${db_name}'
            AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE')
            GROUP BY TABLE_NAME
            ORDER BY TABLE_NAME;" \
        || echo "")

    if [[ -z "$write_tbls" ]]; then
        log_success "CNST-003: ${db_user} es READ-ONLY en ${db_name} (sin escritura directa en ninguna tabla)"
    else
        log_info  "CNST-003: ${db_user} tiene escritura directa en tablas de ${db_name}:"
        while IFS=$'\t' read -r tbl privs; do
            log_info  "    ${tbl}: ${privs}"
        done <<< "$write_tbls"
        log_info  "  (ver ANALISIS-PERMISOS-CNST003-RUN-ETL para justificacion)"
    fi

    log_success "Setup MariaDB completado. Base ${db_name} lista (READ-ONLY para Django)."
    log_info  "  Django settings:"
    log_info  "    DATABASE ivr: HOST=${host} PORT=${port} NAME=${db_name} USER=${db_user}"
}

# H-MDB-005: ejecutar main solo cuando el script es el punto de entrada directo.
# Al hacer source desde bootstrap.sh, main() es llamado explicitamente por bootstrap.
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi

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
#  3b. Schema ivr_legacy completo (tablas históricas, analíticas, funciones, SPs)
#   4. PostgreSQL responde (pg_isready → TCP)
#   5. Conexión Django → ivr_legacy (READ-ONLY — CNST-003)
#   6. Conexión Django → iact_analytics (READ+WRITE)
#   7. tbl_temp_prueba_ivr existe y tiene registros (si aplica)
#
# Muestra resumen final con contadores OK / WARN / ERROR.
#
# CHANGELOG:
#   2026-05-10:
#     · H-EXEC-008: sección 3b ahora verifica tablas históricas tbl_historico_*
#       (6 tablas: t1..t4 de 2025 + t1..t2 de 2026). Severidad fail — son el
#       origen del pipeline ETL. Sin esta verificación, un entorno sin tablas
#       históricas pasaba verify.sh con 0 errores (falso positivo). Ref: FASE 4.
#     · Baseline actualizado: entorno completo reporta 26 OK (antes 25).
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

ok()   { log_success "$1"; OK=$(( OK + 1 ));   }
warn() { log_warn    "$1"; WARN=$(( WARN + 1 )); }
fail() { log_error   "$1"; ERR=$(( ERR + 1 ));  }

# =============================================================================
# Sección 1 — Variables de .env
# =============================================================================
check_env_vars() {
    log_header "1/8 Variables de entorno (.env)"

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
    log_header "2/8 Herramientas CLI"

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
    log_header "3/8 MariaDB — conectividad"

    # Detectar si MariaDB esta instalado antes de intentar conectar
    local mariadb_installed=false
    if command -v mysqladmin &>/dev/null \
    || command -v mariadbd  &>/dev/null \
    || command -v mysqld    &>/dev/null \
    || dpkg -l mariadb-server mysql-server 2>/dev/null | grep -q "^ii"; then
        mariadb_installed=true
    fi

    if [[ "$mariadb_installed" == "false" ]]; then
        warn "MariaDB no instalado en este entorno — seccion omitida"
        warn "  Instala con: sudo bash provisioners/mariadb/bootstrap.sh"
        return 0
    fi

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
            fail "MariaDB instalado pero NO responde en ${MARIADB_HOST}:${MARIADB_PORT}"
            warn "  Arranca con: sudo bash start.sh mariadb"
        fi
    fi
}

# =============================================================================
# Sección 3b — Schema MariaDB ivr_legacy
# =============================================================================
# Verifica que el provisionamiento --full fue ejecutado correctamente:
# tablas históricas (tbl_historico_*), tablas analíticas (base_ivr_*, job_*,
# etl_runs), funciones de utilidad, SPs ETL y SPs de reporte.
# Se omite si MariaDB no está instalado o no responde.
# Criterios de severidad:
#   fail → tablas faltantes — históricas o analíticas — el pipeline ETL no funciona
#   warn → funciones o SPs faltantes (degradan funcionalidad, no impiden conexión)
# =============================================================================
check_mariadb_schema() {
    log_header "3b/8 MariaDB — schema ivr_legacy"

    if ! command -v mysql &>/dev/null; then
        warn "mysql CLI no disponible — verificación de schema omitida"
        return
    fi

    if ! mariadb_is_running "$MARIADB_HOST" "$MARIADB_PORT"; then
        warn "MariaDB no responde — verificación de schema omitida"
        return
    fi

    # Preferir root via socket: information_schema.routines solo muestra rutinas
    # para las que el usuario tiene EXECUTE. django_user puede no tenerlo, lo que
    # daría conteos de 0 aunque los SPs existan. Root los ve todos.
    local mysql_root
    local sock="/run/mysqld/mysqld.sock"
    if [[ -S "$sock" ]] \
    && mysql --socket="$sock" -u root \
        -e "SELECT 1;" "$DB_MARIADB_NAME" &>/dev/null 2>&1; then
        mysql_root="mysql --socket=${sock} -u root"
        log_debug "check_mariadb_schema: conectando via socket como root"
    else
        mysql_root="mysql -h ${MARIADB_HOST} -P ${MARIADB_PORT} \
            -u ${DB_MARIADB_USER} -p${DB_MARIADB_PASSWORD}"
        warn "check_mariadb_schema: sin acceso root via socket — conteo de SPs puede ser inexacto"
    fi

    # Helper local para consultas sobre information_schema
    _mdb_schema_q() {
        $mysql_root --batch --silent --skip-column-names \
            -e "$1" information_schema 2>/dev/null || echo "-1"
    }

    # ── Tablas analíticas (schema_base_ivr.sql + schema_pipeline_event_log.sql) ──
    local tbl_ok=0 tbl_miss=0
    for tbl in base_ivr_detalle base_ivr_clientes \
               job_execution_log etl_runs job_config \
               pipeline_event_log; do
        local exists
        exists=$(_mdb_schema_q \
            "SELECT COUNT(*) FROM tables
             WHERE table_schema='${DB_MARIADB_NAME}'
             AND table_name='${tbl}';")
        if [[ "${exists:-0}" -eq 1 ]]; then
            log_debug "  tabla OK: ${tbl}"
            (( ++tbl_ok )) || true
        else
            fail "  tabla FALTANTE: ${tbl}"
            (( ++tbl_miss )) || true
        fi
    done

    if [[ $tbl_miss -eq 0 ]]; then
        ok "Tablas analíticas completas (${tbl_ok}/6)"
    else
        fail "Tablas analíticas incompletas: ${tbl_ok}/6 — ejecutar: sudo bash setup.sh mariadb --full"
    fi

    # ── Funciones de utilidad (objetos/funciones/) ────────────────────────
    local fn_ok=0 fn_miss=0
    # T-4.2 (H-ETL-002): agregar ivr_contar_dias_semana e ivr_agregar_dias_semana.
    # Ambas son usadas por sp_rpt_centros_xsegmento — sin ellas el SP falla
    # en runtime aunque exista. Residen en objetos/funciones/ (un archivo por función).
    for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
              fn_duracion_seg ivr_es_dia_semana \
              ivr_contar_dias_semana ivr_agregar_dias_semana; do
        local exists
        exists=$(_mdb_schema_q \
            "SELECT COUNT(*) FROM routines
             WHERE routine_schema='${DB_MARIADB_NAME}'
             AND routine_name='${fn}';")
        if [[ "${exists:-0}" -eq 1 ]]; then
            log_debug "  función OK: ${fn}"
            (( ++fn_ok )) || true
        else
            warn "  función FALTANTE: ${fn}"
            (( ++fn_miss )) || true
        fi
    done

    if [[ $fn_miss -eq 0 ]]; then
        ok "Funciones de utilidad completas (${fn_ok}/7)"
    else
        warn "Funciones de utilidad incompletas: ${fn_ok}/7 — ejecutar: sudo bash setup.sh mariadb --full"
    fi

    # ── SPs ETL (objetos/sps/sp_etl_*.sql) ────────────────────────────────────
    local sp_etl
    sp_etl=$(_mdb_schema_q \
        "SELECT COUNT(*) FROM routines
         WHERE routine_schema='${DB_MARIADB_NAME}'
         AND routine_type='PROCEDURE'
         AND routine_name LIKE 'sp_etl%';")
    if [[ "${sp_etl:-0}" -gt 0 ]]; then
        ok "SPs ETL presentes: ${sp_etl}"
    else
        warn "SPs ETL no encontrados — ejecutar: sudo bash setup.sh mariadb --full"
    fi

    # ── SPs de reporte (objetos/sps/sp_rpt_*.sql) ────────────────────────────
    local sp_rpt
    sp_rpt=$(_mdb_schema_q \
        "SELECT COUNT(*) FROM routines
         WHERE routine_schema='${DB_MARIADB_NAME}'
         AND routine_type='PROCEDURE'
         AND routine_name LIKE 'sp_rpt%';")
    if [[ "${sp_rpt:-0}" -gt 0 ]]; then
        ok "SPs Reporte presentes: ${sp_rpt}"
    else
        warn "SPs Reporte no encontrados — ejecutar: sudo bash setup.sh mariadb --full"
    fi

    # ── GRANT EXECUTE: django_user puede invocar los SPs ──────────────────────
    # Sin este grant, callproc() desde Django falla con ERROR 1370 aunque
    # los SPs existan y sean DEFINER root. EXECUTE y SQL SECURITY DEFINER
    # son capas independientes en MariaDB.
    # Nota: information_schema.ROUTINE_PRIVILEGES no refleja grants individuales
    # en MariaDB 10.11 — usar mysql.procs_priv (tabla de sistema directa).
    local exec_procs exec_funcs
    exec_procs=$($mysql_root --batch --silent --skip-column-names \
        -e "SELECT COUNT(DISTINCT Routine_name) FROM mysql.procs_priv
            WHERE User='${DB_MARIADB_USER}'
            AND Db='${DB_MARIADB_NAME}'
            AND Routine_type='PROCEDURE'
            AND Proc_priv LIKE '%Execute%';" 2>/dev/null)
    exec_funcs=$($mysql_root --batch --silent --skip-column-names \
        -e "SELECT COUNT(DISTINCT Routine_name) FROM mysql.procs_priv
            WHERE User='${DB_MARIADB_USER}'
            AND Db='${DB_MARIADB_NAME}'
            AND Routine_type='FUNCTION'
            AND Proc_priv LIKE '%Execute%';" 2>/dev/null)

    if [[ "${exec_procs:-0}" -gt 0 && "${exec_funcs:-0}" -gt 0 ]]; then
        ok "GRANT EXECUTE OK — ${DB_MARIADB_USER} puede invocar SPs (${exec_procs} PROCEDURE, ${exec_funcs} FUNCTION)"
    else
        fail "GRANT EXECUTE faltante — ${DB_MARIADB_USER} no puede invocar routines (${exec_procs:-0} PROC, ${exec_funcs:-0} FUNC)"
        warn "  Corregir con: sudo bash scripts/provision-mariadb.sh"
        warn "  Causa: ERROR 1370 en todo callproc() desde Django"
    fi

    # ── Tablas históricas (schema_historico.sh) ───────────────────────────────
    # T-4.3 (H-VFY-001): reordenado al final — son la fuente de datos crudos.
    # El orden anterior (históricas antes que funciones) era conceptualmente
    # incorrecto: las históricas son prerequisito de los SPs, no de las funciones.
    # Orden correcto: analíticas → funciones → SPs ETL → SPs Reporte → EXECUTE
    # → históricas (datos que alimentan el pipeline, no objetos del schema).
    # Verificación por patrón: los nombres son dinámicos (tbl_historico_tN_YYYY).
    # Se esperan exactamente 6: t1..t4 de 2025 + t1..t2 de 2026.
    local hist_count
    hist_count=$(_mdb_schema_q \
        "SELECT COUNT(*) FROM tables
         WHERE table_schema='${DB_MARIADB_NAME}'
         AND table_name LIKE 'tbl_historico_%';")
    if [[ "${hist_count:-0}" -ge 6 ]]; then
        ok "Tablas históricas presentes: ${hist_count}"
    else
        fail "Tablas históricas incompletas: ${hist_count}/6 — ejecutar: sudo bash setup.sh mariadb --full"
    fi
}

# =============================================================================
# Sección 4 — PostgreSQL activo
# =============================================================================
check_postgres_running() {
    log_header "4/8 PostgreSQL — conectividad"

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
    log_header "5/8 Django → ivr_legacy (READ-ONLY — CNST-003)"

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
    log_header "6/8 Django → iact_analytics (READ+WRITE)"

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
    log_header "7/8 tbl_temp_prueba_ivr (datos de prueba ivr_legacy)"

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
check_mariadb_schema
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

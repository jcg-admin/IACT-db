#!/bin/bash
# =============================================================================
# scripts/provision-mariadb.sh — Provisionamiento completo de MariaDB
# =============================================================================
# Versión: 1.2.0
#
# v1.0.0 — Flujo original:
#   1. Arranca MariaDB  2. setup.sh  3. schema_historico  4. schema_seed  5. SPs
#
# v1.1.0 (2026-05-10):
#   · H-MDB-010: agrega schema_base_ivr.sql en orden correcto de dependencias
#   · H-MDB-012: agrega network.sh en la cadena de carga
#   · H-MDB-015: verifica socket antes de usarlo; fallback a TCP
#   · PASO 0: FLUSH PRIVILEGES condicional (solo en skip-grant-tables)
#
# v1.2.0 (2026-05-10):
#   · T-1.1: agrega sql_exec_query() para queries inline (paralelo a sql_exec_file)
#   · T-1.2: PASO 5 usa sql_exec_query — elimina mysql --socket="$SOCK" directo
#     que falla silenciosamente cuando SOCK está vacío (fallback TCP activo)
#   · T-1.4: después de schema_base_ivr.sql, otorga DML a django_user en tablas
#     analíticas (base_ivr_detalle, base_ivr_clientes, job_execution_log,
#     etl_runs, job_config) — setup.sh da solo READ-ONLY sobre ivr_legacy.*
#   · T-1.5: PASO 5 verifica objetos por nombre en lugar de solo contar:
#     tablas analíticas, tabla de prueba, funciones de utilidad, SPs ETL y reporte
#
# EJECUTA todos los pasos de provisionamiento de MariaDB en orden:
#
#   1. Arranca MariaDB si no esta corriendo  (via start.sh mariadb)
#   2. setup.sh         — BD ivr_legacy + usuario django_user + grants
#   3. schema_historico — Tablas tbl_historico_tN_YYYY (con seed si aplica)
#   4. schema_seed      — tbl_temp_prueba_ivr (3000 registros de prueba)
#   5. SPs/schema       — funciones_utilidad, schema_base_ivr,
#                         sp_etl_pipeline, sp_rpt_reportes
#
# IDEMPOTENTE: se puede ejecutar N veces sin efectos adversos.
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
source "${PROJECT_ROOT}/utils/network.sh"
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

# FLUSH PRIVILEGES solo si el proceso corre con --skip-grant-tables.
# En instalación normal es innecesario y produce un mensaje de éxito engañoso.
if ps aux 2>/dev/null | grep -q "[m]ariadbd.*skip.grant.tables"; then
    log_info "skip-grant-tables detectado — ejecutando FLUSH PRIVILEGES"
    mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;" 2>/dev/null \
        && log_success "FLUSH PRIVILEGES completado" \
        || log_warn "FLUSH PRIVILEGES fallo (no critico)"
else
    log_debug "skip-grant-tables no activo — FLUSH PRIVILEGES omitido"
fi

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

# ── PASO 4: Stored Procedures y schema analítico ──────────────────────────────
log_step 4 5 "Stored Procedures y schema analítico"

# H-MDB-015: resolver mecanismo de conexión una vez, usarlo en todo el paso.
# SOCK vacío = fallback TCP activo en sql_exec_file y sql_exec_query.
SOCK="/run/mysqld/mysqld.sock"
DB="${DB_MARIADB_NAME:-ivr_legacy}"
DB_USER="${DB_MARIADB_USER:-django_user}"

if [[ ! -S "$SOCK" ]]; then
    log_warn "Socket ${SOCK} no encontrado — usando TCP"
    SOCK=""
else
    log_debug "Usando socket ${SOCK}"
fi

# T-1.1: helpers de ejecución SQL.
# Ambos usan el mismo mecanismo: socket si disponible, TCP como fallback.
# La diferencia es la fuente: archivo vs. query inline.

# sql_exec_file <archivo.sql>
#   Ejecuta un archivo SQL completo. Usado para DDL/DML de schema y SPs.
sql_exec_file() {
    local sql_file="$1"
    if [[ -n "$SOCK" ]]; then
        mysql --socket="$SOCK" "$DB" < "$sql_file" 2>&1
    else
        mysql -h "${MARIADB_HOST:-127.0.0.1}" -P "${MARIADB_PORT:-3306}" \
              -u root "$DB" < "$sql_file" 2>&1
    fi
}

# sql_exec_query <query> [base_de_datos]
#   Ejecuta una query inline. Usado para verificaciones y GRANTs.
#   Retorna el resultado sin encabezados de columna (-N).
sql_exec_query() {
    local query="$1"
    local db="${2:-$DB}"
    if [[ -n "$SOCK" ]]; then
        mysql --socket="$SOCK" "$db" -N -e "$query" 2>/dev/null
    else
        mysql -h "${MARIADB_HOST:-127.0.0.1}" -P "${MARIADB_PORT:-3306}" \
              -u root "$db" -N -e "$query" 2>/dev/null
    fi
}

# H-MDB-010: orden de aplicación con dependencias explícitas:
#   1. funciones_utilidad.sql  — prerequisito de schema_base_ivr y SPs
#   2. schema_base_ivr.sql     — crea tablas analíticas (base_ivr_*, job_*, etl_runs)
#   3. sp_etl_pipeline.sql     — usa tablas de schema_base_ivr
#   4. sp_rpt_reportes.sql     — lee base_ivr_detalle
PASO4_ERRORS=0
for sql in funciones_utilidad.sql schema_base_ivr.sql sp_etl_pipeline.sql sp_rpt_reportes.sql; do
    SQL_PATH="${PROV}/${sql}"
    if [[ ! -f "$SQL_PATH" ]]; then
        log_warn "  ${sql} no encontrado en ${PROV} — omitido"
        continue
    fi

    log_info "  -> ${sql}"
    if sql_exec_file "$SQL_PATH"; then
        log_success "  ${sql} aplicado"

        # T-1.4: después de schema_base_ivr.sql, otorgar DML a django_user
        # en las tablas analíticas. setup.sh da READ-ONLY sobre ivr_legacy.*;
        # el pipeline ETL necesita INSERT/UPDATE/DELETE en estas tablas específicas.
        if [[ "$sql" == "schema_base_ivr.sql" ]]; then
            log_info "  Otorgando DML en tablas analíticas a ${DB_USER}"
            for tbl in base_ivr_detalle base_ivr_clientes \
                       job_execution_log etl_runs job_config; do
                # 'local' solo es válido dentro de funciones — usar variable simple
                GRANT_STMT="GRANT SELECT, INSERT, UPDATE, DELETE \
                    ON \`${DB}\`.\`${tbl}\` TO '${DB_USER}'@'localhost';"
                sql_exec_query "$GRANT_STMT" "mysql" \
                    && log_debug "    GRANT ${tbl} @localhost OK" \
                    || log_warn  "    GRANT ${tbl} @localhost fallo"

                GRANT_STMT="GRANT SELECT, INSERT, UPDATE, DELETE \
                    ON \`${DB}\`.\`${tbl}\` TO '${DB_USER}'@'%';"
                sql_exec_query "$GRANT_STMT" "mysql" \
                    && log_debug "    GRANT ${tbl} @'%' OK" \
                    || log_warn  "    GRANT ${tbl} @'%' fallo"
            done
            sql_exec_query "FLUSH PRIVILEGES;" "mysql" \
                && log_success "  Grants analíticos aplicados" \
                || log_warn    "  FLUSH PRIVILEGES fallo (no crítico)"
        fi
    else
        log_error "  ${sql} fallo — revisar log de MariaDB"
        (( ++PASO4_ERRORS )) || true
    fi
done

[[ $PASO4_ERRORS -eq 0 ]] \
    && log_success "Todos los archivos SQL aplicados" \
    || log_warn    "${PASO4_ERRORS} archivo(s) SQL con errores — revisar antes de continuar"

# ── PASO 5: Verificación nominal ──────────────────────────────────────────────
log_step 5 5 "Verificación"

# T-1.2: usar sql_exec_query en lugar de mysql --socket="$SOCK" directo.
# Cuando SOCK está vacío (fallback TCP activo), el socket directo falla silenciosamente
# y los conteos quedan vacíos sin ningún aviso.

SP_COUNT=$(sql_exec_query \
    "SELECT COUNT(*) FROM information_schema.routines
     WHERE routine_schema='${DB}';")

TABLE_COUNT=$(sql_exec_query \
    "SELECT COUNT(*) FROM information_schema.tables
     WHERE table_schema='${DB}' AND table_type='BASE TABLE';")

log_info "Tablas totales:              ${TABLE_COUNT:-0}"
log_info "Routines (SPs + Functions):  ${SP_COUNT:-0}"

# T-1.5: verificación nominal — confirmar objetos específicos por nombre.
# Un conteo agregado no detecta si faltó un archivo SQL individual.
log_info "Verificando objetos esperados..."
VERIFY_ERRORS=0

# Tablas analíticas (creadas por schema_base_ivr.sql)
for tbl in base_ivr_detalle base_ivr_clientes job_execution_log etl_runs job_config; do
    exists=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.tables
         WHERE table_schema='${DB}' AND table_name='${tbl}';")
    if [[ "${exists:-0}" -eq 1 ]]; then
        log_debug "  tabla OK: ${tbl}"
    else
        log_error "  tabla FALTANTE: ${tbl} (revisar schema_base_ivr.sql)"
        (( ++VERIFY_ERRORS )) || true
    fi
done

# Tabla de prueba (creada por schema_seed.sh)
exists=$(sql_exec_query \
    "SELECT COUNT(*) FROM information_schema.tables
     WHERE table_schema='${DB}' AND table_name='tbl_temp_prueba_ivr';")
if [[ "${exists:-0}" -eq 1 ]]; then
    log_debug "  tabla OK: tbl_temp_prueba_ivr"
else
    log_warn "  tabla FALTANTE: tbl_temp_prueba_ivr (schema_seed.sh no aplicado)"
fi

# Funciones de utilidad (creadas por funciones_utilidad.sql)
for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
          fn_duracion_seg ivr_es_dia_semana; do
    exists=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.routines
         WHERE routine_schema='${DB}' AND routine_name='${fn}';")
    if [[ "${exists:-0}" -eq 1 ]]; then
        log_debug "  función OK: ${fn}"
    else
        log_error "  función FALTANTE: ${fn} (revisar funciones_utilidad.sql)"
        (( ++VERIFY_ERRORS )) || true
    fi
done

# SPs ETL y reporte — verificar al menos 1 de cada grupo
sp_etl_count=$(sql_exec_query \
    "SELECT COUNT(*) FROM information_schema.routines
     WHERE routine_schema='${DB}' AND routine_type='PROCEDURE'
     AND routine_name LIKE 'sp_etl%';")
sp_rpt_count=$(sql_exec_query \
    "SELECT COUNT(*) FROM information_schema.routines
     WHERE routine_schema='${DB}' AND routine_type='PROCEDURE'
     AND routine_name LIKE 'sp_rpt%';")

[[ "${sp_etl_count:-0}" -gt 0 ]] \
    && log_debug "  SPs ETL OK: ${sp_etl_count}" \
    || { log_error "  SPs ETL FALTANTES (revisar sp_etl_pipeline.sql)"; (( ++VERIFY_ERRORS )) || true; }

[[ "${sp_rpt_count:-0}" -gt 0 ]] \
    && log_debug "  SPs Reporte OK: ${sp_rpt_count}" \
    || { log_error "  SPs Reporte FALTANTES (revisar sp_rpt_reportes.sql)"; (( ++VERIFY_ERRORS )) || true; }

# Resumen final
echo ""
if [[ $VERIFY_ERRORS -eq 0 ]]; then
    log_success "Verificación nominal completada — todos los objetos presentes"
    log_success "Provisionamiento completado — ${SP_COUNT:-0} routines, ${TABLE_COUNT:-0} tablas"
else
    log_error   "Verificación nominal: ${VERIFY_ERRORS} objeto(s) faltante(s)"
    log_error   "Revisar los errores anteriores antes de ejecutar el pipeline ETL"
fi

echo ""
log_info "Para verificar el entorno completo: bash verify.sh"

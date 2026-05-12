#!/bin/bash
# =============================================================================
# scripts/provision-mariadb.sh — Provisionamiento completo de MariaDB
# =============================================================================
# Versión: 1.4.0
#
# CHANGELOG:
#   v1.4.0 (2026-05-10):
#     H-GRANT-001..006: refactoring completo para instalación en N servidores
#       · Código de ejecución envuelto en main() — local válido dentro de funciones
#       · GRANT DML extraído a función independiente _apply_dml_grants()
#       · GRANT EXECUTE extraído a función independiente _apply_execute_grants()
#       · Ambas funciones son idempotentes: consultan estado actual de la BD,
#         aplican solo lo que existe, seguro re-ejecutar en cualquier estado
#       · PASO_SQL_ERRORS reemplaza PASO4_ERRORS — sin números en nombres
#       · PASO dedicado para grants (independiente del loop de SQL)
#       · verify.sh: COUNT(DISTINCT Routine_name) en lugar de COUNT(*)
#         para reportar 12 SPs y 7 funciones, no 24 y 14 (×2 por host)
#
#   v1.3.0 (2026-05-10):
#     T-EXEC-001: GRANT EXECUTE para django_user — sin este grant todo
#       callproc() desde Django falla con ERROR 1370 aunque los SPs sean
#       SQL SECURITY DEFINER root (dos capas de seguridad independientes)
#
#   v1.2.1 (2026-05-10):
#     H-EXEC-003: local grant= → GRANT_STMT= — local inválido fuera de función
#
#   v1.2.0 (2026-05-10):
#     T-1.1..T-1.5: sql_exec_query, DML grants para tablas analíticas,
#       verificación nominal por nombre
#
#   v1.1.0 (2026-05-10):
#     H-MDB-010..015: orden de dependencias, network.sh, socket-first
#
#   v1.0.0: flujo original
#
# EJECUTA todos los pasos de provisionamiento de MariaDB en orden:
#
#   Paso arrancar:    Arranca MariaDB si no está corriendo (via start.sh)
#   Paso setup:       BD ivr_legacy + usuario django_user + grants base
#   Paso historico:   Tablas tbl_historico_tN_YYYY + seed (schema_historico.sh)
#   Paso seed:        Tabla de prueba tbl_temp_prueba_ivr (schema_seed.sh)
#   Paso sql:         funciones_utilidad, schema_base_ivr, sp_etl_pipeline,
#                     sp_rpt_reportes
#   Paso grants:      GRANT DML en tablas analíticas + GRANT EXECUTE en routines
#                     (independiente del paso sql — idempotente y re-ejecutable)
#   Paso verificar:   Objetos esperados por nombre
#
# IDEMPOTENTE: seguro ejecutar en cualquier estado — en instalación fresca,
#   en servidor con schema parcial, o en re-ejecución sobre entorno completo.
#
# USO:
#   sudo bash scripts/provision-mariadb.sh             # completo
#   sudo bash scripts/provision-mariadb.sh --skip-seed # sin seed
#
# REQUISITOS:
#   · MariaDB 10.11 instalado (ver provisioners/mariadb/install.sh)
#   · Archivo .env configurado (cp .env.example .env)
#   · Ejecutar como root
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

# ---------------------------------------------------------------------------
# Helpers de ejecución SQL
# ---------------------------------------------------------------------------

# sql_exec_file <archivo.sql>
#   Ejecuta un archivo SQL completo como root.
#   Usado para DDL/DML de schema y stored procedures.
sql_exec_file() {
    local sql_file="$1"
    if [[ -n "${SOCK:-}" && -S "${SOCK}" ]]; then
        mysql --socket="$SOCK" "$DB" < "$sql_file" 2>&1
    else
        mysql -h "${MARIADB_HOST:-127.0.0.1}" -P "${MARIADB_PORT:-3306}" \
              -u root "$DB" < "$sql_file" 2>&1
    fi
}

# sql_exec_query <query> [base_de_datos]
#   Ejecuta una query inline como root. Retorna sin encabezados de columna.
#   Usado para verificaciones y GRANTs.
sql_exec_query() {
    local query="$1"
    local db="${2:-${DB:-}}"
    if [[ -n "${SOCK:-}" && -S "${SOCK}" ]]; then
        mysql --socket="$SOCK" "${db}" -N -e "$query" 2>/dev/null
    else
        mysql -h "${MARIADB_HOST:-127.0.0.1}" -P "${MARIADB_PORT:-3306}" \
              -u root "${db}" -N -e "$query" 2>/dev/null
    fi
}

# ---------------------------------------------------------------------------
# _apply_dml_grants
#
# Otorga SELECT, INSERT, UPDATE, DELETE a DB_USER en las tablas analíticas.
# Idempotente: GRANT en MariaDB no falla si el grant ya existe.
# Seguro si las tablas no existen aún: GRANT falla silenciosamente, el script
# continúa — la próxima ejecución lo reintentará cuando las tablas existan.
#
# Separada del loop de SQL (H-GRANT-002): puede ejecutarse en cualquier
# estado de la BD sin depender del éxito de schema_base_ivr.sql.
#
# CNST-003 (del análisis ANALISIS-PERMISOS-CNST003-RUN-ETL):
#   django_user es READ-ONLY sobre los datos del dominio IVR.
#   La ÚNICA excepción es etl_runs: run_etl.py (management command) y
#   scheduler.py (APScheduler) necesitan INSERT y UPDATE para registrar
#   el ciclo de vida de las ejecuciones del job ETL.
#   DELETE excluido deliberadamente — ningún archivo .py hace DELETE en etl_runs.
#   Las otras 4 tablas (base_ivr_*, job_execution_log, job_config) son escritas
#   por root vía DEFINER de los SPs — django_user solo las lee, y el SELECT
#   global de setup.sh (GRANT SELECT ON ivr_legacy.*) ya lo cubre.
# ---------------------------------------------------------------------------
_apply_dml_grants() {
    local dml_ok=0

    log_info "  Tabla operacional de ETL que necesita escritura para ${DB_USER}:"
    # ÚNICA tabla donde django_user escribe directamente.
    # run_etl.py y scheduler.py usan INSERT (registrar inicio) y UPDATE
    # (heartbeat, timeout, estado final). DELETE no tiene caso de uso.
    # Si en el futuro se necesitan más tablas, documentar aquí la justificación
    # y restaurar el loop con la lista explícita de tablas.

    local tbl_exists
    tbl_exists=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.TABLES
         WHERE TABLE_SCHEMA='${DB}' AND TABLE_NAME='etl_runs';")

    if [[ "${tbl_exists:-0}" -ne 1 ]]; then
        log_warn "  SKIP etl_runs — tabla no existe aún"
        log_warn "  Re-ejecutar provision-mariadb.sh cuando schema_base_ivr.sql esté aplicado"
        return 0
    fi

    for host in "localhost" "%"; do
        local stmt
        stmt="GRANT SELECT, INSERT, UPDATE
            ON \`${DB}\`.\`etl_runs\` TO '${DB_USER}'@'${host}';"
        sql_exec_query "$stmt" "mysql" \
            && (( ++dml_ok )) \
            || log_warn "    WARN: GRANT DML etl_runs @${host} fallo"
    done

    sql_exec_query "FLUSH PRIVILEGES;" "mysql" \
        || log_warn "  FLUSH PRIVILEGES fallo (no crítico)"

    log_success "  Grants DML aplicados (${dml_ok} grants — etl_runs: SELECT, INSERT, UPDATE)"
}

# ---------------------------------------------------------------------------
# _apply_execute_grants
#
# Otorga EXECUTE a DB_USER en todos los PROCEDURE y FUNCTION existentes
# en la BD. Idempotente: GRANT EXECUTE no falla si ya existe.
# Solo otorga en routines que existen — no falla si la BD está vacía.
#
# Separada del loop de SQL (H-GRANT-001): puede ejecutarse en cualquier
# momento sin depender del orden o éxito de los archivos SQL.
#
# Por qué django_user necesita EXECUTE aunque los SPs sean DEFINER root:
#   SQL SECURITY DEFINER controla qué puede hacer el SP una vez invocado.
#   EXECUTE controla quién puede invocarlo. Sin EXECUTE: ERROR 1370.
#   CNST-ETL-001 se mantiene: django_user no accede a tbl_historico_*
#   directamente — los SPs las leen como root (DEFINER).
#
# Sintaxis MariaDB: GRANT EXECUTE ON PROCEDURE|FUNCTION <db>.<name>
#   GRANT EXECUTE ON <db>.<name> genérico produce ERROR 1144.
#
# LISTA EXPLÍCITA (no dinámica):
#   Solo los SPs que Django invoca directamente están autorizados.
#   Los SPs internos del ETL (sp_etl_base_detalle, sp_etl_base_clientes,
#   sp_etl_validar) son llamados por sp_etl_maestro como DEFINER=root;
#   django_user no los necesita ni debe poder invocarlos directamente.
#   Un SP nuevo de ETL no recibirá EXECUTE automáticamente — debe ser
#   una decisión explícita documentada aquí.
#   Las 7 funciones se conservan todas (solo cálculo/lectura, sin riesgo).
# ---------------------------------------------------------------------------
_apply_execute_grants() {
    local exec_ok=0 exec_skip=0

    log_info "  SPs que Django invoca directamente (lista explícita):"

    # Procedures — lista explícita de los que Django invoca directamente:
    #   sp_etl_maestro   — run_etl.py (management command) y scheduler.py
    #   sp_etl_historico — ETLReintentarView (carga histórica manual)
    #   sp_rpt_*         — 7 SPs de reporte (UC_RPT_12..17)
    # Excluidos deliberadamente (invocados por root vía DEFINER de sp_etl_maestro):
    #   sp_etl_base_detalle, sp_etl_base_clientes, sp_etl_validar
    while IFS= read -r sp_name; do
        [[ -z "$sp_name" ]] && continue
        for host in "localhost" "%"; do
            local stmt
            stmt="GRANT EXECUTE ON PROCEDURE \`${DB}\`.\`${sp_name}\`
                TO '${DB_USER}'@'${host}';"
            sql_exec_query "$stmt" "mysql" \
                && (( ++exec_ok )) \
                || { log_warn "    WARN: GRANT EXECUTE PROCEDURE ${sp_name} @${host} fallo"
                     (( ++exec_skip )) || true; }
        done
    done < <(sql_exec_query \
        "SELECT ROUTINE_NAME FROM information_schema.ROUTINES
         WHERE ROUTINE_SCHEMA='${DB}'
         AND ROUTINE_TYPE='PROCEDURE'
         AND ROUTINE_NAME IN (
             'sp_etl_maestro',
             'sp_etl_historico',
             'sp_rpt_clientes',
             'sp_rpt_centros_transferencia',
             'sp_rpt_llamadas_abandonadas',
             'sp_rpt_cMENU_ERROR',
             'sp_rpt_centros_xsegmento',
             'sp_rpt_menu_redirigidos',
             'sp_rpt_menu_centro'
         );" "mysql")

    # Functions — todas las funciones del schema.
    # Son de solo cálculo/lectura (sin escritura), invocadas por los SPs
    # como DEFINER=root. Django no las llama directamente, pero se conservan
    # por defensividad y consistencia con el estado previo.
    while IFS= read -r fn_name; do
        [[ -z "$fn_name" ]] && continue
        for host in "localhost" "%"; do
            local stmt
            stmt="GRANT EXECUTE ON FUNCTION \`${DB}\`.\`${fn_name}\`
                TO '${DB_USER}'@'${host}';"
            sql_exec_query "$stmt" "mysql" \
                && (( ++exec_ok )) \
                || { log_warn "    WARN: GRANT EXECUTE FUNCTION ${fn_name} @${host} fallo"
                     (( ++exec_skip )) || true; }
        done
    done < <(sql_exec_query \
        "SELECT ROUTINE_NAME FROM information_schema.ROUTINES
         WHERE ROUTINE_SCHEMA='${DB}'
         AND ROUTINE_TYPE='FUNCTION';" "mysql")

    sql_exec_query "FLUSH PRIVILEGES;" "mysql" \
        || log_warn "  FLUSH PRIVILEGES fallo (no crítico)"

    if [[ $exec_skip -gt 0 ]]; then
        log_warn "  Grants EXECUTE: ${exec_ok} OK, ${exec_skip} fallo"
    else
        log_success "  Grants EXECUTE aplicados (${exec_ok} grants — $((exec_ok / 2)) routines × 2 hosts)"
    fi
}

# ---------------------------------------------------------------------------
# _run_etl_backfill
#
# T-4.1 (H-ETL-001): backfill ETL opcional para instancias nuevas.
#
# En una instalación fresca, schema_historico.sh crea las tablas
# tbl_historico_* y las puebla con datos sintéticos de seed. Sin embargo,
# base_ivr_detalle y base_ivr_clientes (tablas analíticas) quedan vacías
# hasta que se ejecuta el pipeline ETL manualmente.
#
# Esta función llama sp_etl_historico(p_year, p_quarter_num) para cada
# quarter que tenga una tbl_historico_ correspondiente. Detecta
# automáticamente cuáles existen — no asume un set fijo de quarters.
#
# Activación: RUN_ETL_BACKFILL=1 (default=0)
#   sudo RUN_ETL_BACKFILL=1 bash scripts/provision-mariadb.sh
#   o en .env: RUN_ETL_BACKFILL=1
#
# Idempotente: sp_etl_historico registra en job_execution_log y puede
# detectar si el quarter ya fue procesado. No hace doble-insert.
#
# Prerequisito: sp_etl_historico debe existir (PASO 5) y los grants
# EXECUTE deben estar aplicados (PASO 6).
# ---------------------------------------------------------------------------
_run_etl_backfill() {
    log_info "Iniciando backfill ETL para quarters disponibles..."

    # Detectar qué tablas tbl_historico_ existen
    # Fix set-e-cmd-sub: || true porque si sql_exec_query falla (DB no responde),
    # hist_tables queda vacío y el if -z lo detecta con un mensaje claro.
    # Sin || true: set -e mataría el script aquí sin mensaje de error.
    local hist_tables
    hist_tables=$(sql_exec_query \
        "SELECT TABLE_NAME FROM information_schema.TABLES
         WHERE TABLE_SCHEMA='${DB}'
         AND TABLE_NAME LIKE 'tbl_historico_t%'
         ORDER BY TABLE_NAME;") || true

    if [[ -z "$hist_tables" ]]; then
        log_warn "  No se encontraron tablas tbl_historico_* — backfill omitido"
        log_warn "  Ejecutar primero: sudo bash setup.sh mariadb --full"
        return 0
    fi

    log_info "  Tablas históricas detectadas:"
    echo "$hist_tables" | while IFS= read -r tbl; do
        log_info "    ${tbl}"
    done

    local backfill_ok=0 backfill_err=0

    # Para cada tabla tbl_historico_tQ_YYYY extraer Q y YYYY y llamar al SP
    while IFS= read -r tbl; do
        [[ -z "$tbl" ]] && continue

        # Extraer quarter_num y year del nombre: tbl_historico_t{Q}_{YYYY}
        # Fix set-e-cmd-sub: grep retorna exit 1 si no hay match.
        # Con set -e, sin || true el script moriría antes de llegar al if -z.
        local quarter_num year_val
        quarter_num=$(echo "$tbl" | grep -oP '(?<=tbl_historico_t)\d(?=_)') || true
        year_val=$(echo    "$tbl" | grep -oP '\d{4}$') || true

        if [[ -z "$quarter_num" || -z "$year_val" ]]; then
            log_warn "  No se pudo parsear quarter/year de: ${tbl} — omitido"
            (( ++backfill_err )) || true
            continue
        fi

        log_info "  ETL: Q${quarter_num}/${year_val} (tabla: ${tbl})"

        # Fix set-e-cmd-sub: el patrón VAR=$(cmd) / local rc=$? tiene un bug
        # crítico con set -e. Si cmd falla, set -e mata el script en la línea
        # result=$(cmd) — el 'local rc=$?' y el 'if [[ $rc -eq 0 ]]' son dead code.
        # Patrón correcto: && rc=0 || rc=$? previene que set -e actúe porque
        # el || convierte el error en "expresión evaluada", no en "fallo de comando".
        local result rc
        result=$(sql_exec_query \
            "CALL sp_etl_historico(${year_val}, ${quarter_num});" \
            "${DB}" 2>&1) && rc=0 || rc=$?

        if [[ $rc -eq 0 ]]; then
            log_success "  Q${quarter_num}/${year_val}: OK — ${result}"
            (( ++backfill_ok )) || true
        else
            log_error "  Q${quarter_num}/${year_val}: FALLO (rc=${rc})"
            log_error "  ${result}"
            (( ++backfill_err )) || true
        fi
    done <<< "$hist_tables"

    echo ""
    if [[ $backfill_err -eq 0 ]]; then
        log_success "Backfill ETL completado: ${backfill_ok} quarters procesados"
    else
        log_warn "Backfill ETL: ${backfill_ok} OK, ${backfill_err} con errores — revisar job_execution_log"
    fi
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
main() {
    # Argumentos
    local skip_seed="${SKIP_SEED:-0}"
    for arg in "$@"; do
        case "$arg" in
            --skip-seed) skip_seed=1 ;;
            --help|-h)
                echo "Uso: sudo bash scripts/provision-mariadb.sh [--skip-seed]"
                exit 0 ;;
        esac
    done

    local prov="${PROJECT_ROOT}/provisioners/mariadb"
    local sock="/run/mysqld/mysqld.sock"
    local db="${DB_MARIADB_NAME:-ivr_legacy}"
    local db_user="${DB_MARIADB_USER:-django_user}"

    # Exportar para los helpers (usadas también en sql_exec_file/sql_exec_query)
    SOCK="$sock"
    DB="$db"
    DB_USER="$db_user"

    if [[ ! -S "$SOCK" ]]; then
        log_warn "Socket ${SOCK} no encontrado — usando TCP"
        SOCK=""
    fi

    log_header "IACT-db — Provisionamiento MariaDB"
    log_info "PROJECT_ROOT: ${PROJECT_ROOT}"
    log_info "skip_seed:    ${skip_seed}"
    log_info "BD:           ${DB}"
    log_info "Usuario:      ${DB_USER}"
    echo ""

    # ── Paso arrancar ─────────────────────────────────────────────────────────
    log_step 1 6 "Arrancar MariaDB"
    bash "${PROJECT_ROOT}/start.sh" mariadb 2>&1

    if ! mariadb_is_running; then
        log_fatal "MariaDB no está disponible tras start.sh"
    fi

    # FLUSH PRIVILEGES solo si el proceso corre con --skip-grant-tables.
    if ps aux 2>/dev/null | grep -q "[m]ariadbd.*skip.grant.tables"; then
        log_info "skip-grant-tables detectado — ejecutando FLUSH PRIVILEGES"
        mysql --socket=/run/mysqld/mysqld.sock -e "FLUSH PRIVILEGES;" 2>/dev/null \
            && log_success "FLUSH PRIVILEGES completado" \
            || log_warn    "FLUSH PRIVILEGES fallo (no critico)"
    fi

    log_success "MariaDB lista"

    # ── Paso setup ────────────────────────────────────────────────────────────
    log_step 2 6 "BD + usuario + grants base (setup.sh)"
    bash "${prov}/setup.sh"
    log_success "setup.sh completado"

    # ── Paso historico ────────────────────────────────────────────────────────
    log_step 3 6 "Tablas históricas + seed (schema_historico.sh)"
    SKIP_SEED="${skip_seed}" bash "${prov}/schema_historico.sh"
    log_success "schema_historico.sh completado"

    # ── Paso seed ─────────────────────────────────────────────────────────────
    log_step 4 6 "Tabla de prueba tbl_temp_prueba_ivr (schema_seed.sh)"
    bash "${prov}/schema_seed.sh"
    log_success "schema_seed.sh completado"

    # ── Paso SQL: funciones, schema analítico, SPs ────────────────────────────
    log_step 5 6 "Stored Procedures y schema analítico"

    # H-MDB-010: orden de aplicación con dependencias explícitas.
    # No usar números en los nombres de archivo — el orden lo impone esta lista.
    #   funciones_utilidad.sql  prerequisito de schema_base_ivr y SPs
    #   schema_base_ivr.sql     crea tablas analíticas (base_ivr_*, job_*, etl_runs)
    #   sp_etl_pipeline.sql     usa tablas de schema_base_ivr
    #   sp_rpt_reportes.sql     lee base_ivr_detalle
    local sql_deploy_errors=0
    for sql in funciones_utilidad.sql schema_base_ivr.sql \
               sp_etl_pipeline.sql sp_rpt_reportes.sql; do
        local sql_path="${prov}/${sql}"
        if [[ ! -f "$sql_path" ]]; then
            log_warn "  ${sql} no encontrado en ${prov} — omitido"
            continue
        fi
        log_info "  -> ${sql}"
        if sql_exec_file "$sql_path"; then
            log_success "  ${sql} aplicado"
        else
            log_error "  ${sql} fallo — revisar log de MariaDB"
            (( ++sql_deploy_errors )) || true
        fi
    done

    if [[ $sql_deploy_errors -eq 0 ]]; then
        log_success "Todos los archivos SQL aplicados"
    else
        log_warn "${sql_deploy_errors} archivo(s) SQL con errores — revisar antes de continuar"
    fi

    # ── Paso grants ───────────────────────────────────────────────────────────
    # Separado del paso SQL (H-GRANT-001, H-GRANT-002):
    #   · Idempotente — seguro re-ejecutar en cualquier estado
    #   · No depende del éxito de archivos SQL específicos
    #   · Aplica solo en objetos que existen en la BD en este momento
    #   · Si alguna tabla o routine falta, la función lo notifica y sigue
    log_step 6 6 "Grants de acceso (DML + EXECUTE)"

    log_info "DML grants en tablas analíticas:"
    _apply_dml_grants

    log_info "EXECUTE grants en routines:"
    _apply_execute_grants

    # ── Paso 7: backfill ETL (opcional) ──────────────────────────────────────
    # T-4.1 (H-ETL-001): ejecutar solo si RUN_ETL_BACKFILL=1.
    # En instalaciones nuevas pobla base_ivr_detalle y base_ivr_clientes
    # procesando los quarters históricos disponibles.
    # Activar con: sudo RUN_ETL_BACKFILL=1 bash scripts/provision-mariadb.sh
    if [[ "${RUN_ETL_BACKFILL:-0}" == "1" ]]; then
        log_step 7 7 "Backfill ETL (RUN_ETL_BACKFILL=1)"
        _run_etl_backfill
    else
        log_info ""
        log_info "Backfill ETL omitido (RUN_ETL_BACKFILL=${RUN_ETL_BACKFILL:-0})"
        log_info "  Para poblar tablas analíticas: sudo RUN_ETL_BACKFILL=1 bash scripts/provision-mariadb.sh"
    fi

    # ── Verificación nominal ─────────────────────────────────────────────────
    log_info ""
    log_info "Verificando objetos esperados..."
    local verify_errors=0

    for tbl in base_ivr_detalle base_ivr_clientes \
               job_execution_log etl_runs job_config; do
        local exists
        exists=$(sql_exec_query \
            "SELECT COUNT(*) FROM information_schema.TABLES
             WHERE TABLE_SCHEMA='${DB}' AND TABLE_NAME='${tbl}';")
        if [[ "${exists:-0}" -eq 1 ]]; then
            log_debug "  tabla OK: ${tbl}"
        else
            log_error "  tabla FALTANTE: ${tbl} (revisar schema_base_ivr.sql)"
            (( ++verify_errors )) || true
        fi
    done

    local tbl_prueba_exists
    tbl_prueba_exists=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.TABLES
         WHERE TABLE_SCHEMA='${DB}' AND TABLE_NAME='tbl_temp_prueba_ivr';")
    [[ "${tbl_prueba_exists:-0}" -eq 1 ]] \
        && log_debug "  tabla OK: tbl_temp_prueba_ivr" \
        || log_warn  "  tabla FALTANTE: tbl_temp_prueba_ivr"

    # H-F4-001: loop actualizado de 5 a 7 funciones — mismo fix que H-ETL-002
    # en verify.sh. ivr_contar_dias_semana e ivr_agregar_dias_semana son parte
    # de funciones_utilidad.sql desde v1.0.0 pero no estaban en la verificación.
    for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
              fn_duracion_seg ivr_es_dia_semana \
              ivr_contar_dias_semana ivr_agregar_dias_semana; do
        local fn_exists
        fn_exists=$(sql_exec_query \
            "SELECT COUNT(*) FROM information_schema.ROUTINES
             WHERE ROUTINE_SCHEMA='${DB}' AND ROUTINE_NAME='${fn}';")
        if [[ "${fn_exists:-0}" -eq 1 ]]; then
            log_debug "  función OK: ${fn}"
        else
            log_error "  función FALTANTE: ${fn} (revisar funciones_utilidad.sql)"
            (( ++verify_errors )) || true
        fi
    done

    local sp_etl_count sp_rpt_count
    sp_etl_count=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.ROUTINES
         WHERE ROUTINE_SCHEMA='${DB}' AND ROUTINE_TYPE='PROCEDURE'
         AND ROUTINE_NAME LIKE 'sp_etl%';")
    sp_rpt_count=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.ROUTINES
         WHERE ROUTINE_SCHEMA='${DB}' AND ROUTINE_TYPE='PROCEDURE'
         AND ROUTINE_NAME LIKE 'sp_rpt%';")

    [[ "${sp_etl_count:-0}" -gt 0 ]] \
        && log_debug "  SPs ETL OK: ${sp_etl_count}" \
        || { log_error "  SPs ETL FALTANTES (revisar sp_etl_pipeline.sql)"
             (( ++verify_errors )) || true; }

    [[ "${sp_rpt_count:-0}" -gt 0 ]] \
        && log_debug "  SPs Reporte OK: ${sp_rpt_count}" \
        || { log_error "  SPs Reporte FALTANTES (revisar sp_rpt_reportes.sql)"
             (( ++verify_errors )) || true; }

    # Verificar que los grants EXECUTE están aplicados
    local exec_grants_count
    exec_grants_count=$(sql_exec_query \
        "SELECT COUNT(DISTINCT Routine_name) FROM mysql.procs_priv
         WHERE User='${DB_USER}' AND Db='${DB}'
         AND Proc_priv LIKE '%Execute%';" "mysql")

    if [[ "${exec_grants_count:-0}" -gt 0 ]]; then
        log_debug "  GRANT EXECUTE OK: ${exec_grants_count} routines"
    else
        log_error "  GRANT EXECUTE faltante — django_user no puede invocar routines"
        (( ++verify_errors )) || true
    fi

    echo ""
    local sp_count table_count
    sp_count=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.ROUTINES
         WHERE ROUTINE_SCHEMA='${DB}';")
    table_count=$(sql_exec_query \
        "SELECT COUNT(*) FROM information_schema.TABLES
         WHERE TABLE_SCHEMA='${DB}' AND TABLE_TYPE='BASE TABLE';")

    if [[ $verify_errors -eq 0 ]]; then
        log_success "Provisionamiento completado — ${sp_count:-0} routines, ${table_count:-0} tablas"
    else
        log_error   "Verificación: ${verify_errors} objeto(s) faltante(s) — revisar errores anteriores"
    fi

    echo ""
    log_info "Para verificar el entorno completo: bash verify.sh"
}

main "$@"

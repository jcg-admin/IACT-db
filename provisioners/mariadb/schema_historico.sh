#!/bin/bash
# =============================================================================
# provisioners/mariadb/schema_historico.sh
# Crea y siembra las tablas tbl_historico_tN_YYYY en ivr_legacy
# =============================================================================
# Tablas generadas:
#   tbl_historico_t1_2025  Q1 2025  2025-01-01 → 2025-03-31
#   tbl_historico_t2_2025  Q2 2025  2025-04-01 → 2025-06-30
#   tbl_historico_t3_2025  Q3 2025  2025-07-01 → 2025-09-30
#   tbl_historico_t4_2025  Q4 2025  2025-10-01 → 2025-12-31
#   tbl_historico_t1_2026  Q1 2026  2026-01-01 → 2026-03-31
#   tbl_historico_t2_2026  Q2 2026  2026-04-01 → en curso (2026-05-06)
#
# IDEMPOTENCIA:
#   · CREATE TABLE IF NOT EXISTS → seguro ejecutar N veces.
#   · seed: por defecto SKIP si la tabla ya tiene datos.
#   · Con FORCE_RESEED=1 → TRUNCATE + re-seed.
#   · Cada ejecucion queda registrada en seed_executions.
#
# ESTABILIDAD DE MARIADB:
#   El seed puede tardar varios minutos. Antes de iniciar se verifica que
#   MariaDB responda de forma estable (STABILITY_CHECKS pings consecutivos
#   en STABILITY_INTERVAL segundos). Si el servidor cae durante el seed,
#   el script detecta el fallo y aborta con un mensaje claro en lugar de
#   producir una ejecucion parcial silenciosa.
#
# TRACKING:
#   Tabla seed_executions en ivr_legacy registra:
#   timestamp, tabla, accion, filas_antes, filas_despues,
#   seed_rows_cfg, script_version, commit_hash.
#
# USO:
#   # Normal (idempotente — salta si ya hay datos)
#   sudo bash provisioners/mariadb/schema_historico.sh
#
#   # Con mas registros
#   SEED_ROWS=50000 sudo bash provisioners/mariadb/schema_historico.sh
#
#   # Forzar re-seed (TRUNCATE + reinsertar)
#   FORCE_RESEED=1 sudo bash provisioners/mariadb/schema_historico.sh
#
#   # Solo el schema (sin seed)
#   SKIP_SEED=1 sudo bash provisioners/mariadb/schema_historico.sh
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

# Conexión raíz para operaciones privilegiadas (DDL y seed de tbl_historico_*).
# django_user tiene CNST-003: READ-ONLY sobre ivr_legacy.* — no puede CREATE TABLE
# ni INSERT en tablas históricas. Esta es la conexión correcta para un provisioner.
#
# Mecanismo de resolución (mismo patrón que sql_exec_file en provision-mariadb.sh):
#   1. Socket Unix: sin password en Ubuntu/Debian (peer auth para root)
#   2. TCP fallback: usa DB_MARIADB_ROOT_PASSWORD del .env
DB_ROOT_SOCK="/run/mysqld/mysqld.sock"
DB_ROOT_PASS="${DB_MARIADB_ROOT_PASSWORD:-}"
SEED_ROWS="${SEED_ROWS:-5000}"
FORCE_RESEED="${FORCE_RESEED:-0}"
SKIP_SEED="${SKIP_SEED:-0}"

# Verificacion de estabilidad antes del seed:
#   STABILITY_CHECKS:   numero de pings consecutivos exitosos requeridos
#   STABILITY_INTERVAL: segundos de espera entre cada ping
#   STABILITY_TIMEOUT:  segundos maximos de espera total antes de abortar
STABILITY_CHECKS="${STABILITY_CHECKS:-3}"
STABILITY_INTERVAL="${STABILITY_INTERVAL:-2}"
STABILITY_TIMEOUT="${STABILITY_TIMEOUT:-30}"

SCHEMA_SQL="${SCRIPT_DIR}/schema_historico.sql"
SEED_SQL="${SCRIPT_DIR}/seed_historico.sql"

COMMIT_HASH="$(cd "${PROJECT_ROOT}" && git rev-parse HEAD 2>/dev/null || echo 'sin-git')"
SCRIPT_VERSION="2.1.0"

# ---------------------------------------------------------------------------
# Helpers MySQL
# ---------------------------------------------------------------------------
my_ping() {
    # Retorna 0 si MariaDB responde, 1 si no
    mysql --batch --connect-timeout=3 \
          -h "${DB_HOST}" -P "${DB_PORT}" \
          -u "${DB_USER}" -p"${DB_PASS}" \
          -e "SELECT 1;" >/dev/null 2>&1
}

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

# my_exec_root [args...]
#   Ejecuta una query inline como root.
#   Usado para: verificaciones DDL, conteos en provisioning, estado post-seed.
#   Orden de resolución:
#     1. Socket Unix (sin password — peer auth Ubuntu/Debian)
#     2. TCP con DB_ROOT_PASS como fallback
my_exec_root() {
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_NAME}" "$@" 2>&1
    else
        mysql --batch \
              -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" \
              "${DB_NAME}" "$@" 2>&1
    fi
}

# my_exec_file_root <archivo.sql>
#   Ejecuta un archivo SQL completo como root.
#   Usado exclusivamente para DDL (CREATE TABLE IF NOT EXISTS).
#   django_user tiene CNST-003 READ-ONLY — no puede ejecutar CREATE TABLE.
#   Orden de resolución: socket Unix → TCP con DB_ROOT_PASS.
my_exec_file_root() {
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_NAME}" < "$1" 2>&1
    else
        mysql --batch \
              -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" \
              "${DB_NAME}" < "$1" 2>&1
    fi
}

my_exec_vars() {
    local sql_file="$1"
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
        echo "SET @FORCE_RESEED = ${FORCE_RESEED};"
        echo "SET @COMMIT_HASH  = '${COMMIT_HASH}';"
        echo "SET @SCRIPT_VER   = '${SCRIPT_VERSION}';"
        cat "$sql_file"
    } | mysql --batch \
              -h "${DB_HOST}" -P "${DB_PORT}" \
              -u "${DB_USER}" -p"${DB_PASS}" \
              "${DB_NAME}" 2>&1
}

# my_exec_vars_root <archivo.sql>
#   Ejecuta un archivo SQL con variables de sesión inyectadas, como root.
#   Usado para el seed de tbl_historico_* (INSERT masivo).
#   django_user solo tiene SELECT en ivr_legacy.* (CNST-003) — no puede insertar
#   en tbl_historico_* porque esas tablas no están cubiertas por los grants DML
#   analíticos (que solo aplican a base_ivr_*, job_*, etl_runs).
#   Orden de resolución: socket Unix → TCP con DB_ROOT_PASS.
my_exec_vars_root() {
    local sql_file="$1"
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
        echo "SET @FORCE_RESEED = ${FORCE_RESEED};"
        echo "SET @COMMIT_HASH  = '${COMMIT_HASH}';"
        echo "SET @SCRIPT_VER   = '${SCRIPT_VERSION}';"
        cat "$sql_file"
    } | if [[ -S "${DB_ROOT_SOCK}" ]]; then
            mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_NAME}" 2>&1
        else
            mysql --batch \
                  -h "${DB_HOST}" -P "${DB_PORT}" \
                  -u root -p"${DB_ROOT_PASS}" \
                  "${DB_NAME}" 2>&1
        fi
}

# ---------------------------------------------------------------------------
# verificar_estabilidad_mariadb
#
# Envía STABILITY_CHECKS pings consecutivos con STABILITY_INTERVAL segundos
# entre cada uno. Si todos pasan, la conexión se considera estable.
# Si alguno falla o se supera STABILITY_TIMEOUT, el script aborta.
#
# Esto detecta el caso donde MariaDB arrancó recientemente pero todavía
# está en proceso de recovery (Aria/InnoDB), o donde el proceso cae después
# de unos segundos en entornos sin systemd.
# ---------------------------------------------------------------------------
verificar_estabilidad_mariadb() {
    local checks="${STABILITY_CHECKS}"
    local interval="${STABILITY_INTERVAL}"
    local timeout_total="${STABILITY_TIMEOUT}"
    local elapsed=0
    local consecutivos=0

    log_info "Verificando estabilidad de MariaDB"
    log_info "  Requiere ${checks} pings exitosos consecutivos"
    log_info "  Intervalo entre pings: ${interval}s"
    log_info "  Timeout total: ${timeout_total}s"

    while true; do
        if (( elapsed >= timeout_total )); then
            log_error "Timeout de ${timeout_total}s superado esperando estabilidad de MariaDB."
            log_error "El proceso puede estar arrancando, en recovery o no disponible."
            log_error "Opciones:"
            log_error "  1. Iniciar MariaDB:  sudo service mariadb start"
            log_error "  2. Esperar más:      STABILITY_TIMEOUT=60 bash ${BASH_SOURCE[0]}"
            log_error "  3. Desactivar check: STABILITY_CHECKS=1 bash ${BASH_SOURCE[0]}"
            log_fatal "MariaDB no estable. Seed abortado para evitar ejecucion parcial."
        fi

        if my_ping; then
            # (( ++consecutivos )): pre-incremento — evalúa (( 1 )) → exit 0.
            # (( consecutivos++ )) cuando consecutivos=0 evalúa (( 0 )) → exit 1
            # y set -e mataría el script silenciosamente en el primer ping exitoso.
            (( ++consecutivos ))
            log_info "  Ping ${consecutivos}/${checks} OK (${elapsed}s transcurridos)"
            if (( consecutivos >= checks )); then
                log_success "MariaDB estable — ${checks} pings consecutivos exitosos"
                return 0
            fi
        else
            if (( consecutivos > 0 )); then
                log_warn "  Ping fallido tras ${consecutivos} exitosos — reiniciando contador"
            fi
            consecutivos=0
        fi

        sleep "${interval}"
        (( elapsed += interval ))
    done
}

# ---------------------------------------------------------------------------
# verificar_seed_completo
#
# Después del seed, comprueba que seed_executions registró exactamente
# una fila por cada tabla esperada en la última ejecucion (no SKIP).
# Si alguna tabla no tiene registro o el conteo es 0, el script lo reporta.
# ---------------------------------------------------------------------------
verificar_seed_completo() {
    local tablas=(
        tbl_historico_t1_2025
        tbl_historico_t2_2025
        tbl_historico_t3_2025
        tbl_historico_t4_2025
        tbl_historico_t1_2026
        tbl_historico_t2_2026
    )
    local ok=1

    log_info "Verificando integridad del seed:"

    for tabla in "${tablas[@]}"; do
        local cnt
        cnt=$(my_exec -e "SELECT COUNT(*) FROM ${tabla};" 2>/dev/null | tail -1 || echo "0")

        local ultima_accion
        ultima_accion=$(my_exec -e \
            "SELECT accion FROM seed_executions
             WHERE tabla='${tabla}'
             ORDER BY id DESC LIMIT 1;" 2>/dev/null | tail -1 || echo "N/A")

        if [[ "${cnt}" == "0" && "${ultima_accion}" != "SKIP" ]]; then
            log_error "  FALLO: ${tabla} tiene 0 registros y accion='${ultima_accion}'"
            ok=0
        elif [[ "${cnt}" == "0" ]]; then
            log_warn "  SKIP:  ${tabla} sin datos (accion=${ultima_accion})"
        else
            log_info "  OK:    ${tabla} — ${cnt} registros (accion=${ultima_accion})"
        fi
    done

    if [[ "${ok}" == "0" ]]; then
        log_error ""
        log_error "Una o más tablas quedaron sin datos tras el seed."
        log_error "Probable causa: MariaDB cayó durante la ejecucion."
        log_error "Soluciones:"
        log_error "  1. Asegurar que MariaDB esté estable (sudo service mariadb start)"
        log_error "  2. Re-ejecutar: FORCE_RESEED=1 sudo bash ${BASH_SOURCE[0]}"
        log_fatal "Seed incompleto."
    fi
}

# ---------------------------------------------------------------------------
# main
# ---------------------------------------------------------------------------
main() {
    log_header "IVR Historico — Schema y Seed (6 quarters)"

    log_info "Configuracion:"
    log_info "  DB:                  ${DB_HOST}:${DB_PORT}/${DB_NAME}"
    log_info "  Usuario:             ${DB_USER}"
    log_info "  SEED_ROWS:           ${SEED_ROWS} por quarter"
    log_info "  FORCE_RESEED:        ${FORCE_RESEED}"
    log_info "  SKIP_SEED:           ${SKIP_SEED}"
    log_info "  STABILITY_CHECKS:    ${STABILITY_CHECKS}"
    log_info "  STABILITY_TIMEOUT:   ${STABILITY_TIMEOUT}s"
    log_info "  Commit hash:         ${COMMIT_HASH}"
    log_info "  Script ver:          ${SCRIPT_VERSION}"
    echo ""

    # T-1.5: sin socket Unix, la conexión raíz necesita password explícito.
    # Detectarlo aquí — antes de cualquier MySQL call — produce un error
    # descriptivo en lugar de un "Access denied" críptico en Paso 2.
    if [[ ! -S "${DB_ROOT_SOCK}" ]]; then
        log_warn "Socket ${DB_ROOT_SOCK} no encontrado — se usará TCP para conexión raíz"
        require_vars DB_MARIADB_ROOT_PASSWORD
    fi

    # ------------------------------------------------------------------
    # Paso 1: verificar acceso inicial
    # ------------------------------------------------------------------
    log_step 1 3 "Verificar acceso a MariaDB"

    # Verificar acceso de aplicación (django_user) — confirma conectividad básica
    if ! my_ping; then
        log_error "MariaDB no responde en ${DB_HOST}:${DB_PORT}"
        log_error "Iniciar con: sudo service mariadb start"
        log_fatal "No se puede continuar sin conexion a MariaDB."
    fi
    log_success "Acceso OK"

    # T-1.4: verificar acceso raíz — necesario para CREATE TABLE y seed.
    # my_exec_root usa socket si disponible, TCP con DB_ROOT_PASS como fallback.
    # Un provisioner que falla en DDL sin mensaje claro desperdicia tiempo de debug.
    local root_check
    if ! root_check=$(my_exec_root -e "SELECT 1;" 2>&1); then
        log_error "Sin acceso raíz a MariaDB — requerido para CREATE TABLE y seed."
        log_error "  Socket esperado: ${DB_ROOT_SOCK}"
        log_error "  Estado socket:   $( [[ -S "${DB_ROOT_SOCK}" ]] && echo "existe" || echo "NO existe" )"
        log_error "  Salida: ${root_check}"
        log_error "  Para TCP: asegurarse que DB_MARIADB_ROOT_PASSWORD esté en .env"
        log_fatal "Acceso raíz fallido — no se puede crear tablas ni sembrar datos."
    fi
    log_success "Acceso raíz OK"

    # ------------------------------------------------------------------
    # Paso 2: crear tablas (idempotente — no requiere estabilidad prolongada)
    # ------------------------------------------------------------------
    log_step 2 3 "Crear tablas tbl_historico_tN_YYYY (CREATE TABLE IF NOT EXISTS)"

    if [[ ! -f "$SCHEMA_SQL" ]]; then
        log_fatal "No encontrado: ${SCHEMA_SQL}"
    fi

    # T-1.1: my_exec_file_root — django_user (CNST-003) no tiene CREATE TABLE.
    # T-1.2: capturar output y verificar exit code explícitamente.
    #   Patrón anterior: my_exec_file "..." | while ...; done || true
    #   Problema:        || true descartaba ERROR 1142, 1064 y 2002 por igual,
    #                    emitiendo siempre "Schema aplicado" aunque fallara.
    local schema_output
    if ! schema_output=$(my_exec_file_root "${SCHEMA_SQL}" 2>&1); then
        log_error "schema_historico.sql falló — salida del servidor:"
        while IFS= read -r line; do
            [[ -n "${line}" ]] && log_error "  ${line}"
        done <<< "${schema_output}"
        log_fatal "CREATE TABLE falló — revisar privilegios (root) y sintaxis SQL"
    fi
    while IFS= read -r line; do
        [[ -n "${line}" ]] && log_info "  ${line}"
    done <<< "${schema_output}"
    log_success "Schema aplicado"

    # ------------------------------------------------------------------
    # Paso 3: seed
    # ------------------------------------------------------------------
    if [[ "${SKIP_SEED}" == "1" ]]; then
        log_info "SKIP_SEED=1 — seed omitido."
    else
        log_step 3 3 "Seed de datos"

        # Verificar estabilidad ANTES de iniciar el seed.
        # El seed puede tardar minutos — si MariaDB cae a mitad se
        # generaria una ejecucion parcial sin advertencia.
        verificar_estabilidad_mariadb

        if [[ "${FORCE_RESEED}" == "1" ]]; then
            log_warn "FORCE_RESEED=1 — las tablas seran truncadas antes de sembrar."
        fi

        if [[ ! -f "$SEED_SQL" ]]; then
            log_fatal "No encontrado: ${SEED_SQL}"
        fi

        log_info "Ejecutando seed (esto puede tardar varios minutos)..."

        # T-1.3: my_exec_vars_root — django_user solo tiene SELECT en ivr_legacy.*
        # (CNST-003). Los grants DML analíticos (T-1.4 de provision-mariadb.sh) no
        # cubren tbl_historico_*. El INSERT del seed requiere root.
        if ! my_exec_vars_root "$SEED_SQL" | grep -v "^$" | while IFS= read -r line; do
            log_info "  ${line}"
        done; then
            log_error "El seed falló o fue interrumpido."
            log_error "Probable causa: MariaDB cayó durante la ejecucion."
            log_error "Para re-intentar: FORCE_RESEED=1 sudo bash ${BASH_SOURCE[0]}"
            log_fatal "Seed incompleto."
        fi

        # Verificar que todas las tablas tienen datos tras el seed
        verificar_seed_completo

        log_success "Seed completado y verificado"
    fi

    # ------------------------------------------------------------------
    # Resumen de registros por tabla
    # ------------------------------------------------------------------
    echo ""
    log_info "Estado de las tablas:"
    for tabla in \
        tbl_historico_t1_2025 \
        tbl_historico_t2_2025 \
        tbl_historico_t3_2025 \
        tbl_historico_t4_2025 \
        tbl_historico_t1_2026 \
        tbl_historico_t2_2026; do
        CNT=$(my_exec -e "SELECT COUNT(*) FROM ${tabla};" 2>/dev/null | tail -1 || echo "N/A")
        log_info "  ${tabla}: ${CNT} registros"
    done

    # ------------------------------------------------------------------
    # Historial de ejecuciones (ultimas 10)
    # ------------------------------------------------------------------
    echo ""
    log_info "Ultimas 10 ejecuciones registradas en seed_executions:"
    my_exec -e "
        SELECT
            id,
            DATE_FORMAT(ejecutado_en,'%Y-%m-%d %H:%i:%s') AS cuando,
            tabla,
            accion,
            filas_antes,
            filas_despues,
            seed_rows_cfg,
            LEFT(COALESCE(commit_hash,'N/A'),8) AS commit
        FROM seed_executions
        ORDER BY id DESC
        LIMIT 10;" 2>/dev/null | column -t \
    || log_warn "seed_executions no disponible aun"

    echo ""
    log_success "Script completado. Commit: ${COMMIT_HASH}"
}

main

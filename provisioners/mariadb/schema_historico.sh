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
#   · Nivel 1 (SQL): 1ª ejecucion SEED, ejecuciones siguientes APPEND.
#     Los datos históricos siempre crecen — sin SKIP ni TRUNCATE.
#   · Nivel 2 (Python, opcional): idem APPEND — agrega encima del Nivel 1.
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
#   timestamp, tabla, accion (SEED|APPEND), filas_antes, filas_despues,
#   seed_rows_cfg, script_version, commit_hash.
#
# USO:
#   # Nivel 1 — seed SQL (default, sin dependencias externas)
#   sudo bash provisioners/mariadb/schema_historico.sh
#
#   # Con mas registros base
#   SEED_ROWS=50000 sudo bash provisioners/mariadb/schema_historico.sh
#
#   # Solo el schema (sin seed — útil para migraciones o CI)
#   SKIP_SEED=1 sudo bash provisioners/mariadb/schema_historico.sh
#
#   # Nivel 1 + Nivel 2 (alta fidelidad — requiere Python 3)
#   FULL_SEED=1 sudo bash provisioners/mariadb/schema_historico.sh
#   FULL_SEED=1 SEED_ROWS=50000 sudo bash provisioners/mariadb/schema_historico.sh
#
# PREREQUISITOS:
#   · MariaDB instalado y securizado via provisioners/mariadb/config.sh
#     (config.sh ejecuta _secure_mariadb() que establece password root válida).
#   · DB_MARIADB_ROOT_PASSWORD en .env corresponde al password actual de root.
#   · Socket Unix disponible (auto-detectado) O root accesible via TCP:
#       - Detectado en orden: /run/mysqld/mysqld.sock, /var/run/mysqld/mysqld.sock,
#         /tmp/mysql.sock. Override via MARIADB_SOCK en .env.
#   · Este script usa root para TODO — django_user no se usa aquí.
#     Root: DDL, seed SQL (INSERT masivo), health checks, resumen post-seed.
#     ivr_seed_user: creado en PASO 1; usado para poblar_historico.py (Nivel 2).
#   · Ejecutar como root del sistema operativo: sudo bash schema_historico.sh
#
# CHANGELOG:
#   v2.4.0 (2026-05-10):
#     FASE 3 — Eliminacion de django_user y usuario dedicado de seed:
#       · Eliminados: DB_USER, DB_PASS, my_ping(), my_exec(), my_exec_file(),
#         my_exec_vars() — todas usaban django_user vía TCP
#       · Agregado my_ping_root(): ping via socket Unix (sin password, peer auth)
#         con fallback TCP root; reemplaza my_ping() en verificar_estabilidad_mariadb
#       · verificar_estabilidad_mariadb adaptada a socket-first (my_ping_root)
#       · PASO 1: crea ivr_seed_user con GRANT SELECT,INSERT sobre tbl_historico_*
#         y seed_executions; usado por poblar_historico.py en PASO 4
#       · PASO 4: poblar_historico.py usa ivr_seed_user (antes usaba root)
#       · verificar_seed_completo, resumen e historial: my_exec → my_exec_root
#   v2.3.0 (2026-05-10):
#     FASE 2 — Integración de poblar_historico.py (H-SEED-012..015):
#       · T-2.1: FORCE_RESEED eliminado — variable obsoleta desde seed v3.0.0
#               que ya no usa @FORCE_RESEED (el SP no tiene p_force)
#       · T-2.2: variable FULL_SEED (0/1) — activa PASO 4 con poblar_historico.py
#       · T-2.3: PASO 4 en main(): invoca poblar_historico.py como Nivel 2 cuando
#               FULL_SEED=1, python3 disponible y poblar_historico.py existe;
#               sin --truncate — los datos SQL existentes se conservan (APPEND)
#       · T-2.4: log_step actualizado a 4 pasos totales (antes 3)
#   v2.2.0 (2026-05-10):
#     FASE 0 — Helpers de conexión raíz (H-EXEC-005 prereq):
#       · T-0.1: variables DB_ROOT_SOCK (detección automática de socket) y
#               DB_ROOT_PASS (override via MARIADB_SOCK en .env)
#       · T-0.2: my_exec_root()      — queries inline como root
#       · T-0.3: my_exec_file_root() — archivos SQL como root (DDL)
#       · T-0.4: my_exec_vars_root() — seed con variables de sesión como root
#     FASE 1 — DDL y seed corregidos (H-EXEC-005, H-EXEC-006):
#       · T-1.1: Paso 2 usa my_exec_file_root — django_user sin CREATE TABLE
#       · T-1.2: manejo de errores explícito — elimina || true que swallowaba
#               ERROR 1142, 1064 y 2002 emitiendo siempre SUCCESS falso
#       · T-1.3: seed usa my_exec_vars_root — django_user sin INSERT en tbl_historico_*
#       · T-1.4: Paso 1 verifica acceso raíz con mensaje diagnóstico antes del DDL
#       · T-1.5: require_vars DB_MARIADB_ROOT_PASSWORD solo si no hay socket
#     FASE 2 — column (H-EXEC-007):
#       · T-2.1: historial de seed_executions separado en captura+formato —
#               column ausente ya no dispara WARN "seed_executions no disponible"
#     FASE 3 — SKIP_SEED (H-F3-001):
#       · Fix (( consecutivos++ )) → (( ++consecutivos )) en verificar_estabilidad_mariadb
#               (( var++ )) con set -e cuando var=0 retorna exit 1 y mata el script
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
DB_HOST="${MARIADB_HOST:-127.0.0.1}"
DB_PORT="${MARIADB_PORT:-3306}"

# Conexión raíz — usada para TODO en este script: DDL, seed SQL, health checks.
# django_user (CNST-003: READ-ONLY en ivr_legacy.*) no se usa en schema_historico.sh.
#
# Mecanismo de resolución socket-first (mismo patrón que provision-mariadb.sh):
#   1. Socket Unix: peer auth para root en Ubuntu/Debian — sin password
#   2. TCP fallback: DB_MARIADB_ROOT_PASSWORD del .env
DB_ROOT_SOCK="${MARIADB_SOCK:-}"
# Auto-detectar socket si no viene del .env
if [[ -z "${DB_ROOT_SOCK}" ]]; then
    for _sock in /run/mysqld/mysqld.sock /var/run/mysqld/mysqld.sock /tmp/mysql.sock; do
        [[ -S "${_sock}" ]] && DB_ROOT_SOCK="${_sock}" && break
    done
fi
DB_ROOT_PASS="${DB_MARIADB_ROOT_PASSWORD:-}"

# Usuario dedicado de seed — creado en PASO 1 con privilegios mínimos.
# Separa el acceso de seed del acceso root — principio de menor privilegio.
# Solo puede SELECT e INSERT en tbl_historico_* y seed_executions.
# No puede: CREATE TABLE, DROP, UPDATE, DELETE, ni acceder a otras tablas.
SEED_USER="${MARIADB_SEED_USER:-ivr_seed_user}"
SEED_PASS="${MARIADB_SEED_PASSWORD:-seed_pass_ivr_2024}"
SEED_HOST="localhost"

SEED_ROWS="${SEED_ROWS:-5000}"
# SKIP_SEED=1: omite el seed SQL y el seed Python — solo aplica DDL.
# Útil en migraciones, CI o cuando los datos ya existen.
SKIP_SEED="${SKIP_SEED:-0}"
# FULL_SEED=1: después del seed SQL (Nivel 1) ejecuta poblar_historico.py
# (Nivel 2) para mayor fidelidad: 39+ menús reales, VDNs por menú,
# escalas de volumen históricamente precisas. Requiere Python 3.
# Sin --truncate: los datos del seed SQL se conservan (APPEND).
FULL_SEED="${FULL_SEED:-0}"

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
SCRIPT_VERSION="2.4.0"

# ---------------------------------------------------------------------------
# Helpers MySQL — todos usan root via socket (socket-first)
# ---------------------------------------------------------------------------

# my_ping_root
#   Retorna 0 si MariaDB responde, 1 si no.
#   Usa socket Unix (peer auth para root — sin password) con fallback TCP.
#   Reemplaza my_ping() que usaba django_user — eliminado en v2.4.0.
my_ping_root() {
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --connect-timeout=3 \
              --socket="${DB_ROOT_SOCK}" \
              -e "SELECT 1;" >/dev/null 2>&1
    else
        mysql --batch --connect-timeout=3 \
              -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" \
              -e "SELECT 1;" >/dev/null 2>&1
    fi
}

# my_exec_root [args...]
#   Ejecuta una query inline como root.
#   Usado para: verificaciones, conteos, historial post-seed.
#   Orden de resolución: socket Unix → TCP con DB_ROOT_PASS.
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
#   Usado para DDL (CREATE TABLE IF NOT EXISTS) y schema migrations.
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

# my_exec_vars_root <archivo.sql>
#   Ejecuta un archivo SQL con variables de sesión inyectadas, como root.
#   Usado para seed_historico.sql (CREATE/DROP PROCEDURE requiere root).
#   El SP resultante inserta en tbl_historico_* con privilegios root (DEFINER).
#   Orden de resolución: socket Unix → TCP con DB_ROOT_PASS.
my_exec_vars_root() {
    local sql_file="$1"
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
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
# entre cada uno usando my_ping_root() (socket-first).
# Si todos pasan, la conexión se considera estable.
# Si alguno falla o se supera STABILITY_TIMEOUT, el script aborta.
#
# Detecta: MariaDB arrancó pero está en recovery (Aria/InnoDB), proceso que
# cae después de unos segundos en contenedores sin systemd (H-PROV-001).
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

        if my_ping_root; then
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
        cnt=$(my_exec_root -e "SELECT COUNT(*) FROM ${tabla};" 2>/dev/null | tail -1 || echo "0")

        local ultima_accion
        ultima_accion=$(my_exec_root -e \
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
        log_error "  2. Re-ejecutar: sudo bash ${BASH_SOURCE[0]}"
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
    log_info "  Conexion:            root via socket (${DB_ROOT_SOCK:-TCP})"
    log_info "  Seed user:           ${SEED_USER}@${SEED_HOST}"
    log_info "  SEED_ROWS:           ${SEED_ROWS} por quarter"
    log_info "  SKIP_SEED:           ${SKIP_SEED}"
    log_info "  FULL_SEED:           ${FULL_SEED}"
    log_info "  STABILITY_CHECKS:    ${STABILITY_CHECKS}"
    log_info "  STABILITY_TIMEOUT:   ${STABILITY_TIMEOUT}s"
    log_info "  Commit hash:         ${COMMIT_HASH}"
    log_info "  Script ver:          ${SCRIPT_VERSION}"
    echo ""

    # ------------------------------------------------------------------
    # Paso 1: verificar acceso y crear usuario de seed
    # ------------------------------------------------------------------
    log_step 1 4 "Verificar acceso a MariaDB y crear ivr_seed_user"

    # Verificar acceso raíz — socket-first (my_ping_root).
    # Root es el único usuario de este script desde v2.4.0.
    if ! my_ping_root; then
        log_error "MariaDB no responde (socket: ${DB_ROOT_SOCK:-N/A})"
        log_error "Iniciar con: sudo service mariadb start"
        log_fatal "No se puede continuar sin conexion a MariaDB."
    fi
    log_success "Acceso OK (root via socket)"

    # Verificar acceso raíz con SELECT 1 — confirma permisos reales
    local root_check
    if ! root_check=$(my_exec_root -e "SELECT 1;" 2>&1); then
        log_error "Sin acceso raíz a MariaDB — requerido para DDL y seed."
        log_error "  Socket: ${DB_ROOT_SOCK:-no encontrado}"
        log_error "  Salida: ${root_check}"
        log_error "  Para TCP: asegurarse que DB_MARIADB_ROOT_PASSWORD esté en .env"
        log_fatal "Acceso raíz fallido."
    fi
    log_success "Acceso raíz OK"

    # Crear ivr_seed_user con privilegios mínimos sobre tablas históricas.
    # Principio de menor privilegio: solo SELECT e INSERT en las tablas
    # que el seed necesita — ni DROP, ni UPDATE, ni acceso a otras tablas.
    # CREATE USER IF NOT EXISTS es idempotente — seguro ejecutar N veces.
    #
    # Por qué no usar root para poblar_historico.py:
    #   Root tiene acceso total a todas las bases de datos. El seed Python
    #   solo necesita INSERT en 7 tablas. ivr_seed_user acota el radio de
    #   impacto si el script falla o es comprometido.
    log_info "Creando ivr_seed_user (idempotente)..."
    local seed_user_sql
    seed_user_sql=$(cat <<SQL
CREATE USER IF NOT EXISTS '${SEED_USER}'@'${SEED_HOST}'
    IDENTIFIED BY '${SEED_PASS}';
GRANT SELECT, INSERT ON ${DB_NAME}.tbl_historico_t1_2025 TO '${SEED_USER}'@'${SEED_HOST}';
GRANT SELECT, INSERT ON ${DB_NAME}.tbl_historico_t2_2025 TO '${SEED_USER}'@'${SEED_HOST}';
GRANT SELECT, INSERT ON ${DB_NAME}.tbl_historico_t3_2025 TO '${SEED_USER}'@'${SEED_HOST}';
GRANT SELECT, INSERT ON ${DB_NAME}.tbl_historico_t4_2025 TO '${SEED_USER}'@'${SEED_HOST}';
GRANT SELECT, INSERT ON ${DB_NAME}.tbl_historico_t1_2026 TO '${SEED_USER}'@'${SEED_HOST}';
GRANT SELECT, INSERT ON ${DB_NAME}.tbl_historico_t2_2026 TO '${SEED_USER}'@'${SEED_HOST}';
GRANT SELECT, INSERT ON ${DB_NAME}.seed_executions       TO '${SEED_USER}'@'${SEED_HOST}';
FLUSH PRIVILEGES;
SQL
)
    local seed_user_out
    if ! seed_user_out=$(my_exec_root -e "${seed_user_sql}" 2>&1); then
        log_error "No se pudo crear ${SEED_USER}: ${seed_user_out}"
        log_fatal "Usuario de seed requerido para poblar_historico.py (Nivel 2)."
    fi
    log_success "ivr_seed_user listo (${SEED_USER}@${SEED_HOST})"

    # ------------------------------------------------------------------
    # Paso 2: crear tablas (idempotente — no requiere estabilidad prolongada)
    # ------------------------------------------------------------------
    log_step 2 4 "Crear tablas tbl_historico_tN_YYYY (CREATE TABLE IF NOT EXISTS)"

    if [[ ! -f "$SCHEMA_SQL" ]]; then
        log_fatal "No encontrado: ${SCHEMA_SQL}"
    fi

    # T-1.1: my_exec_file_root — DDL requiere root (CREATE TABLE privilegio).
    # T-1.2: capturar output y verificar exit code explícitamente.
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
        log_info "schema_historico: SKIP_SEED=1 — seed de tbl_historico_* omitido."
    else
        log_step 3 4 "Seed de datos (Nivel 1 — SQL)"

        # Verificar estabilidad ANTES de iniciar el seed.
        # El seed puede tardar minutos — si MariaDB cae a mitad se
        # generaria una ejecucion parcial sin advertencia.
        verificar_estabilidad_mariadb

        if [[ ! -f "$SEED_SQL" ]]; then
            log_fatal "No encontrado: ${SEED_SQL}"
        fi

        log_info "Ejecutando seed (esto puede tardar varios minutos)..."

        # my_exec_vars_root: inyecta variables de sesión y ejecuta como root.
        # Root es necesario porque seed_historico.sql crea y destruye el SP
        # (CREATE/DROP PROCEDURE requiere CREATE ROUTINE o root).
        if ! my_exec_vars_root "$SEED_SQL" | grep -v "^$" | while IFS= read -r line; do
            log_info "  ${line}"
        done; then
            log_error "El seed falló o fue interrumpido."
            log_error "Probable causa: MariaDB cayó durante la ejecucion."
            log_error "Para re-intentar: sudo bash ${BASH_SOURCE[0]}"
            log_fatal "Seed incompleto."
        fi

        # Verificar que todas las tablas tienen datos tras el seed
        verificar_seed_completo

        log_success "Seed completado y verificado"
    fi

    # ------------------------------------------------------------------
    # Paso 4: seed de alta fidelidad con poblar_historico.py (Nivel 2)
    # ------------------------------------------------------------------
    # Activo solo cuando FULL_SEED=1. Requiere Python 3 y que
    # poblar_historico.py exista en el mismo directorio que este script.
    #
    # Comportamiento: APPEND — los datos del Nivel 1 (SQL) se conservan.
    # Sin --truncate: poblar_historico.py agrega registros a los existentes.
    # El Nivel 2 aporta: 39+ menús reales por quarter, 28+ VDNs reales por
    # menú, escalas de volumen históricamente precisas y evolución temporal
    # del catálogo de menús entre quarters.
    # ------------------------------------------------------------------
    log_step 4 4 "Seed de alta fidelidad (Nivel 2 — Python)"

    if [[ "${SKIP_SEED}" == "1" ]]; then
        log_info "schema_historico: SKIP_SEED=1 — poblar_historico.py omitido."

    elif [[ "${FULL_SEED}" != "1" ]]; then
        log_info "FULL_SEED no activo — Nivel 1 (SQL) completado."
        log_info "  Para Nivel 2: FULL_SEED=1 sudo bash ${BASH_SOURCE[0]}"

    elif ! command -v python3 &>/dev/null; then
        log_warn "python3 no encontrado — poblar_historico.py omitido."
        log_warn "  Instalar: sudo apt-get install -y python3"

    elif [[ ! -f "${SCRIPT_DIR}/poblar_historico.py" ]]; then
        log_warn "No encontrado: ${SCRIPT_DIR}/poblar_historico.py — omitido."

    else
        log_info "Ejecutando poblar_historico.py (puede tardar varios minutos)..."
        log_info "  rows base:  ${SEED_ROWS}"
        log_info "  modo:       APPEND (datos SQL existentes conservados)"
        log_info "  usuario:    ${SEED_USER}@${SEED_HOST} (privilegios mínimos)"

        # ivr_seed_user: creado en PASO 1 con SELECT, INSERT en tbl_historico_*
        # y seed_executions. Sin --truncate: los datos del Nivel 1 se conservan.
        local py_out py_exit=0
        py_out=$(python3 "${SCRIPT_DIR}/poblar_historico.py" \
            --rows     "${SEED_ROWS}" \
            --socket   "${DB_ROOT_SOCK}" \
            --user     "${SEED_USER}" \
            --password "${SEED_PASS}" \
            --db       "${DB_NAME}" \
            2>&1) || py_exit=$?

        while IFS= read -r line; do
            [[ -n "${line}" ]] && log_info "  ${line}"
        done <<< "${py_out}"

        if [[ "${py_exit}" -eq 0 ]]; then
            log_success "poblar_historico.py completado"
        else
            log_warn "poblar_historico.py finalizó con errores (exit ${py_exit})"
            log_warn "  Los datos del Nivel 1 (SQL) siguen disponibles."
            log_warn "  Revisar el log anterior para diagnóstico."
        fi
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
        CNT=$(my_exec_root -e "SELECT COUNT(*) FROM ${tabla};" 2>/dev/null | tail -1 || echo "N/A")
        log_info "  ${tabla}: ${CNT} registros"
    done

    # ------------------------------------------------------------------
    # Historial de ejecuciones (ultimas 10)
    # ------------------------------------------------------------------
    echo ""
    log_info "Ultimas 10 ejecuciones registradas en seed_executions:"
    # T-2.1: column -t no está disponible en todos los entornos (Ubuntu minimal).
    # Con la implementación anterior, su ausencia disparaba el || del pipeline
    # y log_warn "seed_executions no disponible aun" — falso negativo: la tabla
    # existía pero el binario faltaba.
    #
    # Solución: capturar el output de la query en una variable.
    #   - Si la query falla (tabla no existe o sin acceso): mostrar el WARN correcto.
    #   - Si la query tiene éxito: formatear con column -t si está disponible,
    #     o imprimir sin formato como fallback.
    # Esto separa "error de query" de "herramienta de formato ausente".
    local seed_hist
    if seed_hist=$(my_exec_root -e "
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
            LIMIT 10;" 2>/dev/null); then
        if command -v column &>/dev/null; then
            echo "${seed_hist}" | column -t
        else
            echo "${seed_hist}"
        fi
    else
        log_warn "seed_executions no disponible aun"
    fi

    echo ""
    log_success "Script completado. Commit: ${COMMIT_HASH}"
}

main

#!/bin/bash
# =============================================================================
# backup_ivr_legacy.sh
# Backup completo de la base de datos ivr_legacy (MariaDB 10.11)
# =============================================================================
# Genera por ejecucion:
#   backups/<timestamp>.sql.gz          dump comprimido (gzip -6)
#   backups/<timestamp>.md5             checksum MD5
#   backups/<timestamp>.log             log de operacion
#   docs/operaciones/backup/HALLAZGOS-BACKUP_<timestamp>.md
#
# USUARIO DE BACKUP:
#   El backup usa ivr_backup_user (no root, no django_user).
#   Creado idempotente en el PASO 1 con privilegios minimos:
#     SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT ON ivr_legacy.*
#     SELECT ON mysql.proc, mysql.event
#     PROCESS, RELOAD ON *.*
#   La creacion requiere root via socket — mismo patron que schema_historico.sh.
#
# CONEXION:
#   Siempre via socket Unix (peer auth para root, password para backup_user).
#   Sin --skip-grant-tables: MariaDB arranca en modo normal para que los
#   GRANTS otorgados al backup_user sean efectivos.
#
# MEJORAS IMPLEMENTADAS (HALLAZGOS-BACKUP_2026-05-07T030045.md):
#   BK-001 — arranque MariaDB con loop de reintento (no sleep fijo)
#   BK-002 — inventario InnoDB marcado como "no confiable"
#   BK-003 — GRANTS ahora SI se incluyen (MariaDB normal, no skip-grant-tables)
#   BK-004 — gzip -6 en lugar de -9 (3x mas rapido, ratio similar)
#   BK-005 — stderr de mysqldump capturado y analizado por separado
#
# CHANGELOG:
#   v2.0.0 (2026-05-10):
#     - ivr_backup_user: usuario dedicado con privilegios minimos
#     - Eliminado --skip-grant-tables del arranque de MariaDB
#     - root via socket para creacion de usuario y arranque verificado
#     - MARIADB_BACKUP_USER / MARIADB_BACKUP_PASSWORD desde .env
#   v1.1.0 (2026-05-07): BK-001..BK-005 implementados
#   v1.0.0 (2026-05-07): version original
#
# Uso: bash provisioners/mariadb/backup_ivr_legacy.sh
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "${SCRIPT_DIR}/../.." && pwd)"

ENV_FILE="${PROJECT_ROOT}/.env"
if [[ -f "${ENV_FILE}" ]]; then set -a; source "${ENV_FILE}"; set +a; fi

# ---------------------------------------------------------------------------
# Configuracion
# ---------------------------------------------------------------------------
DB="${DB_MARIADB_NAME:-ivr_legacy}"
DB_HOST="${MARIADB_HOST:-127.0.0.1}"
DB_PORT="${MARIADB_PORT:-3306}"
DB_ROOT_PASS="${DB_MARIADB_ROOT_PASSWORD:-}"

# Socket Unix — deteccion automatica (mismo patron que schema_historico.sh)
DB_ROOT_SOCK="${MARIADB_SOCK:-}"
if [[ -z "${DB_ROOT_SOCK}" ]]; then
    for _sock in /run/mysqld/mysqld.sock /var/run/mysqld/mysqld.sock /tmp/mysql.sock; do
        [[ -S "${_sock}" ]] && DB_ROOT_SOCK="${_sock}" && break
    done
fi

# ivr_backup_user: privilegios minimos para mysqldump
BACKUP_USER="${MARIADB_BACKUP_USER:-ivr_backup_user}"
BACKUP_PASS="${MARIADB_BACKUP_PASSWORD:-backup_pass_ivr_2024}"
BACKUP_HOST="localhost"

BACKUP_DEST="${PROJECT_ROOT}/backups"
HALLAZGOS_DEST="${PROJECT_ROOT}/docs/operaciones/backup"
HALLAZGOS_INDEX="${HALLAZGOS_DEST}/INDEX.md"

TIMESTAMP=$(date +"%Y-%m-%dT%H%M%S")
BACKUP_NAME="ivr_legacy_${TIMESTAMP}"
DUMP_FILE="${BACKUP_DEST}/${BACKUP_NAME}.sql.gz"
MD5_FILE="${BACKUP_DEST}/${BACKUP_NAME}.md5"
LOG_FILE="${BACKUP_DEST}/${BACKUP_NAME}.log"
STDERR_FILE="${BACKUP_DEST}/${BACKUP_NAME}.mysqldump.stderr"
HALLAZGOS_FILE="${HALLAZGOS_DEST}/HALLAZGOS-BACKUP_${TIMESTAMP}.md"

HALLAZGOS=()
SEVERIDAD_MAX="NINGUNA"

# ---------------------------------------------------------------------------
# Funciones de log y hallazgos
# ---------------------------------------------------------------------------
log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "${LOG_FILE}"; }
die() { log "ERROR FATAL: $*"; _generar_hallazgos; exit 1; }

registrar_hallazgo() {
    local sev="$1" titulo="$2" desc="$3"
    HALLAZGOS+=("${sev}|${titulo}|${desc}")
    case "${sev}" in
        CRITICA) SEVERIDAD_MAX="CRITICA" ;;
        ALTA)    [[ "${SEVERIDAD_MAX}" == "NINGUNA" ]] && SEVERIDAD_MAX="ALTA" ;;
        MEDIA)   [[ "${SEVERIDAD_MAX}" == "NINGUNA" ]] && SEVERIDAD_MAX="MEDIA" ;;
        BAJA)    [[ "${SEVERIDAD_MAX}" == "NINGUNA" ]] && SEVERIDAD_MAX="BAJA" ;;
    esac
    log "  [HALLAZGO ${sev}] ${titulo}"
}

_generar_hallazgos() {
    local total="${#HALLAZGOS[@]}"
    cat > "${HALLAZGOS_FILE}" << HEADER
# Hallazgos del backup — ${TIMESTAMP}

**Script:** \`provisioners/mariadb/backup_ivr_legacy.sh\`
**Backup generado:** \`$(basename "${DUMP_FILE}" 2>/dev/null || echo "N/A")\`
**Total hallazgos:** ${total}
**Severidad maxima:** ${SEVERIDAD_MAX}

---

HEADER

    if [[ "${total}" -eq 0 ]]; then
        echo "Sin hallazgos en esta ejecucion." >> "${HALLAZGOS_FILE}"
    else
        local i=1
        for entry in "${HALLAZGOS[@]}"; do
            local sev title desc
            sev=$(echo "${entry}"  | cut -d'|' -f1)
            title=$(echo "${entry}" | cut -d'|' -f2)
            desc=$(echo "${entry}"  | cut -d'|' -f3-)
            printf "## H%02d — %s [%s]\n\n%s\n\n---\n\n" \
                "${i}" "${title}" "${sev}" "${desc}" >> "${HALLAZGOS_FILE}"
            i=$(( i + 1 ))
        done
    fi

    local idx_entry="| [HALLAZGOS-BACKUP_${TIMESTAMP}.md](HALLAZGOS-BACKUP_${TIMESTAMP}.md) | ${TIMESTAMP} | ${total} | ${SEVERIDAD_MAX} |"
    {
        cat << 'IDXHEADER'
# Indice de hallazgos — proceso de backup ivr_legacy

Cada ejecucion del script genera su propio archivo de hallazgos
con el mismo timestamp ISO del backup al que corresponde.

Formato: HALLAZGOS-BACKUP_YYYY-MM-DDTHHMMSS.md

## Ejecuciones registradas

| Archivo | Fecha | Hallazgos | Severidad maxima |
|---|---|---|---|
IDXHEADER
        if [[ -f "${HALLAZGOS_INDEX}" ]]; then
            grep "^\| \[HALLAZGOS-BACKUP_" "${HALLAZGOS_INDEX}" \
                | grep -v "HALLAZGOS-BACKUP_${TIMESTAMP}" || true
        fi
        echo "${idx_entry}"
    } > "${HALLAZGOS_INDEX}.tmp" && mv "${HALLAZGOS_INDEX}.tmp" "${HALLAZGOS_INDEX}"

    log "Hallazgos: ${HALLAZGOS_FILE} (${total} items, max: ${SEVERIDAD_MAX})"
}

# ---------------------------------------------------------------------------
# Helpers de conexion
# ---------------------------------------------------------------------------

# root_exec: query inline como root via socket-first
root_exec() {
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "$@" 2>&1
    else
        mysql --batch -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" "$@" 2>&1
    fi
}

# root_ping: retorna 0 si MariaDB responde como root
root_ping() {
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

# backup_exec: query inline como ivr_backup_user
backup_exec() {
    mysql --batch --socket="${DB_ROOT_SOCK}" \
          -u"${BACKUP_USER}" -p"${BACKUP_PASS}" "${DB}" "$@" 2>/dev/null
}

# ---------------------------------------------------------------------------
# Inicio
# ---------------------------------------------------------------------------
mkdir -p "${BACKUP_DEST}" "${HALLAZGOS_DEST}"
log "=== Backup ${DB} — ${TIMESTAMP} ==="
log "  Socket:   ${DB_ROOT_SOCK:-NO DETECTADO}"
log "  Destino:  ${BACKUP_DEST}"
log "  Usuario:  ${BACKUP_USER}@${BACKUP_HOST}"

# ---------------------------------------------------------------------------
# PASO 1 — Verificar o arrancar MariaDB (H-PROV-001 en sandbox)
# ---------------------------------------------------------------------------
log "--- PASO 1: Verificar MariaDB ---"
MARIADB_INICIO=$(date +%s)

if ! root_ping; then
    log "MariaDB no responde. Arrancando (modo normal — sin skip-grant-tables)..."

    # Limpiar socket/pid residuales antes de arrancar
    rm -f "${DB_ROOT_SOCK}" /run/mysqld/mysqld.pid 2>/dev/null || true

    # Arranque sin --skip-grant-tables para que los GRANTs sean efectivos
    nohup su -s /bin/bash mysql -c \
        "mariadbd --user=mysql \
                  --socket=${DB_ROOT_SOCK:-/run/mysqld/mysqld.sock} \
                  --datadir=/var/lib/mysql \
                  --pid-file=/run/mysqld/mysqld.pid \
                  --skip-networking=0 \
                  --bind-address=127.0.0.1 --port=${DB_PORT} \
                  --skip-name-resolve \
                  --log-error=/var/log/mysql/error.log" \
        >> "${LOG_FILE}" 2>&1 &

    # Loop de reintento con timeout (BK-001)
    INTENTOS=0
    MAX_INTENTOS=30
    until root_ping; do
        INTENTOS=$(( INTENTOS + 1 ))
        [[ "${INTENTOS}" -ge "${MAX_INTENTOS}" ]] && \
            die "MariaDB no disponible tras ${MAX_INTENTOS}s."
        sleep 1
    done

    MARIADB_FIN=$(date +%s)
    TIEMPO_ARRANQUE=$(( MARIADB_FIN - MARIADB_INICIO ))
    log "MariaDB arrancada en ${TIEMPO_ARRANQUE}s (${INTENTOS} reintentos)."

    registrar_hallazgo "MEDIA" \
        "MariaDB no estaba corriendo al iniciar el backup" \
        "El proceso mariadbd no persistio entre sesiones (H-PROV-001).\
\nArranque en modo normal (sin --skip-grant-tables): ${TIEMPO_ARRANQUE}s, ${INTENTOS} intentos.\
\nEn produccion MariaDB corre como servicio systemd — esto no ocurre."
fi
log "MariaDB OK"

# ---------------------------------------------------------------------------
# PASO 2 — Crear ivr_backup_user (idempotente)
# ---------------------------------------------------------------------------
log "--- PASO 2: Crear ivr_backup_user (idempotente) ---"

BACKUP_USER_SQL="
CREATE USER IF NOT EXISTS '${BACKUP_USER}'@'${BACKUP_HOST}'
    IDENTIFIED BY '${BACKUP_PASS}';
GRANT SELECT, SHOW VIEW, TRIGGER, LOCK TABLES, EVENT
    ON \`${DB}\`.* TO '${BACKUP_USER}'@'${BACKUP_HOST}';
GRANT SELECT ON mysql.proc  TO '${BACKUP_USER}'@'${BACKUP_HOST}';
GRANT SELECT ON mysql.event TO '${BACKUP_USER}'@'${BACKUP_HOST}';
GRANT PROCESS, RELOAD ON *.* TO '${BACKUP_USER}'@'${BACKUP_HOST}';
FLUSH PRIVILEGES;"

if ! root_exec -e "${BACKUP_USER_SQL}" > /dev/null; then
    registrar_hallazgo "ALTA" \
        "No se pudo crear ${BACKUP_USER}" \
        "El script continuara usando root para el dump — revisar permisos."
    log "WARN: ivr_backup_user no creado — usando root como fallback"
    BACKUP_USER="root"
    BACKUP_PASS=""
else
    log "ivr_backup_user listo (${BACKUP_USER}@${BACKUP_HOST})"
    log "  Grants: SELECT,SHOW VIEW,TRIGGER,LOCK TABLES,EVENT en ${DB}.*"
    log "          SELECT en mysql.proc, mysql.event"
    log "          PROCESS, RELOAD globales"
fi

# Verificar que el skip_grant_tables NO está activo (BK-003)
# BUG-005 fix: root_exec puede fallar si la BD no responde.
# Con set -euo pipefail, el pipe falla y set -e mata el script silenciosamente.
# Con || SKIP_GRANT='': si no podemos verificar, asumimos que NO está activo
# (conservador — no marcamos el hallazgo sin evidencia).
SKIP_GRANT=$(root_exec -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    2>/dev/null | awk '/skip_grant_tables/{print $2}') \
    || { log "WARN: no se pudo verificar skip_grant_tables — BD no respondio"; SKIP_GRANT=""; }
if [[ "${SKIP_GRANT}" == "ON" ]]; then
    registrar_hallazgo "MEDIA" \
        "skip_grant_tables activo — GRANTS no garantizados" \
        "MariaDB corre con --skip-grant-tables.\
\nLos GRANTs otorgados a ivr_backup_user pueden no ser efectivos en este modo.\
\nEn produccion este modo no se activa.\
\nReferencia: BK-003"
    log "WARN: skip_grant_tables=ON — modo sandbox detectado"
fi

# ---------------------------------------------------------------------------
# PASO 3 — Inventario InnoDB (referencial) y conteos exactos
# ---------------------------------------------------------------------------
log "--- PASO 3: Inventario de tablas ---"

# Inventario InnoDB — solo referencial, NO confiable para InnoDB (BK-002)
log "  Inventario InnoDB (estimacion — no confiable para InnoDB):"
root_exec "${DB}" -e "
SELECT table_name,
       table_rows                      AS filas_APROX,
       ROUND(data_length/1024/1024, 2) AS mb_datos,
       ENGINE                          AS motor
FROM information_schema.tables
WHERE table_schema = '${DB}'
ORDER BY table_name;" 2>/dev/null | tee -a "${LOG_FILE}"

# Conteos exactos COUNT(*)
log "  Conteos exactos:"
# BUG-005 fix: root_exec puede fallar si la BD no responde.
# Con set -euo pipefail, VAR=$(cmd_fallida) activa set -e y mata el script
# silenciosamente. Con || { ... }: el script continúa con TABLES vacío,
# el while no itera, y se registra el fallo como hallazgo auditable.
TABLES=$(root_exec "${DB}" -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null) \
    || {
        log "WARN: no se pudo obtener lista de tablas — BD no respondio al inventario"
        registrar_hallazgo "MEDIA" \
            "BD no respondio durante el inventario de tablas" \
            "root_exec fallo al consultar information_schema.tables.\
\nEl inventario de conteos (PASO 3) queda vacio.\
\nEl dump del PASO 4 puede proceder si la BD recupera conectividad."
        TABLES=""
    }

TOTAL_ROWS=0
declare -A CONTEOS
while IFS= read -r tbl; do
    [[ -z "${tbl}" ]] && continue
    rows=$(root_exec "${DB}" -N -e "SELECT COUNT(*) FROM \`${tbl}\`;" 2>/dev/null \
           | grep -E '^[0-9]+$' || echo "0")
    TOTAL_ROWS=$(( TOTAL_ROWS + rows ))
    CONTEOS["${tbl}"]="${rows}"
    log "    ${tbl}: ${rows} filas"
done <<< "${TABLES}"
log "  TOTAL: ${TOTAL_ROWS} filas"

# Detectar discrepancias grandes (BK-002)
while IFS= read -r tbl; do
    [[ -z "${tbl}" ]] && continue
    aprox=$(root_exec -e \
        "SELECT table_rows FROM information_schema.tables
         WHERE table_schema='${DB}' AND table_name='${tbl}';" 2>/dev/null \
        | grep -E '^[0-9]+$' || echo "0")
    real="${CONTEOS[${tbl}]:-0}"
    if [[ "${real}" -gt 0 && "${aprox}" -lt $(( real / 2 )) ]]; then
        registrar_hallazgo "BAJA" \
            "Estadisticas InnoDB desactualizadas en ${tbl}" \
            "table_rows reporta ${aprox} pero COUNT(*) real es ${real}.\
\nReferencia: BK-002"
    fi
done <<< "${TABLES}"

# ---------------------------------------------------------------------------
# PASO 4 — Dump con mysqldump (BK-005: stderr separado)
# ---------------------------------------------------------------------------
log "--- PASO 4: Generando dump ---"
log "  Usuario: ${BACKUP_USER}  Destino: $(basename "${DUMP_FILE}")"
T_DUMP_INI=$(date +%s%N)

mysqldump \
    --socket="${DB_ROOT_SOCK}" \
    -u"${BACKUP_USER}" -p"${BACKUP_PASS}" \
    --single-transaction \
    --routines \
    --triggers \
    --events \
    --add-drop-table \
    --add-locks \
    --extended-insert \
    --comments \
    --set-charset \
    "${DB}" \
    2>"${STDERR_FILE}" \
    | gzip -6 > "${DUMP_FILE}"

T_DUMP_FIN=$(date +%s%N)
T_DUMP_MS=$(( (T_DUMP_FIN - T_DUMP_INI) / 1000000 ))
DUMP_SIZE=$(du -h "${DUMP_FILE}" | cut -f1)
log "  Dump: $(basename "${DUMP_FILE}")  Tamanio: ${DUMP_SIZE}  Tiempo: ${T_DUMP_MS}ms"

# Analizar stderr de mysqldump (BK-005)
if [[ -s "${STDERR_FILE}" ]]; then
    STDERR_CONTENT=$(cat "${STDERR_FILE}")
    log "WARN: mysqldump produjo mensajes en stderr:"
    cat "${STDERR_FILE}" | tee -a "${LOG_FILE}"
    registrar_hallazgo "ALTA" \
        "mysqldump genero mensajes en stderr" \
        "Stderr de mysqldump:\n${STDERR_CONTENT}\nReferencia: BK-005"
else
    log "  mysqldump stderr: limpio"
    rm -f "${STDERR_FILE}"
fi

# ---------------------------------------------------------------------------
# PASO 5 — Verificar integridad
# ---------------------------------------------------------------------------
log "--- PASO 5: Verificacion de integridad ---"
DUMP_BYTES=$(stat -c%s "${DUMP_FILE}")
[[ "${DUMP_BYTES}" -lt 1024 ]] && die "El dump parece vacio (${DUMP_BYTES} bytes)."
gzip -t "${DUMP_FILE}" 2>>"${LOG_FILE}" || die "El dump comprimido esta corrupto."
log "  gzip -t: OK  Tamanio: ${DUMP_BYTES} bytes"

# ---------------------------------------------------------------------------
# PASO 6 — Checksum MD5
# ---------------------------------------------------------------------------
log "--- PASO 6: Checksum MD5 ---"
(cd "${BACKUP_DEST}" && md5sum "$(basename "${DUMP_FILE}")") > "${MD5_FILE}"
log "  MD5: $(cat "${MD5_FILE}")"
(cd "${BACKUP_DEST}" && md5sum -c "$(basename "${MD5_FILE}")" 2>&1) \
    | tee -a "${LOG_FILE}" || die "Verificacion MD5 fallida."

# ---------------------------------------------------------------------------
# PASO 7 — Listar backups existentes
# ---------------------------------------------------------------------------
log "--- PASO 7: Backups en ${BACKUP_DEST} ---"
ls -lh "${BACKUP_DEST}"/*.sql.gz 2>/dev/null \
    | awk '{print "  "$9, $5}' | tee -a "${LOG_FILE}" || true

# ---------------------------------------------------------------------------
# PASO 8 — Generar hallazgos
# ---------------------------------------------------------------------------
_generar_hallazgos

# ---------------------------------------------------------------------------
# Resumen
# ---------------------------------------------------------------------------
log "=== Backup completado ==="
log "  Dump:      ${DUMP_FILE}"
log "  Checksum:  ${MD5_FILE}"
log "  Log:       ${LOG_FILE}"
log "  Hallazgos: ${HALLAZGOS_FILE}"
log "  Filas:     ${TOTAL_ROWS}"
log "  Tamanio:   ${DUMP_SIZE}"
log "  Tiempo:    ${T_DUMP_MS}ms"

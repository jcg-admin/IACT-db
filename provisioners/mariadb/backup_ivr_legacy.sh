#!/bin/bash
# backup_ivr_legacy.sh
# Backup completo de la base de datos ivr_legacy (MariaDB 10.1.48)
# Genera por ejecucion:
#   <timestamp>.sql.gz        dump comprimido
#   <timestamp>.md5           checksum
#   <timestamp>.log           log de operacion
#   HALLAZGOS-BACKUP_<timestamp>.md   hallazgos y anomalias detectadas
#
# Mejoras aplicadas segun HALLAZGOS-BACKUP_2026-05-07T030045.md:
#   BK-001 — arranque MariaDB con loop de reintento (no sleep fijo)
#   BK-002 — inventario InnoDB marcado como "no confiable"
#   BK-003 — advertencia explicita de GRANTS no respaldados
#   BK-004 — gzip -6 en lugar de -9 (3x mas rapido, ratio similar)
#   BK-005 — stderr de mysqldump capturado y analizado separado
#
# Uso: bash provisioners/mariadb/backup_ivr_legacy.sh

set -euo pipefail

# ── Configuracion ──────────────────────────────────────────────────────────────
SOCKET="/run/mysqld/mysqld.sock"
DB="ivr_legacy"
USER="django_user"
PASS="django_pass"
BACKUP_DEST="/tmp/references/IACT-db/backups"
HALLAZGOS_DEST="/tmp/references/IACT-db/docs/operaciones/backup"
HALLAZGOS_INDEX="${HALLAZGOS_DEST}/INDEX.md"

TIMESTAMP=$(date +"%Y-%m-%dT%H%M%S")
BACKUP_NAME="ivr_legacy_${TIMESTAMP}"
DUMP_FILE="${BACKUP_DEST}/${BACKUP_NAME}.sql.gz"
MD5_FILE="${BACKUP_DEST}/${BACKUP_NAME}.md5"
LOG_FILE="${BACKUP_DEST}/${BACKUP_NAME}.log"
STDERR_FILE="${BACKUP_DEST}/${BACKUP_NAME}.mysqldump.stderr"
HALLAZGOS_FILE="${HALLAZGOS_DEST}/HALLAZGOS-BACKUP_${TIMESTAMP}.md"

# Acumulador de hallazgos detectados en esta ejecucion
HALLAZGOS=()
SEVERIDAD_MAX="NINGUNA"

# ── Funciones ──────────────────────────────────────────────────────────────────
log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
die() { log "ERROR FATAL: $*"; _generar_hallazgos; exit 1; }

registrar_hallazgo() {
    # registrar_hallazgo SEVERIDAD "TITULO" "DESCRIPCION"
    local sev="$1" titulo="$2" desc="$3"
    HALLAZGOS+=("${sev}|${titulo}|${desc}")
    # Escalar severidad maxima
    case "$sev" in
        CRITICA) SEVERIDAD_MAX="CRITICA" ;;
        ALTA)    [ "$SEVERIDAD_MAX" = "NINGUNA" ] && SEVERIDAD_MAX="ALTA" ;;
        MEDIA)   [ "$SEVERIDAD_MAX" = "NINGUNA" ] && SEVERIDAD_MAX="MEDIA" ;;
        BAJA)    [ "$SEVERIDAD_MAX" = "NINGUNA" ] && SEVERIDAD_MAX="BAJA" ;;
    esac
    log "  [HALLAZGO ${sev}] ${titulo}"
}

_generar_hallazgos() {
    local total="${#HALLAZGOS[@]}"
    local idx_entry=""

    cat > "$HALLAZGOS_FILE" << HEADER
# Hallazgos del backup — ${TIMESTAMP}

**Script:** \`provisioners/mariadb/backup_ivr_legacy.sh\`
**Backup generado:** \`$(basename "$DUMP_FILE" 2>/dev/null || echo "N/A")\`
**Total hallazgos:** ${total}
**Severidad maxima:** ${SEVERIDAD_MAX}

---

HEADER

    if [ "$total" -eq 0 ]; then
        echo "Sin hallazgos en esta ejecucion." >> "$HALLAZGOS_FILE"
    else
        local i=1
        for entry in "${HALLAZGOS[@]}"; do
            local sev title desc
            sev=$(echo "$entry" | cut -d'|' -f1)
            title=$(echo "$entry" | cut -d'|' -f2)
            desc=$(echo "$entry" | cut -d'|' -f3-)
            printf "## H%02d — %s [%s]\n\n%s\n\n---\n\n" \
                "$i" "$title" "$sev" "$desc" >> "$HALLAZGOS_FILE"
            i=$((i+1))
        done
    fi

    idx_entry="| [HALLAZGOS-BACKUP_${TIMESTAMP}.md](HALLAZGOS-BACKUP_${TIMESTAMP}.md) | ${TIMESTAMP} | ${total} | ${SEVERIDAD_MAX} |"

    # Reconstruir INDEX.md desde los archivos existentes + entrada nueva
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
        # Filas existentes (excluir el que acabamos de crear, se agrega al final)
        if [ -f "$HALLAZGOS_INDEX" ]; then
            grep "^| \[HALLAZGOS-BACKUP_" "$HALLAZGOS_INDEX"                 | grep -v "HALLAZGOS-BACKUP_${TIMESTAMP}" || true
        fi
        # Fila nueva
        echo "$idx_entry"
    } > "${HALLAZGOS_INDEX}.tmp" && mv "${HALLAZGOS_INDEX}.tmp" "$HALLAZGOS_INDEX" 

    log "Hallazgos documentados: ${HALLAZGOS_FILE} (${total} items, max: ${SEVERIDAD_MAX})"
}

mysql_cmd() {
    mysql --socket="$SOCKET" -u"$USER" -p"$PASS" "$DB" "$@" 2>/dev/null
}

# ── Inicializar ────────────────────────────────────────────────────────────────
mkdir -p "$BACKUP_DEST" "$HALLAZGOS_DEST"
log "=== Backup ${DB} — ${TIMESTAMP} ==="
log "Dump destino:      ${BACKUP_DEST}"
log "Hallazgos destino: ${HALLAZGOS_DEST}"

# ── 1. Arrancar MariaDB con loop de reintento (BK-001) ────────────────────────
log "--- Verificando MariaDB ---"
MARIADB_INICIO=$(date +%s)
MARIADB_ARRANCADA=false

if ! mysql_cmd -N -e "SELECT 1;" > /dev/null 2>&1; then
    log "MariaDB no responde. Arrancando..."
    rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
    runuser -u mysql -- /usr/sbin/mariadbd \
        --user=mysql \
        --socket="$SOCKET" \
        --datadir=/var/lib/mysql \
        --pid-file=/run/mysqld/mysqld.pid \
        --skip-grant-tables >> "$LOG_FILE" 2>&1 &

    # Loop de reintento: hasta 20 intentos cada 1 segundo (BK-001)
    INTENTOS=0
    MAX_INTENTOS=20
    until mysql_cmd -N -e "SELECT 1;" > /dev/null 2>&1; do
        INTENTOS=$((INTENTOS + 1))
        [ "$INTENTOS" -ge "$MAX_INTENTOS" ] && die "MariaDB no disponible tras ${MAX_INTENTOS}s."
        sleep 1
    done
    MARIADB_ARRANCADA=true
    MARIADB_FIN=$(date +%s)
    TIEMPO_ARRANQUE=$((MARIADB_FIN - MARIADB_INICIO))
    log "MariaDB arrancada en ${TIEMPO_ARRANQUE}s (${INTENTOS} reintentos)."

    registrar_hallazgo "MEDIA" \
        "MariaDB no estaba corriendo al iniciar el backup" \
        "El proceso mariadbd no persistio entre sesiones. Fue necesario arrancarlo.\
\nTiempo de arranque: ${TIEMPO_ARRANQUE}s tras ${INTENTOS} intentos de conexion.\
\nEn produccion MariaDB corre como servicio systemd y esto no ocurre.\
\nReferencia: BK-001 / HALLAZGOS-ENTORNO.md H-001-03"
fi
log "MariaDB OK — socket: ${SOCKET}"

# ── 2. Advertencia skip_grant_tables (BK-003) ─────────────────────────────────
SKIP_GRANT=$(mysql_cmd -N -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    2>/dev/null | awk '{print $2}')
if [ "$SKIP_GRANT" = "ON" ]; then
    registrar_hallazgo "MEDIA" \
        "skip_grant_tables activo — GRANTS no se incluyen en el dump" \
        "MariaDB corre con --skip-grant-tables. El dump NO contiene usuarios ni permisos.\
\nNo puede usarse para restaurar autenticacion en produccion.\
\nPara respaldar GRANTS se requiere acceso root con autenticacion activa.\
\nReferencia: BK-003"
fi

# ── 3. Inventario InnoDB — solo referencial, no confiable (BK-002) ─────────────
log "--- Inventario InnoDB (referencial, NO confiable para InnoDB) ---"
mysql_cmd -e "
SELECT table_name,
       table_rows                      AS filas_APROX_innodb,
       ROUND(data_length/1024/1024, 2) AS mb
FROM information_schema.tables
WHERE table_schema = '${DB}'
ORDER BY table_name;" 2>/dev/null | tee -a "$LOG_FILE"
log "NOTA: filas_APROX_innodb es estimacion estadistica, no COUNT(*) real."

# ── 4. Conteos exactos COUNT(*) ───────────────────────────────────────────────
log "--- Conteos exactos COUNT(*) ---"
TABLES=$(mysql_cmd -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null)

TOTAL_ROWS=0
declare -A CONTEOS
while IFS= read -r tbl; do
    rows=$(mysql_cmd -N -e "SELECT COUNT(*) FROM \`${tbl}\`;" 2>/dev/null)
    TOTAL_ROWS=$((TOTAL_ROWS + rows))
    CONTEOS[$tbl]=$rows
    log "  ${tbl}: ${rows} filas"
done <<< "$TABLES"
log "  TOTAL: ${TOTAL_ROWS} filas"

# Detectar discrepancia grande entre aprox y real (BK-002)
while IFS= read -r tbl; do
    aprox=$(mysql_cmd -N -e "
        SELECT table_rows FROM information_schema.tables
        WHERE table_schema='${DB}' AND table_name='${tbl}';" 2>/dev/null)
    real=${CONTEOS[$tbl]:-0}
    if [ "$real" -gt 0 ] && [ "$aprox" -lt $((real / 2)) ]; then
        registrar_hallazgo "BAJA" \
            "Estadisticas InnoDB desactualizadas en ${tbl}" \
            "table_rows reporta ${aprox} pero COUNT(*) real es ${real}.\
\nLas estadisticas InnoDB no estan actualizadas en este entorno.\
\nEl log muestra el COUNT(*) real como valor definitivo.\
\nReferencia: BK-002"
    fi
done <<< "$TABLES"

# ── 5. Dump con mysqldump — stderr separado (BK-005) ──────────────────────────
log "--- Generando dump (gzip -6) ---"
T_DUMP_INI=$(date +%s%N)

mysqldump \
    --socket="$SOCKET" \
    -u"$USER" -p"$PASS" \
    --single-transaction \
    --routines \
    --triggers \
    --add-drop-table \
    --add-locks \
    --extended-insert \
    --comments \
    --set-charset \
    "$DB" \
    2>"$STDERR_FILE" \
    | gzip -6 > "$DUMP_FILE"   # gzip -6: balance velocidad/ratio (BK-004)

T_DUMP_FIN=$(date +%s%N)
T_DUMP_MS=$(( (T_DUMP_FIN - T_DUMP_INI) / 1000000 ))
DUMP_SIZE=$(du -h "$DUMP_FILE" | cut -f1)
log "Dump generado: $(basename "$DUMP_FILE") (${DUMP_SIZE}, ${T_DUMP_MS}ms)"

# Analizar stderr de mysqldump — solo mensajes reales (BK-005)
if [ -s "$STDERR_FILE" ]; then
    STDERR_CONTENT=$(cat "$STDERR_FILE")
    log "ADVERTENCIA: mysqldump produjo mensajes en stderr:"
    cat "$STDERR_FILE" | tee -a "$LOG_FILE"
    registrar_hallazgo "ALTA" \
        "mysqldump genero mensajes en stderr" \
        "Contenido del stderr de mysqldump:\n${STDERR_CONTENT}\
\nVerificar si indica error real o solo advertencia.\
\nReferencia: BK-005"
else
    log "mysqldump stderr: limpio (sin warnings)"
    rm -f "$STDERR_FILE"
fi

# ── 6. Verificar integridad ────────────────────────────────────────────────────
DUMP_BYTES=$(stat -c%s "$DUMP_FILE")
[ "$DUMP_BYTES" -lt 1024 ] && die "El dump parece vacio (${DUMP_BYTES} bytes)."
gzip -t "$DUMP_FILE" 2>>"$LOG_FILE" || die "El dump comprimido esta corrupto."
log "Integridad gzip: OK"

# ── 7. Checksum MD5 ───────────────────────────────────────────────────────────
log "--- Checksum MD5 ---"
(cd "$BACKUP_DEST" && md5sum "$(basename "$DUMP_FILE")") > "$MD5_FILE"
log "MD5: $(cat "$MD5_FILE")"
(cd "$BACKUP_DEST" && md5sum -c "$(basename "$MD5_FILE")" 2>&1) | tee -a "$LOG_FILE" \
    || die "Verificacion MD5 fallida."

# ── 8. Listar backups existentes ──────────────────────────────────────────────
log "--- Backups en ${BACKUP_DEST} ---"
ls -lh "${BACKUP_DEST}"/*.sql.gz 2>/dev/null \
    | awk '{print "  "$9, $5}' | tee -a "$LOG_FILE" || true

# ── 9. Generar archivo de hallazgos ───────────────────────────────────────────
_generar_hallazgos

# ── 10. Resumen ───────────────────────────────────────────────────────────────
log "=== Backup completado ==="
log "  Dump:      ${DUMP_FILE}"
log "  Checksum:  ${MD5_FILE}"
log "  Log:       ${LOG_FILE}"
log "  Hallazgos: ${HALLAZGOS_FILE}"
log "  Filas:     ${TOTAL_ROWS}"
log "  Tamanio:   ${DUMP_SIZE}"
log "  Tiempo:    ${T_DUMP_MS}ms"

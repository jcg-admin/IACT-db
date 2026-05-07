#!/bin/bash
# backup_ivr_legacy.sh
# Backup completo de la base de datos ivr_legacy (MariaDB 10.1.48)
# Genera: dump SQL + checksums MD5
# Uso: bash /tmp/bk/backup_ivr_legacy.sh

set -euo pipefail

# ── Configuracion ──────────────────────────────────────────────────────────────
SOCKET="/run/mysqld/mysqld.sock"
DB="ivr_legacy"
USER="django_user"
PASS="django_pass"
DEST="/tmp/bk"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="ivr_legacy_BACKUP_${TIMESTAMP}"
DUMP_FILE="${DEST}/${BACKUP_NAME}.sql.gz"
MD5_FILE="${DEST}/${BACKUP_NAME}.md5"
LOG_FILE="${DEST}/${BACKUP_NAME}.log"

# ── Funciones ──────────────────────────────────────────────────────────────────
log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
die() { log "ERROR: $*"; exit 1; }

mysql_cmd() {
    mysql --socket="$SOCKET" -u"$USER" -p"$PASS" "$DB" "$@"
}

# ── 1. Verificar que MariaDB responde ─────────────────────────────────────────
log "=== Backup ivr_legacy — inicio ==="
log "Destino: $DEST"

if ! mysql_cmd -N -e "SELECT 1;" > /dev/null 2>&1; then
    log "MariaDB no responde. Intentando arrancar..."
    rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
    runuser -u mysql -- /usr/sbin/mariadbd \
        --user=mysql \
        --socket="$SOCKET" \
        --datadir=/var/lib/mysql \
        --pid-file=/run/mysqld/mysqld.pid \
        --skip-grant-tables >> "$LOG_FILE" 2>&1 &
    sleep 8
    mysql_cmd -N -e "SELECT 1;" > /dev/null 2>&1 \
        || die "MariaDB no disponible tras el arranque."
    log "MariaDB arrancada correctamente."
fi
log "MariaDB OK — socket: $SOCKET"

# ── 2. Inventario previo al dump ──────────────────────────────────────────────
log "--- Inventario de tablas ---"
mysql_cmd -e "
SELECT table_name,
       table_rows          AS filas_aprox,
       ROUND(data_length/1024/1024, 2) AS mb
FROM information_schema.tables
WHERE table_schema = '${DB}'
ORDER BY table_name;
" 2>/dev/null | tee -a "$LOG_FILE"

SP_COUNT=$(mysql_cmd -N -e "
SELECT COUNT(*) FROM information_schema.routines
WHERE routine_schema='${DB}';" 2>/dev/null)
log "Stored Procedures en la BD: $SP_COUNT"

# ── 3. Conteos exactos (COUNT(*)) ─────────────────────────────────────────────
log "--- Conteos exactos ---"
TABLES=$(mysql_cmd -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null)

TOTAL_ROWS=0
while IFS= read -r tbl; do
    rows=$(mysql_cmd -N -e "SELECT COUNT(*) FROM \`${tbl}\`;" 2>/dev/null)
    TOTAL_ROWS=$((TOTAL_ROWS + rows))
    log "  ${tbl}: ${rows} filas"
done <<< "$TABLES"
log "  TOTAL: $TOTAL_ROWS filas en toda la BD"

# ── 4. Dump con mysqldump ──────────────────────────────────────────────────────
log "--- Generando dump ---"
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
    "$DB" 2>>"$LOG_FILE" \
    | gzip -9 > "$DUMP_FILE"

log "Dump generado: $(basename "$DUMP_FILE")"
log "Tamaño: $(du -h "$DUMP_FILE" | cut -f1)"

# ── 5. Verificar que el dump no está vacío ────────────────────────────────────
DUMP_SIZE=$(stat -c%s "$DUMP_FILE")
[ "$DUMP_SIZE" -lt 1024 ] && die "El dump parece vacío ($DUMP_SIZE bytes)."

# Verificar que se puede descomprimir (primeros 512 bytes)
gzip -t "$DUMP_FILE" 2>>"$LOG_FILE" || die "El dump comprimido está corrupto."
log "Integridad gzip: OK"

# ── 6. Generar checksums MD5 ──────────────────────────────────────────────────
log "--- Generando checksums ---"
(cd "$DEST" && md5sum "$(basename "$DUMP_FILE")") > "$MD5_FILE"
log "MD5: $(cat "$MD5_FILE")"

# ── 7. Verificar checksums ────────────────────────────────────────────────────
(cd "$DEST" && md5sum -c "$(basename "$MD5_FILE")" 2>&1) | tee -a "$LOG_FILE" \
    || die "Verificacion MD5 fallida."

# ── 8. Resumen final ──────────────────────────────────────────────────────────
log "=== Backup completado exitosamente ==="
log "Archivos generados:"
log "  Dump:      $DUMP_FILE"
log "  Checksum:  $MD5_FILE"
log "  Log:       $LOG_FILE"
log "Filas respaldadas: $TOTAL_ROWS"
log "Tamaño final: $(du -h "$DUMP_FILE" | cut -f1)"

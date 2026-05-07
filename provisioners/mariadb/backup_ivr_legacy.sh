#!/bin/bash
# backup_ivr_legacy.sh
# Backup completo de la base de datos ivr_legacy (MariaDB 10.1.48)
# Genera: dump SQL comprimido + checksum MD5, con timestamp ISO 8601
# Uso: bash provisioners/mariadb/backup_ivr_legacy.sh

set -euo pipefail

# ── Configuracion ──────────────────────────────────────────────────────────────
SOCKET="/run/mysqld/mysqld.sock"
DB="ivr_legacy"
USER="django_user"
PASS="django_pass"
DEST="/tmp/references/IACT-db/backups"

# Timestamp ISO 8601: 2026-05-07T025321
TIMESTAMP=$(date +"%Y-%m-%dT%H%M%S")
BACKUP_NAME="ivr_legacy_${TIMESTAMP}"
DUMP_FILE="${DEST}/${BACKUP_NAME}.sql.gz"
MD5_FILE="${DEST}/${BACKUP_NAME}.md5"
LOG_FILE="${DEST}/${BACKUP_NAME}.log"

# ── Funciones ──────────────────────────────────────────────────────────────────
log() { echo "[$(date '+%H:%M:%S')] $*" | tee -a "$LOG_FILE"; }
die() { log "ERROR: $*"; exit 1; }

mysql_cmd() {
    mysql --socket="$SOCKET" -u"$USER" -p"$PASS" "$DB" "$@"
}

# ── 1. Crear directorio de destino si no existe ───────────────────────────────
mkdir -p "$DEST"

# ── 2. Verificar que MariaDB responde ─────────────────────────────────────────
log "=== Backup ${DB} — ${TIMESTAMP} ==="
log "Destino: ${DEST}"

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
log "MariaDB OK — socket: ${SOCKET}"

# ── 3. Inventario previo al dump ──────────────────────────────────────────────
log "--- Inventario de tablas ---"
mysql_cmd -e "
SELECT table_name,
       table_rows                       AS filas_aprox,
       ROUND(data_length/1024/1024, 2)  AS mb
FROM information_schema.tables
WHERE table_schema = '${DB}'
ORDER BY table_name;
" 2>/dev/null | tee -a "$LOG_FILE"

SP_COUNT=$(mysql_cmd -N -e "
SELECT COUNT(*) FROM information_schema.routines
WHERE routine_schema='${DB}';" 2>/dev/null)
log "Stored Procedures: ${SP_COUNT}"

# ── 4. Conteos exactos COUNT(*) ───────────────────────────────────────────────
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
log "  TOTAL: ${TOTAL_ROWS} filas"

# ── 5. Dump con mysqldump ──────────────────────────────────────────────────────
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

DUMP_SIZE=$(du -h "$DUMP_FILE" | cut -f1)
log "Dump generado: $(basename "$DUMP_FILE") (${DUMP_SIZE})"

# ── 6. Verificar integridad del archivo ───────────────────────────────────────
DUMP_BYTES=$(stat -c%s "$DUMP_FILE")
[ "$DUMP_BYTES" -lt 1024 ] && die "El dump parece vacio (${DUMP_BYTES} bytes)."

gzip -t "$DUMP_FILE" 2>>"$LOG_FILE" || die "El dump comprimido esta corrupto."
log "Integridad gzip: OK"

# ── 7. Generar y verificar checksum MD5 ──────────────────────────────────────
log "--- Checksum MD5 ---"
(cd "$DEST" && md5sum "$(basename "$DUMP_FILE")") > "$MD5_FILE"
log "MD5: $(cat "$MD5_FILE")"

(cd "$DEST" && md5sum -c "$(basename "$MD5_FILE")" 2>&1) | tee -a "$LOG_FILE" \
    || die "Verificacion MD5 fallida."

# ── 8. Listar backups existentes ──────────────────────────────────────────────
log "--- Backups en ${DEST} ---"
ls -lh "${DEST}"/*.sql.gz 2>/dev/null | awk '{print "  "$9, $5}' \
    | tee -a "$LOG_FILE" || true

# ── 9. Resumen ────────────────────────────────────────────────────────────────
log "=== Backup completado ==="
log "  Dump:     ${DUMP_FILE}"
log "  Checksum: ${MD5_FILE}"
log "  Log:      ${LOG_FILE}"
log "  Filas:    ${TOTAL_ROWS}"
log "  Tamanio:  ${DUMP_SIZE}"

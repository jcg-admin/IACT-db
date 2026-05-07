# Hallazgos del proceso de backup — ivr_legacy

**Fecha de ejecucion:** 2026-05-07
**Script analizado:** `provisioners/mariadb/backup_ivr_legacy.sh`
**Ejecuciones realizadas:** 3 (para reproducir y confirmar cada hallazgo)

---

## Resumen ejecutivo

El proceso de backup funciona correctamente y produce un dump integro
y verificado. Sin embargo, se identificaron cinco hallazgos que afectan
la confiabilidad, seguridad o interpretacion de los resultados.

| ID | Severidad | Hallazgo | Estado |
|---|---|---|---|
| BK-001 | CRITICA | MariaDB cae entre llamadas de herramienta | Sin solucion definitiva |
| BK-002 | MEDIA | InnoDB `table_rows` es aproximado e impreciso | Mitigado con COUNT(*) |
| BK-003 | MEDIA | `skip_grant_tables` activo — GRANTS no se respaldan | Documentado |
| BK-004 | BAJA | Compresion gzip -9 tarda 6 segundos | Aceptable |
| BK-005 | BAJA | Grep de warnings busca en datos, no en cabeceras | Falso positivo |

---

## BK-001 — MariaDB cae entre llamadas de herramienta

**Severidad:** CRITICA
**Reproducible:** Si, en el 100% de los casos entre tool calls del sandbox.

### Descripcion

El proceso `mariadbd` que arranca el script de backup no persiste entre
invocaciones del entorno de herramienta. Al ejecutar el backup en una
segunda llamada, el socket `/run/mysqld/mysqld.sock` ya no existe y
la conexion falla con:

```
ERROR 2002 (HY000): Can't connect to local server through socket
'/run/mysqld/mysqld.sock' (111)
```

El script detecta esto y arranca MariaDB automaticamente, pero el
arranque consume **8-9 segundos adicionales** en cada ejecucion donde
la BD no esta corriendo.

### Impacto

- Cada backup en una sesion nueva agrega ~9 segundos de arranque.
- Si el arranque falla (por ejemplo, socket residual), el backup aborta.
- En produccion real MariaDB corre como servicio systemd y este problema
  no existe.

### Mitigacion actual

El script incluye deteccion y arranque automatico:

```bash
if ! mysql_cmd -N -e "SELECT 1;" > /dev/null 2>&1; then
    rm -f /run/mysqld/mysqld.sock /run/mysqld/mysqld.pid
    runuser -u mysql -- /usr/sbin/mariadbd --skip-grant-tables &
    sleep 8
fi
```

### Mejora pendiente

Aumentar el `sleep` a 10 segundos o implementar un loop de reintento
con timeout en lugar de un wait fijo.

---

## BK-002 — InnoDB `table_rows` es aproximado e impreciso

**Severidad:** MEDIA
**Reproducible:** Si, consistente en todas las ejecuciones.

### Descripcion

El inventario inicial del script usa `information_schema.tables.table_rows`
para mostrar el conteo de filas. En tablas InnoDB este valor es una
**estimacion estadistica**, no un conteo exacto, y puede estar muy
alejado de la realidad.

### Datos observados

| Tabla | `table_rows` (aprox) | `COUNT(*)` (real) | Diferencia |
|---|---|---|---|
| tbl_historico_t1_2025 | 2 | 50,000 | -49,998 (-99.9%) |
| tbl_historico_t2_2026 | 0 | 23,100 | -23,100 (-100%) |
| seed_executions | 2 | 3 | -1 (-33%) |
| tbl_historico_t1_2026 | 49,684 | 50,000 | -316 (-0.6%) |
| tbl_temp_prueba_ivr | 3,000 | 3,000 | 0 (exacto) |

La tabla `tbl_historico_t1_2025` reporta 2 filas cuando tiene 50,000.
La tabla `tbl_historico_t2_2026` reporta 0 filas cuando tiene 23,100.

### Causa raiz

InnoDB mantiene estadisticas de filas en memoria y las actualiza
periodicamente via `ANALYZE TABLE` o `innodb_stats_auto_recalc`.
En este entorno de sandbox con `--skip-grant-tables` y sin persistencia
entre sesiones, las estadisticas no se actualizan correctamente.

### Impacto

El inventario inicial del backup muestra datos engañosos. Un operador
que lea el log podria concluir erroneamente que `tbl_historico_t1_2025`
tiene solo 2 filas y que el backup esta vacio o corrupto.

### Mitigacion actual

El script hace `COUNT(*)` exacto por cada tabla en el paso 4, que si
refleja la realidad. El inventario InnoDB es solo referencial.

### Mejora propuesta

Eliminar el inventario InnoDB del log o marcarlo explicitamente como
"aproximado — no confiable". Usar solo los conteos exactos para
determinar si el backup es valido.

---

## BK-003 — `skip_grant_tables` activo — GRANTS no se respaldan

**Severidad:** MEDIA

### Descripcion

MariaDB arranca con `--skip-grant-tables` en este entorno. Esto tiene
dos consecuencias para el backup:

**a) Los GRANTS no se incluyen en el dump.**
`mysqldump` no puede leer `mysql.user` ni `mysql.db` correctamente
con skip-grant-tables activo para incluirlos en el dump. El dump
resultante no contiene ningun `GRANT` ni `CREATE USER`.

**b) Cualquier usuario puede conectarse sin password.**
Durante el proceso de backup, la BD es accesible sin autenticacion
desde cualquier proceso del sistema.

### Variables observadas

```
skip_grant_tables  ON
skip_networking    OFF   (TCP activo — accesible por red local)
have_ssl           DISABLED
local_infile       ON
secure_file_priv   (vacio — sin restriccion de directorio)
```

### Impacto

Un backup de este entorno NO puede usarse para restaurar permisos en
produccion. Solo sirve para restaurar datos y estructura de tablas.

Para produccion, los GRANTS se deben respaldar por separado con:
```bash
mysqldump --socket=... -u root -p \
  --no-data --no-create-info \
  --skip-opt --single-transaction \
  mysql > grants_backup.sql
```

### Estado

Documentado. En produccion MariaDB NO corre con skip-grant-tables
y los GRANTS si se incluiran en el dump automaticamente.

---

## BK-004 — Compresion gzip -9 es lenta

**Severidad:** BAJA

### Descripcion

El dump SQL sin comprimir de `ivr_legacy` pesa **40.5 MB** (283,537 filas).
La compresion con `gzip -9` (maxima) tarda **~6 segundos** adicionales
y produce un archivo de **7.4 MB** (ratio de compresion del 19%).

### Tiempos medidos

| Etapa | Tiempo |
|---|---|
| Arranque MariaDB (si no esta corriendo) | ~9 segundos |
| `mysqldump` | ~800 ms |
| `gzip -9` | ~6,194 ms |
| Generacion MD5 | ~50 ms |
| **Total aproximado** | **~16 segundos** (con arranque) |
| **Total sin arranque** | **~7 segundos** |

### Evaluacion

El ratio 19% (7.4 MB de 40.5 MB) es bueno para datos SQL tabulares.
El tiempo de 6 segundos es aceptable para un proceso manual. Si se
automatizara como cron diario, considerar `gzip -6` (balance entre
velocidad y compresion) o `zstd` que es significativamente mas rapido.

### Mejora opcional

```bash
# Alternativa mas rapida con ratio similar:
mysqldump ... | gzip -6 > backup.sql.gz

# O con zstd si esta disponible:
mysqldump ... | zstd -9 > backup.sql.zst
```

---

## BK-005 — Grep de warnings busca en datos, no solo en cabeceras

**Severidad:** BAJA

### Descripcion

El script incluye una verificacion de integridad que busca la cadena
`"warning"` dentro del dump comprimido. Durante el analisis se detecto
que este grep produce un falso positivo al encontrar la cadena en una
fila de datos de `django_migrations`:

```
(9,'auth','0007_alter_validators_add_error_messages','2026-05-05 22:57:45')
```

El nombre de la migracion contiene la palabra `error_messages`, que
contiene `error`, y activa el grep incorrectamente.

### Impacto

El grep actual podria alarmar sobre un dump limpio, o peor, podria
ignorar warnings reales si estan mezclados con datos que contienen
esas palabras.

### Mejora propuesta

Separar el stderr de `mysqldump` del contenido del dump. Los warnings
reales de mysqldump van a stderr, no al cuerpo del SQL:

```bash
# Correcto: capturar stderr de mysqldump separado
mysqldump ... 2>/tmp/dump_stderr.txt | gzip -9 > "$DUMP_FILE"

# Luego verificar el stderr separado
if [ -s /tmp/dump_stderr.txt ]; then
    log "ADVERTENCIA: mysqldump produjo mensajes en stderr:"
    cat /tmp/dump_stderr.txt | tee -a "$LOG_FILE"
fi
```

---

## Proximas mejoras (backlog)

| Prioridad | Mejora | Relacionado |
|---|---|---|
| Alta | Reemplazar sleep fijo por loop de reintento en arranque MariaDB | BK-001 |
| Alta | Separar stderr de mysqldump del cuerpo del dump para detectar warnings reales | BK-005 |
| Media | Eliminar o marcar como "no confiable" el inventario InnoDB aprox | BK-002 |
| Media | Agregar respaldo separado de GRANTS para entornos con autenticacion activa | BK-003 |
| Baja | Evaluar gzip -6 o zstd para reducir tiempo de compresion | BK-004 |

---

## Ver tambien

- `provisioners/mariadb/backup_ivr_legacy.sh` — script analizado
- `docs/architecture/HALLAZGOS-ENTORNO.md` — hallazgo H-001-03 (MariaDB cae entre tool calls)
- `backups/` — directorio de backups generados


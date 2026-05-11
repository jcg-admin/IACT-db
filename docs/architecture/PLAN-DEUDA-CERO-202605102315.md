# Plan de implementación consolidado — IACT-db deuda cero

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Repositorio:** IACT-db (rama `develop`)  
**Fuente:** Consolidación de todos los hallazgos PENDIENTE en docs/architecture/

---

## Inventario de hallazgos pendientes

Antes de las fases, el mapa completo de lo que hay que resolver.
Los duplicados (mismo problema identificado en distintos documentos)
se consolidan en un solo ID canónico.

| ID canónico | IDs equivalentes | Descripción | Severidad |
|---|---|---|---|
| H-SRV-001 | H-JOB-005, H-SP2-002 | `event_scheduler=ON` no persiste — no está en `my.cnf` | ALTA |
| H-SRV-002 | H-PROV-001 | MariaDB cae en contenedor sin systemd — `start.sh` no verifica persistencia | ALTA |
| H-SEC-001 | H-SEC-002 | `DB_ROOT_SOCK` hardcoded en `schema_historico.sh` — no configurable desde `.env` | MEDIA |
| H-SEC-002 | H-SEC-003 | Root bloqueado para TCP (`authentication_string=invalid`) — fallback TCP roto | MEDIA |
| H-SEC-003 | H-SEC-004 | Prerequisito de securización no documentado en `schema_historico.sh` | BAJA |
| H-PG-001 | H-PG-002 | `pg_hba.conf` sin regla `local scram-sha-256` para socket Unix | ALTA |
| H-PG-002 | H-PG-003 | Repositorio PGDG `focal-pgdg` hardcodeado — falla en Ubuntu 24.04 | MEDIA |
| H-PG-003 | H-PG-004 | `DB_NAME` vs `DB_POSTGRES_NAME` inconsistente en `bootstrap.sh` | MEDIA |
| H-PG-004 | H-PG-005 | `setup.sh` se ejecuta dos veces desde `bootstrap.sh` | BAJA |
| H-ETL-001 | H-SP2-006, H-SP-003 | `base_ivr_*` vacías — ETL histórico no ejecutado en instalación fresca | ALTA |
| H-ETL-002 | H-SP2-005 | `verify.sh` no verifica `ivr_contar_dias_semana` ni `ivr_agregar_dias_semana` | BAJA |
| H-ETL-003 | H-F3-003, H-PROV-003 | `log_fatal` no detiene el script en ciertos contextos de subshell | ALTA |
| H-ARCH-001 | H-SP-004, H-GRANT-008 | `seed_historico_real.sql` obsoleto — referencia `FORCE_RESEED` eliminado en v3.0.0 | MEDIA |
| H-ARCH-002 | — | `FLUJO-ETL-V2.1.md` describe incorrectamente `sp_etl_historico` y columnas de `etl_runs` | BAJA |
| H-VFY-001 | H-F4-003 | `verify.sh` sección 3b verifica históricas antes que analíticas — orden conceptual incorrecto | BAJA |
| H-PROV-002 | — | `postgresql-contrib` no instalado — extensiones opcionales no disponibles | MEDIA |
| H-PROV-003 | — | `PLAN-CORRECCIONES-2026-05-10.md` — Adminer `MARIADB_IP`/`POSTGRES_IP` hardcodeadas | MEDIA |

---

## Criterios de atomicidad

Cada tarea modifica exactamente un archivo o un bloque de un archivo.
La verificación es un comando ejecutable que retorna OK o FALLO sin ambigüedad.
Ninguna tarea tiene más de un prerequisito de otro bloque.

---

## FASE 1 — Infraestructura: persistencia de servicios

Prerequisito de todo lo demás. Sin servicios estables no se puede verificar
ningún otro cambio.

### T-1.1 — `my.cnf`: configurar `event_scheduler=ON` permanente (H-SRV-001)

**Archivo:** `/etc/mysql/mariadb.conf.d/50-server.cnf`

```ini
[mysqld]
event_scheduler = ON
```

**Verificación:**
```bash
grep "event_scheduler" /etc/mysql/mariadb.conf.d/50-server.cnf
# Esperado: event_scheduler = ON

# Tras reinicio:
mysql --socket=/run/mysqld/mysqld.sock \
    -N -e "SHOW GLOBAL VARIABLES LIKE 'event_scheduler';"
# Esperado: event_scheduler | ON
```

---

### T-1.2 — `start.sh`: verificar persistencia 2s post-arranque MariaDB (H-SRV-002)

**Archivo:** `start.sh`

**Problema:** `service mariadb start` retorna 0 y sigue como `started=true`
aunque el proceso muera 200ms después. En contenedor sin systemd el proceso
no persiste.

**Acción:** En la función `start_mariadb()`, después de `service mariadb start`:

```bash
# Verificar que el proceso persiste después de arrancar
sleep 2
if ! mariadb_is_running; then
    log_warn "MariaDB no persistió tras service start — intentando arranque directo"
    nohup su -s /bin/bash mysql -c \
        'mariadbd --datadir=/var/lib/mysql \
                  --socket=/run/mysqld/mysqld.sock \
                  --pid-file=/run/mysqld/mysqld.pid \
                  --user=mysql --event-scheduler=ON \
                  --log-error=/var/log/mysql/error.log' \
        > /tmp/mariadb_direct.log 2>&1 &
    sleep 3
fi
```

**Verificación:**
```bash
bash -n start.sh && echo "Sintaxis: OK"
bash start.sh mariadb
sleep 3
pgrep -x mariadbd && echo "MariaDB persiste"
```

---

### T-1.3 — `provisioners/postgres/install.sh`: corregir repo PGDG (H-PG-002)

**Archivo:** `provisioners/postgres/install.sh`

**Problema:** `focal-pgdg` hardcodeado — en Ubuntu 24.04 el codename es `noble`.

**Acción:**
```bash
# Antes:
PGDG_REPO="deb https://apt.postgresql.org/pub/repos/apt focal-pgdg main"

# Después:
UBUNTU_CODENAME=$(lsb_release -cs 2>/dev/null || . /etc/os-release && echo "$VERSION_CODENAME")
PGDG_REPO="deb https://apt.postgresql.org/pub/repos/apt ${UBUNTU_CODENAME}-pgdg main"
```

**Verificación:**
```bash
bash -n provisioners/postgres/install.sh && echo "Sintaxis: OK"
grep "UBUNTU_CODENAME\|lsb_release" provisioners/postgres/install.sh
```

---

### T-1.4 — `provisioners/postgres/setup.sh`: agregar regla socket Unix en `pg_hba.conf` (H-PG-001)

**Archivo:** `provisioners/postgres/setup.sh`

**Problema:** `pg_hba.conf` no tiene regla `local scram-sha-256` — conexión
socket Unix de Django falla con `peer authentication failed`.

**Acción:**
```bash
# Agregar entrada en pg_hba.conf si no existe:
PG_HBA="/etc/postgresql/${PG_VERSION}/main/pg_hba.conf"
if ! grep -q "^local.*scram-sha-256" "$PG_HBA"; then
    # Insertar ANTES de la línea "local all all peer"
    sed -i '/^local.*all.*all.*peer/i local   all   all   scram-sha-256' "$PG_HBA"
    log_info "pg_hba.conf: regla scram-sha-256 agregada para socket Unix"
fi
```

**Verificación:**
```bash
grep "scram-sha-256" /etc/postgresql/16/main/pg_hba.conf
# Esperado: local   all   all   scram-sha-256

psql -h localhost -U django_user -d iact_analytics -c "SELECT 1;" 2>/dev/null \
    && echo "Conexion socket: OK"
```

---

### T-1.5 — `provisioners/postgres/bootstrap.sh`: deduplicar llamada a `main()` (H-PG-004)

**Archivo:** `provisioners/postgres/bootstrap.sh`

**Problema:** `setup.sh` es ejecutado dos veces — una explícita y una implícita
via `source setup.sh` que ejecuta `main` al final del archivo.

**Acción:** Reemplazar `source setup.sh` por `bash setup.sh` en la línea
correspondiente, o agregar guard en `setup.sh`:

```bash
# En setup.sh — guard para evitar doble ejecución al ser sourced:
[[ "${BASH_SOURCE[0]}" == "${0}" ]] && main "$@"
```

**Verificación:**
```bash
bash -n provisioners/postgres/bootstrap.sh && echo "Sintaxis: OK"
# Verificar que main() no aparece llamada dos veces
grep -c "^main\b\|^main " provisioners/postgres/bootstrap.sh
```

---

### T-1.6 — `provisioners/postgres/bootstrap.sh`: corregir `DB_NAME` vs `DB_POSTGRES_NAME` (H-PG-003)

**Archivo:** `provisioners/postgres/bootstrap.sh`

**Problema:** El script usa `DB_NAME` en algunos lugares y `DB_POSTGRES_NAME`
en otros — cuando solo viene una del `.env`, la otra queda vacía.

**Acción:** Normalizar a `DB_POSTGRES_NAME` en todo el archivo:

```bash
DB_POSTGRES_NAME="${DB_POSTGRES_NAME:-${DB_NAME:-iact_analytics}}"
```

**Verificación:**
```bash
grep "DB_NAME\b" provisioners/postgres/bootstrap.sh | grep -v "DB_POSTGRES_NAME"
# Esperado: 0 líneas
```

---

### T-1.7 — `provisioners/mariadb/install.sh`: instalar `postgresql-contrib` (H-PROV-002)

**Archivo:** `provisioners/mariadb/install.sh` o `provisioners/postgres/install.sh`

**Problema:** `postgresql-contrib` no está instalado — extensiones `uuid-ossp`,
`pg_trgm`, `hstore`, `citext` no disponibles (necesarias en tests de integración).

**Acción:**
```bash
apt-get install -y postgresql-contrib
```

**Verificación:**
```bash
dpkg -l postgresql-contrib | grep "^ii" && echo "INSTALADO"
```

---

## FASE 2 — Infraestructura ETL: pipeline operativo en instalación fresca

### T-2.1 — `provision-mariadb.sh`: agregar PASO backfill en provisionamiento (H-ETL-001)

**Archivo:** `scripts/provision-mariadb.sh`

**Problema:** En instalación fresca, `base_ivr_detalle` y `base_ivr_clientes`
quedan vacías porque `provision-mariadb.sh` no ejecuta el ETL histórico.
Los 7 SPs de reporte retornan 0 filas hasta que alguien recuerda correr
`sp_etl_historico` manualmente.

**Decisión de diseño:** El backfill histórico requiere los datos en
`tbl_historico_*`. `provision-mariadb.sh` los tiene (PASO schema_historico).
Después del PASO grants, agregar PASO backfill opcional:

```bash
# PASO backfill — opcional, controlado por RUN_ETL_BACKFILL (default=0)
# RUN_ETL_BACKFILL=1 corre sp_etl_historico para los 6 quarters del seed.
# Solo tiene efecto si hay datos en tbl_historico_* (seed ejecutado).
if [[ "${RUN_ETL_BACKFILL:-0}" == "1" ]]; then
    log_step 7 7 "Backfill ETL histórico (sp_etl_historico × 6 quarters)"
    _run_etl_backfill
fi
```

Función `_run_etl_backfill()`:

```bash
_run_etl_backfill() {
    local quarters=("2025 1" "2025 2" "2025 3" "2025 4" "2026 1" "2026 2")
    for year_q in "${quarters[@]}"; do
        local year q
        read -r year q <<< "$year_q"
        local label="Q0${q}_$(echo "$year" | cut -c3-4)"
        log_info "  ETL historico ${label} ..."
        local result
        result=$(sql_exec_query "CALL sp_etl_historico(${year}, ${q});" 2>/dev/null \
                 | tail -1)
        log_info "  ${result}"
    done
}
```

**Verificación:**
```bash
bash -n scripts/provision-mariadb.sh && echo "Sintaxis: OK"

RUN_ETL_BACKFILL=1 bash scripts/provision-mariadb.sh --skip-seed 2>/dev/null \
    | grep -E "backfill|sp_etl_historico|OK"

mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -N -e "SELECT trimestre, SUM(total_llamadas)
           FROM base_ivr_detalle GROUP BY trimestre ORDER BY trimestre;"
# Esperado: 6 quarters con datos
```

---

### T-2.2 — `verify.sh`: agregar verificación de dos funciones faltantes (H-ETL-002)

**Archivo:** `verify.sh`

**Problema:** `verify.sh` verifica 5 de 7 funciones de utilidad.
`ivr_contar_dias_semana` e `ivr_agregar_dias_semana` (usadas por
`sp_rpt_centros_xsegmento`) no están en el baseline.

**Acción:** En el loop de verificación de funciones de utilidad, agregar:

```bash
for fn in fn_did_segmento fn_normalizar_menu fn_normalizar_centro \
          fn_duracion_seg ivr_es_dia_semana \
          ivr_contar_dias_semana ivr_agregar_dias_semana; do
```

**Verificación:**
```bash
bash verify.sh 2>/dev/null | grep -E "OK:|Errores:"
# Esperado: baseline sube de 27 a 28 OK (2 nuevas verificaciones — 1 por cada función)
```

---

### T-2.3 — `verify.sh`: reordenar sección 3b — analíticas antes que históricas (H-VFY-001)

**Archivo:** `verify.sh`

**Problema:** La sección 3b verifica `tbl_historico_*` (tablas de datos crudos)
antes que las tablas analíticas (`base_ivr_detalle`, `job_config`, etc.).
El orden conceptual correcto es analíticas primero — son el resultado del pipeline,
no la fuente.

**Acción:** Reordenar los bloques dentro de `check_mariadb_schema()`:
1. Tablas analíticas (base_ivr_*, job_*, etl_runs)
2. Funciones de utilidad
3. SPs ETL
4. SPs de reporte
5. GRANT EXECUTE
6. Tablas históricas (fuente de datos crudos — last)

**Verificación:**
```bash
grep -n "analíticas\|históricas\|Funciones\|SPs ETL\|SPs Reporte\|EXECUTE" \
    verify.sh | head -10
# Verificar que analíticas aparece antes que históricas
```

---

### T-2.4 — `utils/core.sh` o `start.sh`: corregir `log_fatal` en subshells (H-ETL-003)

**Archivo:** `utils/logging.sh` o donde esté definido `log_fatal`

**Problema:** `log_fatal` emite el mensaje de error y llama `exit 1`, pero
cuando se llama dentro de un subshell (ej. dentro de `$(...)` o pipe),
el `exit 1` mata el subshell pero no el script padre — el script continúa
ejecutando con datos incorrectos.

**Diagnóstico:**
```bash
# Comportamiento actual — el script padre ignora el exit del subshell:
result=$(log_fatal "Error crítico")
echo "Esto no debería ejecutarse: $?"  # ← pero sí se ejecuta
```

**Acción:** Agregar `|| exit 1` en todos los call sites donde `log_fatal`
se llama dentro de contextos que podrían ser subshells, o cambiar la
implementación para que emita una señal al proceso padre:

```bash
log_fatal() {
    log_error "$1"
    # Matar el grupo de procesos, no solo el proceso actual
    kill -TERM 0 2>/dev/null || exit 1
}
```

**Verificación:**
```bash
bash -c '
    log_fatal() { echo "FATAL: $1" >&2; kill -TERM 0 2>/dev/null || exit 1; }
    result=$(log_fatal "test")
    echo "no deberia llegar aqui"
'
echo "EXIT: $?"
# Esperado: EXIT != 0, "no deberia llegar aqui" no aparece
```

---

## FASE 3 — Seguridad: configuración de root y socket

### T-3.1 — `schema_historico.sh`: auto-detectar socket en lista de rutas (H-SEC-001)

**Archivo:** `provisioners/mariadb/schema_historico.sh`

**Estado actual:** `DB_ROOT_SOCK` ya tiene auto-detección en v2.4.0 (`for _sock in ...`).
Esta tarea verifica que el `.env.example` exponga `MARIADB_SOCK` como variable
documentada para override.

**Acción:** Agregar en `.env.example`:

```bash
# Socket Unix de MariaDB para conexión root sin password (peer auth)
# Dejar vacío para auto-detección (/run/mysqld/mysqld.sock, /var/run/mysqld/mysqld.sock, /tmp/mysql.sock)
# MARIADB_SOCK=/run/mysqld/mysqld.sock
```

**Verificación:**
```bash
grep "MARIADB_SOCK" .env.example
```

---

### T-3.2 — `provisioners/mariadb/install.sh`: documentar securización y TCP root (H-SEC-002, H-SEC-003)

**Archivo:** `provisioners/mariadb/install.sh`

**Problema:** `secure_mariadb()` desactiva root vía TCP (setting
`authentication_string=invalid`). Esto es correcto para seguridad pero
no está documentado, y `schema_historico.sh` tiene fallback TCP root
que nunca funcionará en un entorno securizado.

**Acción:**
- Agregar al header de `install.sh` una sección `EFECTOS DE SECURIZACIÓN`
  que documente que root TCP queda bloqueado y que el fallback TCP de
  los scripts de provision nunca se activará en producción.
- Agregar al header de `schema_historico.sh`:

```bash
# PREREQUISITO: MariaDB debe estar securizado con secure_mariadb()
#   (provisioners/mariadb/install.sh). El fallback TCP de esta versión
#   no funciona en entornos donde root@TCP tiene authentication_string=invalid.
#   En entornos securizados, solo socket Unix (peer auth) está disponible para root.
```

**Verificación:**
```bash
grep "EFECTOS DE SECURIZACIÓN\|PREREQUISITO\|authentication_string" \
    provisioners/mariadb/install.sh \
    provisioners/mariadb/schema_historico.sh | head -5
```

---

## FASE 4 — Archivado: eliminar artefactos obsoletos

### T-4.1 — Archivar `seed_historico_real.sql` (H-ARCH-001)

**Archivo:** `provisioners/mariadb/seed_historico_real.sql`

**Problema:** Referencia `FORCE_RESEED` y `sp_seed_historico_real` — ambos
eliminados en `seed_historico.sql` v3.0.0. No está referenciado en ningún
script de provisioning activo.

**Acción:** Mover a `docs/referencias/scripts-sql/historico/` con un archivo
`README.md` que explique por qué fue archivado:

```bash
mkdir -p docs/referencias/scripts-sql/historico
mv provisioners/mariadb/seed_historico_real.sql \
   docs/referencias/scripts-sql/historico/
```

```markdown
# seed_historico_real.sql — ARCHIVADO

Archivado en 2026-05-10. Reemplazado por:
- Nivel 1: `provisioners/mariadb/seed_historico.sql` v3.0.0
- Nivel 2: `provisioners/mariadb/poblar_historico.py` v1.1.0

El archivo referenciaba FORCE_RESEED y sp_seed_historico_real,
conceptos eliminados en H-SEED-001..002.
```

**Verificación:**
```bash
ls provisioners/mariadb/seed_historico_real.sql 2>/dev/null \
    && echo "ERROR: no fue archivado" || echo "OK: archivado"
ls docs/referencias/scripts-sql/historico/seed_historico_real.sql
```

---

### T-4.2 — Actualizar `FLUJO-ETL-V2.1.md`: correcciones de H-ARCH-002

**Archivo:** `docs/architecture/FLUJO-ETL-V2.1.md`

**Problemas a corregir:**
1. Sección "Carga histórica": dice que `sp_etl_historico` habilita temporalmente
   `etl_historico` en `job_config` — incorrecto, el SP no toca `job_config`.
2. Sección `etl_runs`: nombres de columnas incorrectos
   (`iniciado_en` → `inicio_at`, `finalizado_en` → `fin_at`,
   `ejecutado_por` → `trigger_source`, `estado` → `status`,
   `'exitoso'` → `'success'`, `'fallido'` → `'failed'`).
3. Heartbeat descrito como 120 segundos — el código real usa 60 segundos.

**Verificación:**
```bash
grep "habilita temporalmente\|iniciado_en\|finalizado_en\|120 segundos" \
    docs/architecture/FLUJO-ETL-V2.1.md | wc -l
# Esperado: 0
```

---

## FASE 5 — Adminer: variables hardcodeadas

### T-5.1 — `provisioners/adminer/bootstrap.sh`: reemplazar IPs hardcodeadas (H-PROV-003)

**Archivo:** `provisioners/adminer/bootstrap.sh`

**Problema:** `MARIADB_IP` y `POSTGRES_IP` hardcodeadas a valores fijos.
En instalación en N servidores, las IPs varían.

**Acción:**
```bash
# Antes:
MARIADB_IP="192.168.56.10"
POSTGRES_IP="192.168.56.20"

# Después:
MARIADB_IP="${MARIADB_HOST:-${DB_MARIADB_HOST:-127.0.0.1}}"
POSTGRES_IP="${POSTGRES_HOST:-${DB_POSTGRES_HOST:-127.0.0.1}}"
```

**Verificación:**
```bash
grep "192\.168\.\|MARIADB_IP\s*=\s*\"[0-9]" \
    provisioners/adminer/bootstrap.sh | grep -v "#"
# Esperado: 0 líneas con IPs hardcodeadas
```

---

## FASE 6 — Documentación: actualizar estados y cerrar referencias

### T-6.1 — Marcar H-SP-003 y H-SP2-006 RESUELTO tras T-2.1

En `HALLAZGOS-SP-PIPELINE-202605102200.md` y
`HALLAZGOS-PIPELINE-ETL-COMPLETO-202605102215.md`:
- H-SP-003 → RESUELTO: `provision-mariadb.sh` ejecuta backfill en PASO 7

### T-6.2 — Marcar H-GRANT-008 y H-SP-004 RESUELTO tras T-4.1

En `HALLAZGOS-PROVISION-GRANTS-202605102300.md` y
`HALLAZGOS-SP-PIPELINE-202605102200.md`:
- H-GRANT-008 → RESUELTO: archivado en docs/referencias/
- H-SP-004 → RESUELTO: mismo artefacto

### T-6.3 — Marcar H-SRV-001 (event_scheduler) RESUELTO tras T-1.1

En `HALLAZGOS-JOB-ETL-SIMULACION-202605102245.md` y
`HALLAZGOS-PIPELINE-ETL-COMPLETO-202605102215.md`:
- H-JOB-005, H-SP2-002 → RESUELTO: `my.cnf` con `event_scheduler=ON`

### T-6.4 — Marcar H-SRV-002 RESUELTO tras T-1.2

En `HALLAZGOS-PROVISIONAMIENTO-202605101945.md`:
- H-PROV-001 → RESUELTO: `start.sh` verifica persistencia

### T-6.5 — Marcar H-PG-001..004 RESUELTOS tras T-1.3..T-1.6

En `HALLAZGOS-PROVISIONER-POSTGRES-2026-05-10.md`:
- H-PG-002 → RESUELTO tras T-1.4
- H-PG-003 → RESUELTO tras T-1.3
- H-PG-004 → RESUELTO tras T-1.6
- H-PG-005 → RESUELTO tras T-1.5

### T-6.6 — Marcar H-SEC-001..003 RESUELTOS tras T-3.1..T-3.2

En `HALLAZGOS-SEGURIDAD-MARIADB-202605101700.md`:
- H-SEC-002 → RESUELTO tras T-3.1
- H-SEC-003 → DOCUMENTADO (por diseño en securización)
- H-SEC-004 → RESUELTO tras T-3.2

---

## Resumen ejecutivo

| FASE | Tareas | Hallazgos que cierra | Archivos | Prioridad |
|---|---|---|---|---|
| FASE 1 — Infraestructura | T-1.1..T-1.7 | H-SRV-001..002, H-PG-001..004, H-PROV-002 | `my.cnf`, `start.sh`, provisioners postgres, install.sh | CRÍTICA |
| FASE 2 — Pipeline ETL | T-2.1..T-2.4 | H-ETL-001..003, H-VFY-001 | `provision-mariadb.sh`, `verify.sh`, `utils/logging.sh` | ALTA |
| FASE 3 — Seguridad | T-3.1..T-3.2 | H-SEC-001..003 | `.env.example`, `install.sh`, `schema_historico.sh` | MEDIA |
| FASE 4 — Archivado | T-4.1..T-4.2 | H-ARCH-001..002 | `seed_historico_real.sql`, `FLUJO-ETL-V2.1.md` | MEDIA |
| FASE 5 — Adminer | T-5.1 | H-PROV-003 | `adminer/bootstrap.sh` | MEDIA |
| FASE 6 — Documentación | T-6.1..T-6.6 | Todos los anteriores | Docs de hallazgos | BAJA |

**Total: 22 tareas atómicas**

## Orden obligatorio

```
FASE 1 (T-1.1 → T-1.7)   prerequisito de todo: sin servicios estables nada funciona
      ↓
FASE 2 (T-2.1 → T-2.4)   requiere FASE 1: backfill depende de MariaDB estable
      ↓
FASE 3 (T-3.1 → T-3.2)   independiente de FASE 2, puede ir en paralelo
FASE 4 (T-4.1 → T-4.2)   independiente de FASE 2, puede ir en paralelo
FASE 5 (T-5.1)            independiente de FASE 2, puede ir en paralelo
      ↓
FASE 6 (T-6.1 → T-6.6)   siempre la última — documenta lo que se implementó
```

Dentro de FASE 1: T-1.1 (my.cnf) → T-1.2 (start.sh) deben ir en ese orden.
T-1.3..T-1.7 son independientes entre sí dentro de FASE 1.

Dentro de FASE 2: T-2.1 (backfill) puede ir antes o después de T-2.2..T-2.4.
T-2.4 (log_fatal) no depende de T-2.1..T-2.3.

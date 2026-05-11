# Plan de validación e implementación — Poblar tablas históricas MySQL

**Versión:** 1.0.0  
**Fecha:** 2026-05-10  
**Objetivo:** Las tablas `tbl_historico_tN_YYYY` en `ivr_legacy` deben contener
datos semilla representativos del IVR real, de modo que el pipeline ETL de
`IACT-api` tenga una fuente de datos operativa.  
**Referencia:** `SOLUCIONES-HALLAZGOS-PROVISIONAMIENTO-202605101945.md`,
`HALLAZGOS-PROVISIONAMIENTO-202605101945.md`

---

## Contexto del problema

### Por qué las tablas están vacías

El `setup.sh mariadb --full` creó correctamente las 6 tablas históricas
(`CREATE TABLE IF NOT EXISTS` via root — FASE 0/1 resueltos). El seed falló
por H-F3-003: `my_exec_vars_root` en `schema_historico.sh` inyecta las
variables de sesión (`@SEED_ROWS`, `@FORCE_RESEED`, etc.) via pipe (`{echo
"SET ..."; cat seed.sql} | mysql --batch`). El cliente mysql en modo `--batch`
**no procesa** la directiva `DELIMITER $$` del SQL — divide el cuerpo del stored
procedure `sp_seed_historico` en sentencias separadas, enviando `LEAVE
sp_seed_historico` fuera del `BEGIN...END` → `ERROR 1308`.

### Qué consumen los scripts Python

El modelo activo en `IACT-api` que lee `ivr_legacy` directamente es:

```python
# callcentersite/apps/ivr/models.py
class TblTempPruebaIvr(models.Model):
    class Meta:
        managed  = False
        db_table = 'tbl_temp_prueba_ivr'   # ← 3000 registros — YA funciona
```

Los endpoints del ETL (`etl_service.py`) y el adaptador IVR (`ivr/adapters.py`)
están desactivados (deuda técnica anotada al 2026-03-21) — apuntaban a una
tabla `call_logs` que no existe en el schema actual. El pipeline real está
diseñado para leer `tbl_historico_*` via stored procedures (`sp_etl_pipeline`,
`sp_rpt_reportes`), que ya existen y están creados.

**Objetivo concreto:** `tbl_historico_*` con datos permite que los SPs
funcionen cuando el ETL sea reactivado. Sin datos, `CALL sp_etl_pipeline(...)` y
`CALL sp_rpt_reportes(...)` procesan conjuntos vacíos.

---

## Criterios de atomicidad

Cada tarea modifica exactamente un punto del sistema y tiene un comando de
verificación ejecutable que pasa o falla sin ambigüedad.

---

## FASE 0 — Pre-condición: estado limpio del entorno

**Objetivo:** Confirmar el estado base antes de modificar cualquier archivo.

---

### T-0.1 — Confirmar que MariaDB y PostgreSQL están activos

```bash
mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent 2>/dev/null \
    && echo "MariaDB: OK" || echo "MariaDB: INACTIVO — ejecutar: bash start.sh mariadb"

pg_isready -h 127.0.0.1 -p 5432 -q 2>/dev/null \
    && echo "PostgreSQL: OK" || echo "PostgreSQL: INACTIVO"
```

**Verificación:** Ambas líneas imprimen `OK`.

---

### T-0.2 — Confirmar estado actual de tablas históricas (0 registros)

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -N -e "SELECT table_name, table_rows
           FROM information_schema.tables
           WHERE table_schema='ivr_legacy'
           AND table_name LIKE 'tbl_historico_%'
           ORDER BY table_name;"
```

**Verificación:** 6 filas, todas con `table_rows = 0`.

---

### T-0.3 — Confirmar que el SP `sp_seed_historico` NO existe (fue creado incorrectamente)

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -N -e "SELECT COUNT(*) FROM information_schema.routines
           WHERE routine_schema='ivr_legacy'
           AND routine_name='sp_seed_historico';"
```

**Verificación:** `0` — el SP no existe porque el DELIMITER lo dividió en
sentencias inválidas antes de que pudiera ser creado.

---

## FASE 1 — Corregir H-PROV-003: `my_exec_vars_root` con archivo temporal

**Archivo:** `provisioners/mariadb/schema_historico.sh`  
**Causa raíz:** pipe → mysql `--batch` no procesa `DELIMITER`. El SP
`sp_seed_historico` usa `DELIMITER $$` para delimitar su cuerpo. La solución
es escribir variables + SQL a un archivo temporal y ejecutarlo sin pipe, de
modo que mysql procese `DELIMITER` correctamente.

---

### T-1.1 — Reemplazar el cuerpo de `my_exec_vars_root` con patrón de archivo temporal

**Acción:** Reemplazar el bloque pipe por:

```bash
my_exec_vars_root() {
    local sql_file="$1"
    local tmp_sql
    tmp_sql=$(mktemp /tmp/iact_seed_XXXXXX.sql)

    # Escribir variables de sesion + contenido del archivo a temp.
    # NO usar pipe: mysql --batch via pipe ignora DELIMITER,
    # dividiendo el SP en sentencias y causando ERROR 1308 LEAVE.
    {
        echo "SET @SEED_ROWS    = ${SEED_ROWS};"
        echo "SET @FORCE_RESEED = ${FORCE_RESEED};"
        echo "SET @COMMIT_HASH  = '${COMMIT_HASH}';"
        echo "SET @SCRIPT_VER   = '${SCRIPT_VERSION}';"
        cat "$sql_file"
    } > "$tmp_sql"

    local exit_code=0
    if [[ -S "${DB_ROOT_SOCK}" ]]; then
        mysql --batch --socket="${DB_ROOT_SOCK}" "${DB_NAME}" \
              < "$tmp_sql" 2>&1
        exit_code=$?
    else
        mysql --batch \
              -h "${DB_HOST}" -P "${DB_PORT}" \
              -u root -p"${DB_ROOT_PASS}" \
              "${DB_NAME}" < "$tmp_sql" 2>&1
        exit_code=$?
    fi

    rm -f "$tmp_sql"
    return "$exit_code"
}
```

**Verificación:**
```bash
bash -n provisioners/mariadb/schema_historico.sh && echo "Sintaxis OK"

# Confirmar que ya no hay pipe en my_exec_vars_root
awk '/^my_exec_vars_root/,/^\}/' \
    provisioners/mariadb/schema_historico.sh | grep "| if\|} |"
# Esperado: 0 líneas (sin pipe)
```

---

### T-1.2 — Verificar que `mktemp` está disponible en el entorno

`mktemp` es POSIX y está disponible en Ubuntu 24.04, pero confirmarlo antes
de depender de él en producción:

```bash
mktemp /tmp/iact_test_XXXXXX.sql && echo "mktemp: OK" | xargs rm -f
```

**Verificación:** `mktemp: OK`.

---

### T-1.3 — Prueba unitaria de `my_exec_vars_root` con SQL que usa `DELIMITER`

Antes de ejecutar el seed completo, verificar que la función corregida puede
crear un SP con `DELIMITER`:

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db
set -a; source .env; set +a

cat > /tmp/test_delimiter.sql << 'EOF'
DROP PROCEDURE IF EXISTS _test_sp_delimiter;
DELIMITER $$
CREATE PROCEDURE _test_sp_delimiter()
_test_sp_delimiter: BEGIN
    SELECT 'DELIMITER_OK' AS resultado;
    LEAVE _test_sp_delimiter;
    SELECT 'NUNCA_LLEGA' AS resultado;
END _test_sp_delimiter$$
DELIMITER ;

CALL _test_sp_delimiter();
DROP PROCEDURE IF EXISTS _test_sp_delimiter;
EOF

# Ejecutar via archivo (no pipe) — debe funcionar
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < /tmp/test_delimiter.sql 2>&1 | grep -E "DELIMITER_OK|ERROR"
rm -f /tmp/test_delimiter.sql
```

**Verificación:** `DELIMITER_OK` aparece, sin `ERROR 1308`.

---

## FASE 2 — Corregir H-PROV-001: verificación de persistencia en `start.sh`

**Archivo:** `start.sh`  
**Causa raíz:** `service mariadb start` en contenedor sin systemd retorna
exit 0 pero el proceso muere silenciosamente al terminar el subshell. La cadena
de arranque no escala al nivel 3 (arranque directo) porque el nivel 1 reportó
éxito sin verificar que el proceso persiste.

---

### T-2.1 — Agregar verificación de persistencia 2s después de `service mariadb start`

**Acción:** En `start_mariadb()`, reemplazar el bloque de nivel 1:

```bash
# Antes:
if command -v service &>/dev/null; then
    log_debug "start_mariadb: intentando via service"
    if service mariadb start 2>/dev/null; then
        log_info "start_mariadb: iniciado via service"
        started=true
    else
        log_debug "start_mariadb: service fallo — continuando cadena"
    fi
fi

# Después:
if command -v service &>/dev/null; then
    log_debug "start_mariadb: intentando via service"
    if service mariadb start 2>/dev/null; then
        # En contenedores sin systemd, service reporta OK pero el proceso
        # puede morir al terminar el subshell (sin supervisor que lo relance).
        # Esperar 2s y verificar que el proceso realmente persiste.
        sleep 2
        if mariadb_is_running; then
            log_info "start_mariadb: iniciado via service (estable)"
            started=true
        else
            log_warn "start_mariadb: service reportó OK pero proceso no persiste"
            log_warn "start_mariadb: sin init system activo — escalando a arranque directo"
        fi
    else
        log_debug "start_mariadb: service fallo — continuando cadena"
    fi
fi
```

**Verificación:**
```bash
bash -n start.sh && echo "Sintaxis OK"
grep -n "sin init system\|proceso no persiste" start.sh
# Esperado: 1 línea con el nuevo mensaje
```

---

### T-2.2 — Probar la cadena completa de arranque con MariaDB inactivo

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db
export LOG_LEVEL=1

# Detener MariaDB si está corriendo
service mariadb stop 2>/dev/null || true
sleep 1

# Ejecutar start.sh — debe detectar que service no persiste y escalar a directo
bash start.sh mariadb 2>&1 \
    | grep -E "iniciado via|no persiste|directo|estable|activo"
echo "EXIT: $?"
```

**Verificación:**
```
# Si service persiste (entorno con init):
start_mariadb: iniciado via service (estable)
MariaDB activo

# Si service no persiste (contenedor sin systemd):
start_mariadb: service reportó OK pero proceso no persiste
start_mariadb: sin init system activo — escalando a arranque directo
MariaDB activo
EXIT: 0
```

En ambos casos EXIT debe ser 0 y MariaDB debe quedar activo.

---

### T-2.3 — Confirmar que MariaDB persiste entre dos invocaciones consecutivas

```bash
bash start.sh mariadb > /dev/null 2>&1
sleep 3
mysqladmin --socket=/run/mysqld/mysqld.sock ping --silent 2>/dev/null \
    && echo "Persistencia: OK" || echo "Persistencia: FALLA"
```

**Verificación:** `Persistencia: OK`.

---

## FASE 3 — Corregir H-PROV-002: extensiones PostgreSQL

**Objetivo:** Instalar `postgresql-contrib` y crear las 4 extensiones opcionales
en `iact_analytics`. Opcional para el objetivo principal (tablas históricas MySQL),
pero necesario para evitar WARN en verify.sh y para funcionalidad futura del ETL
en PostgreSQL.

---

### T-3.1 — Instalar `postgresql-contrib`

```bash
apt-get install -y postgresql-contrib 2>&1 | tail -5
# Si PostgreSQL 16 está instalado:
apt-get install -y postgresql-16 2>/dev/null || true
```

**Verificación:**
```bash
dpkg -l postgresql-contrib 2>/dev/null | grep "^ii"
# Esperado: línea con "ii  postgresql-contrib"
```

---

### T-3.2 — Crear las extensiones en `iact_analytics`

```bash
set -a; source /tmp/references/IACT-db/.env; set +a

for ext in "uuid-ossp" pg_trgm hstore citext; do
    psql -h 127.0.0.1 -U postgres "${DB_POSTGRES_NAME}" \
         -c "CREATE EXTENSION IF NOT EXISTS \"${ext}\";" 2>/dev/null \
         && echo "OK: ${ext}" \
         || echo "WARN: ${ext} no disponible"
done
```

**Verificación:**
```bash
psql -h 127.0.0.1 -U postgres iact_analytics \
    -tAc "SELECT name FROM pg_extension
          WHERE name IN ('uuid-ossp','pg_trgm','hstore','citext')
          ORDER BY name;"
# Esperado: 4 líneas con los nombres de las extensiones
```

---

### T-3.3 — Actualizar `provisioners/postgres/setup.sh` con diagnóstico de paquete

Agregar verificación del paquete `postgresql-contrib` antes de intentar crear
las extensiones, para que el mensaje de error sea accionable:

```bash
# En el bloque de extensiones de provisioners/postgres/setup.sh:
if ! dpkg -l postgresql-contrib 2>/dev/null | grep -q "^ii"; then
    log_warn "postgresql-contrib no instalado — extensiones opcionales omitidas"
    log_warn "  Instalar con: sudo apt-get install -y postgresql-contrib"
else
    for ext in "uuid-ossp" pg_trgm hstore citext; do
        psql_exec "CREATE EXTENSION IF NOT EXISTS \"${ext}\";" 2>/dev/null \
            && log_info "  Extension ${ext}: habilitada" \
            || log_warn "  Extension ${ext}: no disponible (revisar logs)"
    done
fi
```

**Verificación:**
```bash
bash -n provisioners/postgres/setup.sh && echo "Sintaxis OK"
```

---

## FASE 4 — Ejecutar el provisionamiento con las correcciones aplicadas

**Objetivo:** Con H-PROV-001, H-PROV-002 y H-PROV-003 corregidos, ejecutar el
provisionamiento completo y confirmar que `tbl_historico_*` recibe datos.

---

### T-4.1 — Ejecutar `setup.sh mariadb --full` con las correcciones

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db
export LOG_LEVEL=1

bash setup.sh mariadb --full > /tmp/prov_fix.txt 2>&1
EXIT=$?

echo "EXIT: ${EXIT}"
grep -E "STEP|SUCCESS|ERROR|FATAL|Seed completado|tbl_historico|SKIP_SEED" \
    /tmp/prov_fix.txt | sed 's/\x1b\[[0-9;]*m//g'
```

**Verificación esperada:**
```
SKIP_SEED: 0
Schema aplicado
Ping 1/3 OK ... Ping 3/3 OK
MariaDB estable
Seed completado y verificado          ← sin FATAL 1308
EXIT: 0
```

---

### T-4.2 — Confirmar que las 6 tablas tienen datos

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -e "SELECT table_name,
               (SELECT COUNT(*) FROM ivr_legacy.tbl_historico_t1_2025)
               -- usar query dinámica:
        FROM information_schema.tables
        WHERE table_schema='ivr_legacy'
        AND table_name LIKE 'tbl_historico_%'
        ORDER BY table_name;"

# Alternativa directa:
for tbl in tbl_historico_t1_2025 tbl_historico_t2_2025 \
           tbl_historico_t3_2025 tbl_historico_t4_2025 \
           tbl_historico_t1_2026 tbl_historico_t2_2026; do
    cnt=$(mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
                -N -e "SELECT COUNT(*) FROM ${tbl};" 2>/dev/null)
    [[ "${cnt:-0}" -gt 0 ]] \
        && echo "OK:   ${tbl}: ${cnt} registros" \
        || echo "FALLO: ${tbl}: 0 registros"
done
```

**Verificación:** Las 6 tablas imprimen `OK` con un conteo ≥ 1 (default: 3000).

---

### T-4.3 — Confirmar que `seed_executions` registró el seed

```bash
mysql --socket=/run/mysqld/mysqld.sock -u django_user -p"django_pass" ivr_legacy \
    -e "SELECT tabla, accion, filas_antes, filas_despues
        FROM seed_executions
        ORDER BY id DESC
        LIMIT 6;"
```

**Verificación:** 6 filas con `accion='SEED'` y `filas_despues > 0`.

---

### T-4.4 — Confirmar que los SPs de reporte tienen datos sobre los que operar

```bash
# Llamar un SP de reporte básico para confirmar que no retorna vacío
mysql --socket=/run/mysqld/mysqld.sock -u django_user -p"django_pass" ivr_legacy \
    -e "CALL sp_rpt_reportes('2025-01-01', '2025-03-31');" 2>/dev/null \
    | head -5
```

**Verificación:** El SP retorna filas (no un resultado vacío). Si retorna 0
filas, el seed se ejecutó pero el SP tiene una condición de filtro diferente
a las fechas del Q1 2025 — revisar los parámetros del SP.

---

## FASE 5 — Verificación final del sistema

---

### T-5.1 — Ejecutar `setup.sh postgres` para completar el provisionamiento

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db
export LOG_LEVEL=1

bash setup.sh postgres > /tmp/prov_pg_fix.txt 2>&1
EXIT=$?

echo "EXIT: ${EXIT}"
grep -E "Extension|STEP|SUCCESS|ERROR" /tmp/prov_pg_fix.txt \
    | sed 's/\x1b\[[0-9;]*m//g'
```

**Verificación:** Sin WARN de extensiones (tras FASE 3). EXIT: 0.

---

### T-5.2 — Ejecutar `verify.sh` y confirmar baseline limpio

```bash
cd /tmp/references/IACT-db
export PROJECT_ROOT=/tmp/references/IACT-db
export LOG_LEVEL=1

bash verify.sh > /tmp/verify_fix.txt 2>&1
EXIT=$?

echo "EXIT: ${EXIT} (esperado: 0)"
grep -E "OK:|Advertencias:|Errores:" /tmp/verify_fix.txt \
    | sed 's/\x1b\[[0-9;]*m//g'
```

**Verificación esperada:**
```
OK:           26
Advertencias: 0
Errores:      0
EXIT:         0
```

---

### T-5.3 — Validar que el endpoint IVR de Django puede leer `tbl_temp_prueba_ivr`

Esta tabla ya tiene 3000 registros. La validación confirma que el database
router `ivr` funciona correctamente y que el modelo `TblTempPruebaIvr`
responde:

```bash
cd /tmp/references/IACT-api
python manage.py shell -c "
from apps.ivr.models import TblTempPruebaIvr
qs = TblTempPruebaIvr.objects.using('ivr').all()
print(f'TblTempPruebaIvr: {qs.count()} registros')
print(f'Primer registro: {qs.first()}')
" 2>/dev/null
```

**Verificación:** `TblTempPruebaIvr: 3000 registros`.

---

### T-5.4 — Validar que Django puede leer `tbl_historico_t1_2025` directamente

El modelo `TblTempPruebaIvr` no apunta a las tablas históricas (están
commentadas como deuda técnica). La validación es via conexión raw:

```bash
cd /tmp/references/IACT-api
python manage.py shell -c "
from django.db import connections

with connections['ivr'].cursor() as cursor:
    cursor.execute('SELECT COUNT(*) FROM tbl_historico_t1_2025')
    count = cursor.fetchone()[0]
    print(f'tbl_historico_t1_2025: {count} registros')

    cursor.execute('SELECT COUNT(*) FROM tbl_historico_t2_2025')
    count = cursor.fetchone()[0]
    print(f'tbl_historico_t2_2025: {count} registros')
" 2>/dev/null
```

**Verificación:** Ambas tablas imprimen conteos > 0.

---

### T-5.5 — Documentar estado final

Registrar el resultado de la ejecución completa en:

```
docs/architecture/HALLAZGOS-PROVISIONAMIENTO-202605101945.md
```

Actualizar los estados de H-PROV-001, H-PROV-002 y H-PROV-003 a `RESUELTO`
con referencia a los archivos modificados y los conteos confirmados en T-4.2.

---

## Resumen ejecutivo

| FASE | Tareas | Archivos | Bloquea | Prioridad |
|---|---|---|---|---|
| FASE 0 — Pre-condición | T-0.1..T-0.3 | — | Entorno base | ALTA |
| FASE 1 — Fix H-PROV-003 | T-1.1..T-1.3 | `schema_historico.sh` | Seed completo | CRÍTICA |
| FASE 2 — Fix H-PROV-001 | T-2.1..T-2.3 | `start.sh` | Estabilidad MariaDB | ALTA |
| FASE 3 — Fix H-PROV-002 | T-3.1..T-3.3 | `provisioners/postgres/setup.sh`, entorno | verify.sh 0 WARN | BAJA |
| FASE 4 — Provisionamiento | T-4.1..T-4.4 | — | Datos en tablas | CRÍTICA |
| FASE 5 — Validación final | T-5.1..T-5.5 | docs | Cierre | — |

**Total: 18 tareas atómicas**

---

## Orden de ejecución obligatorio

```
FASE 0 → FASE 1 → FASE 2 → FASE 3 → FASE 4 → FASE 5
```

**FASE 1 antes de FASE 4:** T-4.1 ejecuta `setup.sh mariadb --full`, que llama
`schema_historico.sh`, que llama `my_exec_vars_root`. Si FASE 1 no está aplicada,
el seed falla de nuevo con ERROR 1308.

**FASE 2 antes de FASE 4:** Si MariaDB no persiste entre invocaciones, T-4.1
puede pasar pero T-5.2 (`verify.sh`) verá MariaDB caído. FASE 2 garantiza que
MariaDB sobrevive la ejecución completa de FASE 4.

**FASE 3 puede ejecutarse en paralelo con FASE 1/2:** No hay dependencia técnica
entre las extensiones de PostgreSQL y el seed de MariaDB. Se coloca antes de
FASE 4 para que T-5.2 (`verify.sh`) reporte 0 WARN desde el primer intento.

**FASE 4 requiere FASE 0 verificada:** Si T-0.3 muestra que `sp_seed_historico`
ya existe (de un intento anterior), T-4.1 con `FORCE_RESEED=0` (default) hará
SKIP de las tablas que tengan datos. Si las tablas están vacías y el SP existe
en estado corrupto, la ejecución con `FORCE_RESEED=1` limpiaría y re-sembraría.

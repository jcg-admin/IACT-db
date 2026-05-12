# Plan de corrección — Bugs y permisos CNST-003

**Versión:** 1.0.0  
**Fecha:** 2026-05-12  
**Fuente:**
- `BUGS-ENCONTRADOS-202605120200.md` (BUG-001..BUG-011)
- `ANALISIS-PERMISOS-CNST003-RUN-ETL-202605120160.md`

**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Objetivo:** Deuda técnica cero — ningún bug sin corrección, ningún grant sobrante.

---

## Criterio de atomicidad

Cada tarea:
- Modifica exactamente un archivo o un bloque de un archivo
- Tiene verificación ejecutable que retorna OK o FALLO sin ambigüedad
- Se puede revertir con `git revert` o `git checkout HEAD -- <archivo>`

---

## Orden obligatorio entre fases

```
FASE 1 (utils/)           → independiente
FASE 2 (backup)           → independiente
FASE 3 (ssl.sh)           → independiente
FASE 4 (sp_etl_pipeline)  → independiente; despliegue en BD al final
FASE 5 (sp_rpt_reportes)  → independiente; despliegue en BD al final
FASE 6 (provision-mariadb: código)  → independiente
FASE 7 (REVOKE en BD)     → prerequisito: FASE 6 completada
FASE 8 (setup.sh CNST-003)→ prerequisito: FASE 7 completada
FASE 9 (Python cleanup)   → independiente
FASE 10 (cierre)          → última
```

---

## FASE 1 — `utils/core.sh` y `utils/provisioning.sh`

Corrige BUG-007, BUG-001 y BUG-008.  
Sin prerequisitos. Archivos de utilidad — impacto en todos los provisioners.

---

### T-1.1 — `utils/core.sh` L75: separar `local` de la asignación (BUG-007)

**Archivo:** `utils/core.sh`  
**Hallazgo:** `local backup="$(date ...)"` enmascara el exit code de `date`.

**Antes:**
```bash
local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
```

**Después:**
```bash
local backup
backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
```

**Verificación:**
```bash
bash -n utils/core.sh && echo "Sintaxis: OK"
shellcheck -S error utils/core.sh 2>&1 | grep SC2155 \
    && echo "ERROR: SC2155 aún presente" || echo "OK: SC2155 resuelto"
```

---

### T-1.2 — `utils/core.sh` L326: `break` → `return 1` (BUG-001)

**Archivo:** `utils/core.sh`  
**Hallazgo:** `break` sin loop envolvente no termina la función — la ejecución
continúa con la variable `daemon` vacía.

**Antes:**
```bash
else
    log_debug "service_action: mariadbd/mysqld no disponibles"
    break
fi
```

**Después:**
```bash
else
    log_debug "service_action: mariadbd/mysqld no disponibles"
    return 1
fi
```

**Verificación:**
```bash
bash -n utils/core.sh && echo "Sintaxis: OK"
shellcheck -S error utils/core.sh 2>&1 | grep SC2104 \
    && echo "ERROR: SC2104 aún presente" || echo "OK: SC2104 resuelto"
```

---

### T-1.3 — `utils/provisioning.sh` L28: separar `export` de la asignación (BUG-008)

**Archivo:** `utils/provisioning.sh`  
**Hallazgo:** `export PROJECT_ROOT="$(pwd)"` enmascara el exit code de `pwd`.

**Antes:**
```bash
export PROJECT_ROOT="$(pwd)"
```

**Después:**
```bash
PROJECT_ROOT="$(pwd)"
export PROJECT_ROOT
```

**Verificación:**
```bash
bash -n utils/provisioning.sh && echo "Sintaxis: OK"
shellcheck -S error utils/provisioning.sh 2>&1 | grep SC2155 \
    && echo "ERROR: SC2155 aún presente" || echo "OK: SC2155 resuelto"
```

---

### T-1.4 — Verificar baseline post-FASE 1

```bash
export PROJECT_ROOT=$(pwd)
bash verify.sh 2>/dev/null | grep -E "OK:|ERR"
# Criterio: 27 OK, 0 ERR
```

---

## FASE 2 — `provisioners/mariadb/backup_ivr_legacy.sh`

Corrige BUG-005 y BUG-006.  
Sin prerequisitos. El backup tiene `set -euo pipefail` — los command substitution
sin `|| true` pueden matar el script silenciosamente si la BD no responde.

---

### T-2.1 — L279: `SKIP_GRANT=$(root_exec ...)` → proteger con `|| SKIP_GRANT=""` (BUG-006)

**Archivo:** `provisioners/mariadb/backup_ivr_legacy.sh`  
**Hallazgo:** Si `root_exec` falla, `set -e` termina el script sin mensaje.

**Antes:**
```bash
SKIP_GRANT=$(root_exec -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    | awk '/skip_grant_tables/{print $2}')
```

**Después:**
```bash
SKIP_GRANT=$(root_exec -e "SHOW VARIABLES LIKE 'skip_grant_tables';" \
    2>/dev/null | awk '/skip_grant_tables/{print $2}') \
    || SKIP_GRANT=""
```

**Verificación:**
```bash
bash -n provisioners/mariadb/backup_ivr_legacy.sh && echo "Sintaxis: OK"
grep -n "SKIP_GRANT=" provisioners/mariadb/backup_ivr_legacy.sh \
    | grep "|| SKIP_GRANT" && echo "OK: protección presente"
```

---

### T-2.2 — L309: `TABLES=$(root_exec ...)` → proteger con `|| TABLES=""` (BUG-005)

**Archivo:** `provisioners/mariadb/backup_ivr_legacy.sh`  
**Hallazgo:** Si `root_exec` falla al listar tablas, el script termina sin diagnóstico.

**Antes:**
```bash
TABLES=$(root_exec "${DB}" -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null)
```

**Después:**
```bash
TABLES=$(root_exec "${DB}" -N -e "
SELECT table_name FROM information_schema.tables
WHERE table_schema='${DB}' AND table_type='BASE TABLE'
ORDER BY table_name;" 2>/dev/null) || {
    log "WARN: No se pudo obtener lista de tablas — BD no responde"
    TABLES=""
}
```

**Verificación:**
```bash
bash -n provisioners/mariadb/backup_ivr_legacy.sh && echo "Sintaxis: OK"
grep -A 3 "TABLES=\$(root_exec" provisioners/mariadb/backup_ivr_legacy.sh \
    | grep "|| {" && echo "OK: protección presente"
```

---

### T-2.3 — Verificar sintaxis post-FASE 2

```bash
bash -n provisioners/mariadb/backup_ivr_legacy.sh && echo "Sintaxis: OK"
shellcheck -S warning provisioners/mariadb/backup_ivr_legacy.sh 2>&1 \
    | grep -v SC1090 | grep -v "For more\|https://" | head -5
```

---

## FASE 3 — `provisioners/adminer/ssl.sh`

Corrige BUG-009.  
Sin prerequisitos. Rutas fijas en `/tmp` → `mktemp`.

---

### T-3.1 — L179/183/223: archivos temporales fijos → `mktemp` (BUG-009)

**Archivo:** `provisioners/adminer/ssl.sh`  
**Hallazgo:** Rutas `/tmp/adminer.csr`, `/tmp/adminer_san.cnf`, `/tmp/adminer_ext.cnf`
producen race condition si dos instancias corren simultáneamente.

**Antes:**
```bash
local csr_file="/tmp/adminer.csr"
...
local san_config="/tmp/adminer_san.cnf"
...
local ext_file="/tmp/adminer_ext.cnf"
```

**Después:**
```bash
local csr_file
csr_file=$(mktemp /tmp/adminer_XXXXXX.csr)
...
local san_config
san_config=$(mktemp /tmp/adminer_san_XXXXXX.cnf)
...
local ext_file
ext_file=$(mktemp /tmp/adminer_ext_XXXXXX.cnf)
```

**Verificación:**
```bash
bash -n provisioners/adminer/ssl.sh && echo "Sintaxis: OK"
grep "mktemp" provisioners/adminer/ssl.sh | wc -l
# Esperado: 3 (csr_file, san_config, ext_file)
grep '"/tmp/adminer' provisioners/adminer/ssl.sh \
    && echo "ERROR: rutas fijas aún presentes" || echo "OK: sin rutas fijas"
```

---

## FASE 4 — `provisioners/mariadb/sp_etl_pipeline.sql`

Corrige BUG-002.  
El fix modifica el SQL — requiere redespliegue en la BD.

---

### T-4.1 — EXIT HANDLER de `sp_etl_base_clientes`: agregar UPDATE `v_maestro_id` (BUG-002)

**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Hallazgo:** Si `sp_etl_base_clientes` falla, `job_execution_log` queda con el
maestro en `status='RUNNING'`. La siguiente ejecución detecta ese RUNNING y
hace SKIP indefinidamente.

**Antes:**
```sql
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(), error_message=v_err_msg
        WHERE id = v_step_id;
    END;
    CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
END;
```

**Después:**
```sql
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(), error_message=v_err_msg
        WHERE id = v_step_id;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(),
            error_message=CONCAT('Falló etl_base_clientes: ', v_err_msg)
        WHERE id = v_maestro_id;
    END;
    CALL sp_etl_base_clientes(v_quarter, v_inicio, v_fin, v_table, v_step_id);
END;
```

**Verificación:**
```bash
# Verificar que el fix está en el archivo
grep -A 12 "CALL sp_etl_base_clientes" provisioners/mariadb/sp_etl_pipeline.sql \
    | grep "v_maestro_id" && echo "OK: v_maestro_id en handler"
```

---

### T-4.2 — Redesplegar `sp_etl_pipeline.sql` en la BD

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/sp_etl_pipeline.sql 2>&1 | grep -i "error" | head -5
# Sin errores → OK
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -N -e "SELECT ROUTINE_NAME FROM information_schema.ROUTINES
           WHERE ROUTINE_SCHEMA='ivr_legacy' AND ROUTINE_TYPE='PROCEDURE'
           ORDER BY ROUTINE_NAME;"
# Debe mostrar los 5 SPs ETL
```

---

## FASE 5 — `provisioners/mariadb/sp_rpt_reportes.sql`

Corrige BUG-004.  
Las divisiones sin `NULLIF` producen `NULL` silencioso en los porcentajes
cuando el quarter no tiene datos. Se corrigen las 4 ocurrencias en 2 SPs.

---

### T-5.1 — `sp_rpt_clientes` L55: división por cero → `NULLIF` (BUG-004)

**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`

**Antes:**
```sql
c.clientes_unicos
/ (SELECT SUM(c2.clientes_unicos)
   FROM base_ivr_clientes c2
   WHERE c2.trimestre = p_quarter)
* 100
```

**Después:**
```sql
c.clientes_unicos
/ NULLIF(
    (SELECT SUM(c2.clientes_unicos)
     FROM base_ivr_clientes c2
     WHERE c2.trimestre = p_quarter),
  0) * 100
```

**Verificación:**
```bash
grep -A 4 "c.clientes_unicos$" provisioners/mariadb/sp_rpt_reportes.sql \
    | grep "NULLIF" && echo "OK: NULLIF presente en sp_rpt_clientes"
```

---

### T-5.2 — `sp_rpt_llamadas_abandonadas` L138/151/153: `v_total_quarter` → `NULLIF` (BUG-004)

**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Afecta:** 3 ocurrencias de `/ v_total_quarter` dentro de `sp_rpt_llamadas_abandonadas`
(campo `pct_del_total` y 2 ocurrencias en el `CASE` de clasificación SLA).

**Antes (3 lugares):**
```sql
ROUND(SUM(b.total_llamadas) / v_total_quarter * 100, 2)
```

**Después (3 lugares):**
```sql
ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2)
```

**Verificación:**
```bash
grep "/ v_total_quarter" provisioners/mariadb/sp_rpt_reportes.sql \
    && echo "ERROR: divisiones sin NULLIF aún presentes" \
    || echo "OK: todas las divisiones protegidas"
```

---

### T-5.3 — `sp_rpt_centros_transferencia` L89: subconsulta SUM → `NULLIF` (BUG-004)

**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`  
**Afecta:** La subconsulta en el campo `porcentaje` de `sp_rpt_centros_transferencia`.

**Antes:**
```sql
b.total_llamadas
/ (SELECT SUM(b2.total_llamadas)
   FROM base_ivr_detalle b2
   WHERE b2.trimestre = p_quarter
     AND b2.fecha     = b.fecha
     AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
  ) * 100, 7
```

**Después:**
```sql
b.total_llamadas
/ NULLIF(
    (SELECT SUM(b2.total_llamadas)
     FROM base_ivr_detalle b2
     WHERE b2.trimestre = p_quarter
       AND b2.fecha     = b.fecha
       AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
  0) * 100, 7
```

**Verificación:**
```bash
# Ningún SUM sin NULLIF en divisiones de los SPs de reporte
grep -n "/ (SELECT SUM" provisioners/mariadb/sp_rpt_reportes.sql \
    | grep -v "NULLIF" \
    && echo "ERROR: subconsultas SUM sin NULLIF" \
    || echo "OK: todas las subconsultas SUM protegidas"
```

---

### T-5.4 — Redesplegar `sp_rpt_reportes.sql` en la BD

```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    < provisioners/mariadb/sp_rpt_reportes.sql 2>&1 | grep -i "error" | head -5
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -u django_user -pdjango_pass \
    -N -e "CALL sp_rpt_clientes('Q99_99');"
# Debe retornar sin filas (quarter vacío) — NO ERROR
# NULL en pct_del_total es aceptable cuando hay filas; con quarter inexistente no hay filas
```

---

## FASE 6 — `scripts/provision-mariadb.sh`: corregir grants en código

Corrige los grants sobrantes identificados en `ANALISIS-PERMISOS-CNST003-RUN-ETL`.  
Sin prerequisitos de otras fases. Afecta instalaciones futuras.

---

### T-6.1 — `_apply_dml_grants`: corregir lista de tablas y permisos (CNST-003)

**Archivo:** `scripts/provision-mariadb.sh`  
**Hallazgo:** La función otorga SIDU completo en 5 tablas. Solo `etl_runs` necesita
escritura (INSERT, UPDATE). Las otras 4 tablas solo necesitan SELECT, que ya viene
del grant global de CNST-003. Se elimina también DELETE en etl_runs.

**Antes:**
```bash
for tbl in base_ivr_detalle base_ivr_clientes \
           job_execution_log etl_runs job_config; do
    ...
    stmt="GRANT SELECT, INSERT, UPDATE, DELETE
        ON \`${DB}\`.\`${tbl}\` TO '${DB_USER}'@'${host}';"
```

**Después:**
```bash
# ÚNICA tabla donde django_user escribe directamente.
# run_etl.py y scheduler.py (APScheduler) necesitan INSERT/UPDATE en etl_runs
# para registrar inicio, heartbeat y cierre del job ETL.
# DELETE excluido deliberadamente — no hay caso de uso en el código actual.
# Las otras tablas (base_ivr_*, job_execution_log, job_config) las escribe
# root via DEFINER de los SPs — SELECT ya cubierto por GRANT SELECT ON ivr_legacy.*
for tbl in etl_runs; do
    ...
    stmt="GRANT SELECT, INSERT, UPDATE
        ON \`${DB}\`.\`${tbl}\` TO '${DB_USER}'@'${host}';"
```

**Verificación:**
```bash
bash -n scripts/provision-mariadb.sh && echo "Sintaxis: OK"
grep "for tbl in" scripts/provision-mariadb.sh \
    | grep "_apply_dml_grants" -A 1 | head -3
# O mejor:
sed -n '/^_apply_dml_grants/,/^}/p' scripts/provision-mariadb.sh \
    | grep "for tbl in"
# Debe mostrar: for tbl in etl_runs; do
```

---

### T-6.2 — `_apply_execute_grants`: filtrar SPs internos (CNST-003)

**Archivo:** `scripts/provision-mariadb.sh`  
**Hallazgo:** La función otorga EXECUTE en todos los SPs del schema dinámicamente.
`sp_etl_base_detalle`, `sp_etl_base_clientes` y `sp_etl_validar` son llamados
internamente por `sp_etl_maestro` como DEFINER=root — django_user no los necesita.

**Estrategia:** Cambiar el query de procedures de "todos" a lista explícita.

**Antes:**
```sql
SELECT ROUTINE_NAME FROM information_schema.ROUTINES
WHERE ROUTINE_SCHEMA='${DB}'
AND ROUTINE_TYPE='PROCEDURE';
```

**Después:**
```sql
SELECT ROUTINE_NAME FROM information_schema.ROUTINES
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
);
```

(Las 7 funciones se conservan — son defensivas y sin riesgo.)

**Verificación:**
```bash
bash -n scripts/provision-mariadb.sh && echo "Sintaxis: OK"
grep -A 10 "SELECT ROUTINE_NAME.*PROCEDURE" scripts/provision-mariadb.sh \
    | grep "IN (" && echo "OK: filtro por lista explícita presente"
```

---

### T-6.3 — Verificar sintaxis post-FASE 6

```bash
bash -n scripts/provision-mariadb.sh && echo "Sintaxis: OK"
```

---

## FASE 7 — REVOKE grants sobrantes en BD actual

**Prerequisito:** FASE 6 completada (el código ya no los volvería a otorgar).  
Revoca en el entorno real los grants que FASE 6 eliminó del código.

---

### T-7.1 — REVOKE DELETE en `etl_runs` para ambos hosts

```sql
REVOKE DELETE ON `ivr_legacy`.`etl_runs` FROM 'django_user'@'localhost';
REVOKE DELETE ON `ivr_legacy`.`etl_runs` FROM 'django_user'@'%';
FLUSH PRIVILEGES;
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock \
    -N -e "SELECT COUNT(*) FROM information_schema.TABLE_PRIVILEGES
           WHERE GRANTEE LIKE \"'django_user'%\"
           AND TABLE_NAME='etl_runs'
           AND PRIVILEGE_TYPE='DELETE';"
# Esperado: 0
```

---

### T-7.2 — REVOKE SIDU en `base_ivr_detalle`, `base_ivr_clientes`, `job_execution_log`, `job_config`

```sql
REVOKE SELECT, INSERT, UPDATE, DELETE
    ON `ivr_legacy`.`base_ivr_detalle`
    FROM 'django_user'@'localhost';
REVOKE SELECT, INSERT, UPDATE, DELETE
    ON `ivr_legacy`.`base_ivr_detalle`
    FROM 'django_user'@'%';
-- ídem para base_ivr_clientes, job_execution_log, job_config
FLUSH PRIVILEGES;
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock \
    -N -e "SELECT TABLE_NAME, PRIVILEGE_TYPE
           FROM information_schema.TABLE_PRIVILEGES
           WHERE GRANTEE LIKE \"'django_user'%\"
           AND TABLE_NAME IN ('base_ivr_detalle','base_ivr_clientes',
                              'job_execution_log','job_config')
           AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE');"
# Esperado: 0 filas

# Verificar que SELECT sigue funcionando via grant global:
mysql --socket=/run/mysqld/mysqld.sock ivr_legacy \
    -u django_user -pdjango_pass \
    -N -e "SELECT COUNT(*) FROM base_ivr_detalle;"
# Debe retornar el número de filas sin error
```

---

### T-7.3 — REVOKE EXECUTE en `sp_etl_base_detalle`, `sp_etl_base_clientes`, `sp_etl_validar`

```sql
REVOKE EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_base_detalle`
    FROM 'django_user'@'localhost';
REVOKE EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_base_detalle`
    FROM 'django_user'@'%';
REVOKE EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_base_clientes`
    FROM 'django_user'@'localhost';
REVOKE EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_base_clientes`
    FROM 'django_user'@'%';
REVOKE EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_validar`
    FROM 'django_user'@'localhost';
REVOKE EXECUTE ON PROCEDURE `ivr_legacy`.`sp_etl_validar`
    FROM 'django_user'@'%';
FLUSH PRIVILEGES;
```

**Verificación:**
```bash
mysql --socket=/run/mysqld/mysqld.sock \
    -N -e "SELECT Routine_name FROM mysql.procs_priv
           WHERE User='django_user' AND Db='ivr_legacy'
           AND Routine_name IN ('sp_etl_base_detalle',
                                'sp_etl_base_clientes',
                                'sp_etl_validar');"
# Esperado: 0 filas
```

---

### T-7.4 — Verificar que `run_etl` sigue funcionando tras REVOKE

```bash
# Prueba funcional: las 4 operaciones de run_etl.py
python3 - << 'EOF'
import pymysql
pymysql.install_as_MySQLdb()
import logging; logging.disable(logging.CRITICAL)
from django.conf import settings
settings.configure(DATABASES={
    'default': {'ENGINE':'django.db.backends.mysql','NAME':'ivr_legacy',
                'USER':'django_user','PASSWORD':'django_pass',
                'HOST':'127.0.0.1','PORT':'3306',
                'OPTIONS':{'charset':'utf8mb4'}},
    'ivr': {'ENGINE':'django.db.backends.mysql','NAME':'ivr_legacy',
            'USER':'django_user','PASSWORD':'django_pass',
            'HOST':'127.0.0.1','PORT':'3306',
            'OPTIONS':{'charset':'utf8mb4'}},
})
import django; django.setup()
from django.db import connections
with connections['ivr'].cursor() as c:
    c.execute("INSERT INTO etl_runs (trimestre,inicio_at,timeout_at,status,trigger_source) VALUES ('T_REVOKE',NOW(),DATE_ADD(NOW(),INTERVAL 1 MINUTE),'en_ejecucion','test')")
    run_id = c.lastrowid
    print(f"1. INSERT etl_runs: OK (id={run_id})")
    c.execute("UPDATE etl_runs SET heartbeat_at=NOW() WHERE id=%s", [run_id])
    print("2. UPDATE heartbeat: OK")
    c.callproc('sp_etl_maestro', [])
    print("3. CALL sp_etl_maestro: OK")
    c.execute("UPDATE etl_runs SET status='success',fin_at=NOW() WHERE id=%s", [run_id])
    print("4. UPDATE final: OK")
    c.execute("DELETE FROM etl_runs WHERE id=%s", [run_id])
    print("Limpieza: OK")
print("RESULTADO: run_etl funciona correctamente tras REVOKE")
EOF
```

---

### T-7.5 — verify.sh post-FASE 7

```bash
export PROJECT_ROOT=$(pwd)
bash verify.sh 2>/dev/null | grep -E "OK:|ERR"
# Criterio: 27 OK, 0 ERR
```

---

## FASE 8 — `provisioners/mariadb/setup.sh`: corregir verificación CNST-003

**Prerequisito:** FASE 7 completada (los grants ya están en el estado correcto).  
Corrige BUG-003 — la verificación dejará de reportar falsos negativos.

---

### T-8.1 — Reemplazar `USER_PRIVILEGES` por `TABLE_PRIVILEGES` en la verificación CNST-003

**Archivo:** `provisioners/mariadb/setup.sh`  
**Hallazgo:** La verificación usa `USER_PRIVILEGES` (grants globales) en lugar de
`TABLE_PRIVILEGES` (grants de tabla). Siempre reporta 0 escrituras aunque existan.

**Antes:**
```bash
write_privs=$(mysql ... -e "SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
        WHERE GRANTEE LIKE \"'${db_user}'%\"
        AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE','DROP','CREATE','ALTER');"
        2>/dev/null || echo "0")

if [[ "$write_privs" -eq 0 ]]; then
    log_success "CNST-003 verificado: ${db_user} es READ-ONLY en ${db_name}"
else
    log_warn "CNST-003: ${db_user} tiene ${write_privs} privilegio(s) de escritura"
    log_warn "  Revisa los GRANT aplicados sobre ${db_name}"
fi
```

**Después:**
```bash
local write_tbls
write_tbls=$(mysql -h "$host" -P "$port" \
    -u "$db_user" -p"${db_pass}" \
    --batch --silent --skip-column-names \
    -e "SELECT GROUP_CONCAT(DISTINCT TABLE_NAME ORDER BY TABLE_NAME SEPARATOR ', ')
        FROM information_schema.TABLE_PRIVILEGES
        WHERE GRANTEE LIKE \"'${db_user}'%\"
        AND TABLE_SCHEMA = '${db_name}'
        AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE');" \
    2>/dev/null || echo "")

if [[ -z "$write_tbls" || "$write_tbls" == "NULL" ]]; then
    log_success "CNST-003 verificado: ${db_user} es READ-ONLY en ${db_name}"
else
    log_info "CNST-003: escritura operacional en tablas: ${write_tbls}"
    log_info "  (extensión controlada por provision-mariadb.sh — ver análisis CNST-003)"
fi
```

**Verificación:**
```bash
bash -n provisioners/mariadb/setup.sh && echo "Sintaxis: OK"
grep "TABLE_PRIVILEGES" provisioners/mariadb/setup.sh \
    && echo "OK: usa TABLE_PRIVILEGES"
grep "USER_PRIVILEGES" provisioners/mariadb/setup.sh \
    && echo "ERROR: aún usa USER_PRIVILEGES" || echo "OK: USER_PRIVILEGES eliminado"
```

---

## FASE 9 — Python cleanup

Corrige BUG-010 y BUG-011.  
Sin prerequisitos. Son correcciones de style/CI sin impacto funcional.

---

### T-9.1 — `poblar_historico.py`: eliminar prefijo `f` innecesario en 4 líneas (BUG-010)

**Archivo:** `provisioners/mariadb/poblar_historico.py`  
**Hallazgo:** Prefijo `f` en strings sin `{}` — pyflakes advertencia, confunde al lector.

**Cambios:**
- L408: `print(f"  Sin menús quitados")` → `print("  Sin menús quitados")`
- L415: `print(f"  Sin cambios de VDN")` → `print("  Sin cambios de VDN")`
- L504: `print(f"  poblar_historico.py")` → `print("  poblar_historico.py")`
- L557: `print(f"    TRUNCATE ejecutado")` → `print("    TRUNCATE ejecutado")`

**Verificación:**
```bash
python3 -m py_compile provisioners/mariadb/poblar_historico.py && echo "Sintaxis: OK"
python3 -m pyflakes provisioners/mariadb/poblar_historico.py 2>&1 \
    | grep "f-string is missing" \
    && echo "ERROR: f-strings sin {} aún presentes" \
    || echo "OK: sin f-strings vacíos"
```

---

### T-9.2 — Perfiles proxy: agregar `# noqa: F401` (BUG-011)

**Archivos:** `perfiles/q01_2026.py`, `perfiles/q02_2026.py`, `perfiles/q04_2025.py`  
**Hallazgo:** pyflakes reporta `imported but unused` — falso positivo.
Los imports son necesarios para que `__init__.py` los re-exporte.

**Cambios:**
```python
# q01_2026.py:
from perfiles.q01_2025 import MENUS, VDN_POR_MENU  # noqa: F401 — re-exportado por __init__

# q02_2026.py:
from perfiles.q02_2025 import MENUS, VDN_POR_MENU  # noqa: F401 — re-exportado por __init__

# q04_2025.py:
from perfiles.q03_2025 import MENUS, VDN_POR_MENU  # noqa: F401 — re-exportado por __init__
```

**Verificación:**
```bash
python3 -m pyflakes provisioners/mariadb/perfiles/ 2>&1 \
    | grep -v "noqa" | grep "imported but unused" \
    && echo "ERROR: aún hay importaciones sin uso" \
    || echo "OK: pyflakes limpio en perfiles/"
```

---

### T-9.3 — Verificar sintaxis Python post-FASE 9

```bash
for f in provisioners/mariadb/poblar_historico.py \
          provisioners/mariadb/perfiles/*.py; do
    python3 -m py_compile "$f" && echo "OK: $f"
done
```

---

## FASE 10 — Cierre: verify.sh y commit

---

### T-10.1 — verify.sh final

```bash
export PROJECT_ROOT=$(pwd)
bash verify.sh 2>/dev/null | grep -E "OK:|ERR"
# Criterio: 27 OK, 0 ERR, EXIT 0
```

---

### T-10.2 — Commit de cierre

```
fix(bugs): corregir BUG-001..011 y grants sobrantes CNST-003

FASE 1 — utils/: BUG-007, BUG-001, BUG-008
FASE 2 — backup_ivr_legacy.sh: BUG-005, BUG-006
FASE 3 — ssl.sh: BUG-009
FASE 4 — sp_etl_pipeline.sql: BUG-002
FASE 5 — sp_rpt_reportes.sql: BUG-004
FASE 6 — provision-mariadb.sh: corregir _apply_dml_grants, _apply_execute_grants
FASE 7 — REVOKE grants sobrantes en BD + verificación funcional run_etl
FASE 8 — setup.sh: BUG-003 verificación CNST-003 con TABLE_PRIVILEGES
FASE 9 — Python: BUG-010 f-strings, BUG-011 noqa

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

---

## Resumen ejecutivo

| FASE | Tareas | Bugs que cierra | Archivos | Prerequisito |
|---|---|---|---|---|
| FASE 1 | T-1.1..T-1.4 | BUG-007, BUG-001, BUG-008 | utils/core.sh, utils/provisioning.sh | Ninguno |
| FASE 2 | T-2.1..T-2.3 | BUG-005, BUG-006 | backup_ivr_legacy.sh | Ninguno |
| FASE 3 | T-3.1 | BUG-009 | adminer/ssl.sh | Ninguno |
| FASE 4 | T-4.1..T-4.2 | BUG-002 | sp_etl_pipeline.sql + despliegue BD | Ninguno |
| FASE 5 | T-5.1..T-5.4 | BUG-004 | sp_rpt_reportes.sql + despliegue BD | Ninguno |
| FASE 6 | T-6.1..T-6.3 | CNST-003 grants código | provision-mariadb.sh | Ninguno |
| FASE 7 | T-7.1..T-7.5 | CNST-003 grants BD + verificación | BD directa | FASE 6 |
| FASE 8 | T-8.1 | BUG-003 | provisioners/mariadb/setup.sh | FASE 7 |
| FASE 9 | T-9.1..T-9.3 | BUG-010, BUG-011 | poblar_historico.py, perfiles/ | Ninguno |
| FASE 10 | T-10.1..T-10.2 | — | — | Todas las fases anteriores |

**Total tareas:** 20  
**Archivos modificados:** 10  
**Archivos con cambio en BD:** 2 (redespliegue de SPs)  
**Operaciones directas en BD:** REVOKE en 8 objetos  
**Baseline antes:** 27 OK  
**Baseline esperado después:** 27 OK (sin regresión)

# Plan de implementación — Correcciones pendientes IACT-db / IACT-api

**Fecha:** 2026-05-10  
**Repositorios:** IACT-db, IACT-api  
**Referencia:** Hallazgos H-PG-*, H-MDB-* documentados en sesión 2026-05-10

---

## Criterios de atomicidad

Cada tarea modifica exactamente un archivo o produce exactamente un resultado
verificable. Una tarea no puede completarse parcialmente.

---

## FASE 0 — Utilidades: logging y consistencia estructural

**Objetivo:** Eliminar inconsistencias en `utils/` que afectan a todos los provisioners.

### T-0.1 — `database.sh`: `_mariadb_start_systemd` sin logging de decisión

**Archivo:** `utils/database.sh`  
**Problema:** `_mariadb_start_systemd()` intenta `systemctl` y `service` con `2>/dev/null`
silencioso. Si ambos fallan no hay registro de qué se intentó. Tampoco usa `_has_systemd()`.  
**Acción:** Reescribir `_mariadb_start_systemd()` para:
- Usar `_has_systemd()` antes de intentar `systemctl`
- Emitir `log_debug` por cada mecanismo intentado
- Emitir `log_warn` cuando un mecanismo falla

**Verificación:** `bash -c 'source utils/logging.sh; source utils/core.sh; source utils/network.sh; source utils/database.sh; LOG_LEVEL=0 _mariadb_start_systemd'` emite logs visibles.

---

### T-0.2 — `database.sh`: `db_start_mariadb` log cuando cae de systemd a directo

**Archivo:** `utils/database.sh`  
**Problema:** `db_start_mariadb()` llama `_mariadb_start_systemd` + `mariadb_wait_ready`. Si
`mariadb_wait_ready` falla tras systemd (daemon arrancó pero murió), cae a
`_mariadb_start_direct` sin dejar log del motivo del fallthrough.  
**Acción:** Agregar `log_warn` explícito cuando `mariadb_wait_ready` falla después
de `_mariadb_start_systemd`, antes de intentar `_mariadb_start_direct`.

**Verificación:** Lectura de código confirma log_warn antes del fallthrough.

---

### T-0.3 — `database.sh`: actualizar header de versión

**Archivo:** `utils/database.sh`  
**Problema:** Header no refleja los cambios de `_mariadb_start_direct` (H-MDB-007).  
**Acción:** Actualizar comment de versión con changelog de los cambios aplicados.

**Verificación:** `head -10 utils/database.sh` muestra versión actualizada.

---

### T-0.4 — `setup.sh` (raíz): definir `SKIP_SEED` explícitamente

**Archivo:** `setup.sh` (raíz IACT-db)  
**Problema:** `run_mariadb_setup()` usa `${SKIP_SEED:+--skip-seed}` pero `SKIP_SEED`
no se define en `setup.sh`. Si el operador no lo exporta antes de ejecutar,
la expansión funciona pero sin documentación clara del comportamiento.  
**Acción:** Agregar `SKIP_SEED="${SKIP_SEED:-0}"` después de la carga del `.env`.

**Verificación:** `grep SKIP_SEED setup.sh` muestra definición explícita.

---

### T-0.5 — `setup.sh` (raíz): actualizar header con nuevas opciones

**Archivo:** `setup.sh` (raíz IACT-db)  
**Problema:** El docstring dice "Ejecuta solo los setup.sh de cada BD" — ya no es
cierto con `--full`. El bloque de uso no menciona `--full` ni `--skip-seed`.  
**Acción:** Actualizar el comentario de cabecera para documentar:
- `sudo bash setup.sh [all|mariadb|postgres] [--full] [SKIP_SEED=1]`
- Diferencia entre setup básico y `--full`

**Verificación:** `head -20 setup.sh` muestra las nuevas opciones documentadas.

---

### T-0.6 — `provision-mariadb.sh`: agregar header con versión y changelog

**Archivo:** `scripts/provision-mariadb.sh`  
**Problema:** El script no tiene versión ni changelog. Los cambios de esta sesión
(H-MDB-010..012, H-MDB-015) no quedan trazados.  
**Acción:** Agregar bloque de versión `1.1.0` con changelog en el encabezado.

**Verificación:** `head -15 scripts/provision-mariadb.sh` muestra versión y cambios.

---

### T-0.7 — `mariadb/setup.sh`: reemplazar `echo` por `log_info` en bloque final

**Archivo:** `provisioners/mariadb/setup.sh`  
**Problema:** Las cuatro últimas líneas de `main()` usan `echo` directo en lugar de
`log_info`, rompiendo la uniformidad del sistema de logging y el registro en archivo.  
**Acción:** Reemplazar las cuatro líneas con `log_info`.

**Verificación:** `grep -n "^    echo" provisioners/mariadb/setup.sh` no devuelve resultados.

---

## FASE 1 — Provisionamiento MariaDB: correcciones estructurales

**Objetivo:** Cerrar gaps en `provision-mariadb.sh` para que el flujo sea robusto.

### T-1.1 — `provision-mariadb.sh`: agregar helper `sql_exec_query` para consultas inline

**Archivo:** `scripts/provision-mariadb.sh`  
**Problema:** `sql_exec_file` maneja archivos SQL, pero PASO 5 necesita ejecutar
queries inline (`-N -e "SELECT COUNT(*)"`) via socket o TCP según disponibilidad.
Actualmente usa `mysql --socket="$SOCK"` hardcodeado, que falla si SOCK está vacío
(cuando MariaDB arrancó solo via TCP).  
**Acción:** Agregar función `sql_exec_query()` paralela a `sql_exec_file()`:

```bash
sql_exec_query() {
    local query="$1"
    if [[ -n "$SOCK" ]]; then
        mysql --socket="$SOCK" "$DB" -N -e "$query" 2>/dev/null
    else
        mysql -h "${MARIADB_HOST:-127.0.0.1}" -P "${MARIADB_PORT:-3306}" \
              -u root "$DB" -N -e "$query" 2>/dev/null
    fi
}
```

**Verificación:** Función presente en el script antes del PASO 4.

---

### T-1.2 — `provision-mariadb.sh`: PASO 5 usa `sql_exec_query` en lugar de socket directo

**Archivo:** `scripts/provision-mariadb.sh`  
**Problema:** `SP_COUNT`, `TABLE_COUNT` y la lista de routines usan
`mysql --socket="$SOCK"` directamente. Si SOCK está vacío, los tres fallan
silenciosamente produciendo conteos vacíos.  
**Dependencia:** T-1.1  
**Acción:** Reemplazar las tres invocaciones de `mysql --socket="$SOCK"` en PASO 5
por llamadas a `sql_exec_query`.

**Verificación:** `grep "mysql --socket" scripts/provision-mariadb.sh` solo muestra
resultados dentro de `sql_exec_file` y `sql_exec_query`, no en PASO 5.

---

### T-1.3 — `provision-mariadb.sh`: PASO 0 `FLUSH PRIVILEGES` condicional

**Archivo:** `scripts/provision-mariadb.sh`  
**Problema:** `mysql ... -e "FLUSH PRIVILEGES;"` en PASO 0 es un vestigio del entorno
con `--skip-grant-tables`. En instalación normal es inocuo pero engañoso: emite un
mensaje de éxito que no refleja ninguna acción real necesaria.  
**Acción:** Hacer el `FLUSH PRIVILEGES` condicional: ejecutarlo solo si el proceso
`mariadbd` fue iniciado con `--skip-grant-tables` (detectable via `ps aux | grep skip-grant`).
Si no aplica, emitir `log_debug` explicando por qué se omite.

**Verificación:** En instalación normal, el log no menciona FLUSH PRIVILEGES.

---

### T-1.4 — `provision-mariadb.sh`: verificar que `schema_base_ivr.sql` requiere ser ejecutado como root

**Archivo:** `scripts/provision-mariadb.sh`  
**Problema:** `schema_base_ivr.sql` comenta "EJECUTAR EN: ivr_legacy (mismo servidor)"
pero no especifica con qué usuario. Actualmente `sql_exec_file` usa root via socket.
Verificar que las tablas `base_ivr_*` se crean con propietario correcto para que
`django_user` pueda leer/escribir.  
**Acción:** Después de aplicar `schema_base_ivr.sql`, ejecutar:
```sql
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`base_ivr_detalle` TO 'django_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`base_ivr_clientes` TO 'django_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`job_execution_log` TO 'django_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`etl_runs` TO 'django_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE ON `ivr_legacy`.`job_config` TO 'django_user'@'%';
```
Y los equivalentes para `localhost`.

**Verificación:** Después de `provision-mariadb.sh`, `django_user` puede hacer SELECT e INSERT
en `base_ivr_detalle`.

---

### T-1.5 — `provision-mariadb.sh`: verificar PASO 5 contra lista de objetos esperados

**Archivo:** `scripts/provision-mariadb.sh`  
**Problema:** PASO 5 reporta solo conteos (`SP_COUNT`, `TABLE_COUNT`). No detecta si
faltó algún objeto específico — por ejemplo si `schema_base_ivr.sql` falló pero
`sp_etl_pipeline.sql` continuó.  
**Acción:** Agregar verificación nominal en PASO 5: listar los objetos esperados y
confirmar cuáles existen vs cuáles faltan, emitiendo `log_error` por cada faltante:

```
Tablas esperadas: base_ivr_detalle, base_ivr_clientes, job_execution_log,
                  etl_runs, job_config, tbl_historico_t1_2025..t2_2026,
                  tbl_temp_prueba_ivr
Funciones esperadas: fn_did_segmento, fn_normalizar_menu, fn_normalizar_centro,
                     fn_duracion_seg, ivr_es_dia_semana (y 2 más)
```

**Verificación:** Ejecutando con schema incompleto, el script reporta objetos faltantes.

---

## FASE 2 — Adminer: alineación de variables

**Objetivo:** El provisioner de Adminer usa nombres de variable eliminados.

### T-2.1 — `adminer/bootstrap.sh`: reemplazar `MARIADB_IP` y `POSTGRES_IP`

**Archivo:** `provisioners/adminer/bootstrap.sh`  
**Problema:** Usa `MARIADB_IP` y `POSTGRES_IP` (variables Vagrant eliminadas). El `.env.example`
define `MARIADB_HOST` y `POSTGRES_HOST`.  
**Acción:**
- `require_vars`: reemplazar `MARIADB_IP POSTGRES_IP` por `MARIADB_HOST POSTGRES_HOST`
- `show_results`: reemplazar `${MARIADB_IP}` por `${MARIADB_HOST}` y `${POSTGRES_IP}` por `${POSTGRES_HOST}`
- Actualizar version header a 1.0.3

**Verificación:** `grep -E "MARIADB_IP|POSTGRES_IP" provisioners/adminer/bootstrap.sh` no devuelve resultados.

---

## FASE 3 — verify.sh: cobertura de schema MariaDB

**Objetivo:** `bash verify.sh` debe confirmar que el schema completo está presente.

### T-3.1 — `verify.sh`: agregar sección 3b para verificar schema MariaDB

**Archivo:** `verify.sh`  
**Problema:** La verificación de MariaDB solo comprueba conectividad (sección 3) y
tabla de prueba (sección 7). No verifica la existencia de las tablas analíticas,
funciones de utilidad ni SPs — objetos que son prerequisito del pipeline ETL.  
**Acción:** Agregar función `check_mariadb_schema()` llamada después de
`check_mariadb_running()`. La función verifica:

1. Tablas históricas: `tbl_historico_t1_2025` .. `tbl_historico_t2_2026` (6)
2. Tablas analíticas: `base_ivr_detalle`, `base_ivr_clientes`, `job_execution_log`,
   `etl_runs`, `job_config` (5)
3. Funciones de utilidad: `fn_did_segmento`, `fn_normalizar_menu` (y 5 más)
4. SPs ETL: al menos 1 routine de `sp_etl_pipeline.sql`
5. SPs Reporte: al menos 1 routine de `sp_rpt_reportes.sql`

Cada objeto faltante emite `warn` si MariaDB no está instalado, `fail` si está
instalado pero el objeto no existe.

**Verificación:** `bash verify.sh` tras `provision-mariadb.sh --full` reporta todos los objetos presentes.

---

### T-3.2 — `verify.sh`: actualizar contadores totales (7 → 8 secciones)

**Archivo:** `verify.sh`  
**Dependencia:** T-3.1  
**Problema:** Los headers de sección usan `1/7`, `2/7`, etc. Con la nueva sección
3b el total cambia a 8.  
**Acción:** Actualizar todos los `log_header "N/7 ..."` por `"N/8 ..."` y agregar
`"3b/8 MariaDB — schema"` para la nueva sección.

**Verificación:** Todos los `log_header` en `verify.sh` usan `/8`.

---

## FASE 4 — IACT-api: settings de testing

**Objetivo:** Los settings de tests apuntan a IPs Vagrant que no aplican en desarrollo local.

### T-4.1 — `testing.py`: reemplazar IPs Vagrant por localhost

**Archivo:** `callcentersite/config/settings/testing.py`  
**Problema:** `HOST: '192.168.56.11'` (PostgreSQL) y `HOST: '192.168.56.10'`
(MariaDB) son IPs de VMs Vagrant. En desarrollo local con BD en localhost,
los tests fallan con `connection refused`.  
**Acción:** Reemplazar por:
- PostgreSQL: `HOST: config('DB_HOST', default='127.0.0.1')`
- MariaDB: `HOST: config('IVR_DB_HOST', default='127.0.0.1')`
- Mantener credenciales desde `config()` en lugar de hardcodeadas

**Verificación:** `pytest --co -q` no falla por `connection refused` a 192.168.56.*

---

### T-4.2 — `testing.py`: alinear alias de BD con `base.py`

**Archivo:** `callcentersite/config/settings/testing.py`  
**Problema:** `testing.py` define la BD MariaDB con alias `'legacy'` pero `base.py`
la define con alias `'ivr'`. El `DatabaseRouter` usa `'ivr'`. Esta inconsistencia
hace que los tests que usan el router fallen al no encontrar el alias `'ivr'`.  
**Acción:** Cambiar `'legacy'` por `'ivr'` en el diccionario `DATABASES` de `testing.py`.

**Verificación:** `grep "'legacy'\|'ivr'" testing.py` muestra solo `'ivr'`.

---

### T-4.3 — `testing_local.py`: verificar que `DATABASES['ivr']['TEST']` usa nombre correcto

**Archivo:** `callcentersite/config/settings/testing_local.py`  
**Problema:** `testing_local.py` define `DATABASES['ivr']['TEST']['NAME'] = 'test_ivr_legacy'`.
El provisioner da `GRANT CREATE, DROP ... ON test_ivr_legacy.*` a `django_user`.
Verificar que el nombre coincide exactamente.  
**Acción:** Confirmar que `test_ivr_legacy` == nombre en `setup.sh` (`test_${db_name}`
donde `db_name=ivr_legacy`). Si coincide, agregar comentario cross-reference. Si no, corregir.

**Verificación:** Nombre en `testing_local.py` == `test_` + valor de `DB_MARIADB_NAME` en `.env`.

---

## FASE 5 — Documentación

**Objetivo:** Documentar los requisitos de MariaDB para IACT-api y cerrar el estado de hallazgos.

### T-5.1 — Crear `PREREQUISITOS-MARIADB.md` en IACT-api

**Archivo:** `IACT-api/docs/setup/PREREQUISITOS-MARIADB.md` (nuevo)  
**Patrón:** Mismo patrón que `PREREQUISITOS-POSTGRESQL.md`  
**Contenido:**
- Método de conexión por ambiente (socket Unix en producción, TCP en desarrollo)
- Usuario requerido: `django_user` con `SELECT` sobre `ivr_legacy.*`
- Objetos de BD requeridos para pipeline ETL (tablas, funciones, SPs)
- Comando de aprovisionamiento: `sudo bash setup.sh mariadb --full`
- Script de diagnóstico rápido
- Referencia a `IACT-db/docs/architecture/ANALISIS-MARIADB-PROVISIONAMIENTO-2026-05-10.md`

**Verificación:** Archivo existe en `docs/setup/`. Contiene sección de diagnóstico ejecutable.

---

### T-5.2 — Actualizar estado en `HALLAZGOS-PROVISIONER-MARIADB-2026-05-10.md`

**Archivo:** `IACT-db/docs/architecture/HALLAZGOS-PROVISIONER-MARIADB-2026-05-10.md`  
**Acción:** Actualizar tabla de resumen marcando H-MDB-007 y H-MDB-008 como RESUELTO.
Agregar fecha de resolución y referencia a los archivos modificados.

**Verificación:** Tabla de resumen muestra todos los hallazgos con estado actualizado.

---

### T-5.3 — Actualizar estado en `ANALISIS-MARIADB-PROVISIONAMIENTO-2026-05-10.md`

**Archivo:** `IACT-db/docs/architecture/ANALISIS-MARIADB-PROVISIONAMIENTO-2026-05-10.md`  
**Acción:** Actualizar tabla de estado consolidado reflejando:
- H-MDB-010..015: RESUELTO
- Pendientes de esta fase: T-1.4 (grants en tablas analíticas) 

**Verificación:** Sección 4 muestra estado correcto de cada objeto.

---

### T-5.4 — Actualizar `CONFIGURACION-ENTORNOS.md` en IACT-api con referencia a MariaDB

**Archivo:** `IACT-api/docs/setup/CONFIGURACION-ENTORNOS.md`  
**Acción:** Agregar entrada en la tabla de variables del `.env` para las variables IVR
(`IVR_DB_NAME`, `IVR_DB_USER`, `IVR_DB_PASSWORD`, `IVR_DB_SOCKET`) y referencia
a `PREREQUISITOS-MARIADB.md`.

**Verificación:** El documento menciona las variables IVR y el link al nuevo prerequisitos.

---

## Resumen ejecutivo

| Fase | Tareas | Archivos afectados | Prioridad |
|---|---|---|---|
| FASE 0 — Utilidades logging | T-0.1..T-0.7 | `database.sh`, `setup.sh`, `provision-mariadb.sh`, `mariadb/setup.sh` | ALTA |
| FASE 1 — Provisionamiento MariaDB | T-1.1..T-1.5 | `provision-mariadb.sh` | ALTA |
| FASE 2 — Adminer | T-2.1 | `adminer/bootstrap.sh` | MEDIA |
| FASE 3 — verify.sh schema | T-3.1..T-3.2 | `verify.sh` | ALTA |
| FASE 4 — IACT-api testing | T-4.1..T-4.3 | `testing.py`, `testing_local.py` | ALTA |
| FASE 5 — Documentación | T-5.1..T-5.4 | Docs en ambos repos | MEDIA |

**Total: 18 tareas atómicas**

---

## Orden de ejecución recomendado

```
FASE 0 → FASE 1 → FASE 3 → FASE 4 → FASE 2 → FASE 5
```

FASE 0 primero porque sus correcciones (T-0.1, T-0.4) son prerequisito de FASE 1.
FASE 3 antes que FASE 2 porque `verify.sh` mejorado permite confirmar que FASE 1
funcionó correctamente.
FASE 4 antes que FASE 5 porque T-4.1..4.3 pueden descubrir nuevos hallazgos a documentar.
FASE 2 al final porque Adminer es opcional para desarrollo.

# Catálogo de bugs — IACT-db

**Fecha:** 2026-05-12  
**Metodología:** shellcheck, pyflakes, lectura directa de código, verificación
funcional en BD. 44 archivos auditados.  
**Herramientas:** shellcheck 0.9.0, pyflakes, MariaDB 10.11.14.

---

## Resumen ejecutivo

| ID | Severidad | Archivo | Descripción breve |
|---|---|---|---|
| BUG-001 | ALTA | `utils/core.sh` L326 | `break` sin loop envolvente dentro de función |
| BUG-002 | ALTA | `sp_etl_pipeline.sql` | EXIT HANDLER de `sp_etl_base_clientes` no actualiza `v_maestro_id` |
| BUG-003 | ALTA | `provisioners/mariadb/setup.sh` | Verificación CNST-003 usa `USER_PRIVILEGES` — falso negativo permanente |
| BUG-004 | MEDIA | `sp_rpt_reportes.sql` | División por cero silenciosa en `sp_rpt_clientes` y `sp_rpt_llamadas_abandonadas` |
| BUG-005 | MEDIA | `backup_ivr_legacy.sh` L309 | `TABLES=$(root_exec ...)` con `set -euo` sin `|| true` — exit silencioso |
| BUG-006 | MEDIA | `backup_ivr_legacy.sh` L279 | `SKIP_GRANT=$(root_exec ...)` — mismo patrón que BUG-005 |
| BUG-007 | BAJA | `utils/core.sh` L75 | `local backup=$(...)` — SC2155, enmascara el exit code de `date` |
| BUG-008 | BAJA | `utils/provisioning.sh` L28 | `export PROJECT_ROOT=$(pwd)` — SC2155, enmascara exit code de `pwd` |
| BUG-009 | BAJA | `ssl.sh` L179/183/223 | Archivos temporales con rutas fijas en `/tmp` — race condition en CI |
| BUG-010 | INFORMATIVO | `poblar_historico.py` L408/415/504/557 | f-strings sin `{}` — prefijo `f` innecesario |
| BUG-011 | INFORMATIVO | `perfiles/q01_2026.py` etc. | pyflakes reporta imports sin uso — falso positivo |

---

## BUG-001 — `break` sin loop en `utils/core.sh` L326

**Severidad:** ALTA  
**Archivo:** `utils/core.sh`  
**Línea:** 326

### Descripción

La función `service_action()` contiene un `case` que, dentro del bloque
`mariadb*|mysql*`, usa `break` para saltar cuando no hay daemon disponible:

```bash
else
    log_debug "service_action: mariadbd/mysqld no disponibles"
    break   # ← sin loop envolvente
fi
```

En bash, `break` dentro de un `case` sin un `while`/`for`/`until` envolvente
no termina la función — salir del `case` en bash es implícito al llegar a `;;`.
El comportamiento real: el `break` se ignora y la ejecución continúa en la
siguiente línea después del `fi`, ejecutando código que supone que `daemon`
está definido.

**Verificación:**

```bash
bash -c 'f() { case x in x) break; echo "continúa"; ;; esac; }; f'
# output: "continúa" — el break no terminó la función
```

**Impacto:** Si `mariadbd` y `mysqld` no están disponibles, el código
continúa intentando usar la variable `daemon` (vacía) y ejecuta `nohup su`
con un daemon vacío, lo que falla silenciosamente.

**Corrección:**

```bash
else
    log_debug "service_action: mariadbd/mysqld no disponibles"
    return 1   # ← return sale de la función correctamente
fi
```

---

## BUG-002 — EXIT HANDLER de `sp_etl_base_clientes` no actualiza `v_maestro_id`

**Severidad:** ALTA  
**Archivo:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Línea:** ~387 (dentro de `sp_etl_maestro`)

### Descripción

`sp_etl_maestro` tiene dos bloques `BEGIN...END` con `EXIT HANDLER FOR SQLEXCEPTION`,
uno por cada SP que llama. El handler de `sp_etl_base_detalle` actualiza tanto
el step como el maestro en `job_execution_log`:

```sql
-- Handler sp_etl_base_detalle (correcto):
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    UPDATE job_execution_log SET status='FAILED' ... WHERE id = v_step_id;
    UPDATE job_execution_log SET status='FAILED' ... WHERE id = v_maestro_id;  -- ✓
END;
```

El handler de `sp_etl_base_clientes` **solo actualiza el step**:

```sql
-- Handler sp_etl_base_clientes (bug):
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    UPDATE job_execution_log SET status='FAILED' ... WHERE id = v_step_id;
    -- v_maestro_id no se actualiza → queda en status='RUNNING'
END;
```

**Impacto:** Si `sp_etl_base_clientes` lanza una excepción SQL,
`job_execution_log` queda con la fila del maestro en `status='RUNNING'`
indefinidamente. En la siguiente ejecución, `sp_etl_maestro` detecta un
RUNNING de las últimas 6 horas y hace SKIP — el ETL deja de procesar datos
sin que ningún operador sea alertado.

**Corrección:**

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
    UPDATE job_execution_log
    SET status='FAILED', end_time=NOW(), error_message=v_err_msg
    WHERE id = v_step_id;
    UPDATE job_execution_log
    SET status='FAILED', end_time=NOW(),
        error_message=CONCAT('Falló etl_base_clientes: ', v_err_msg)
    WHERE id = v_maestro_id;   -- ← agregar esta línea
END;
```

---

## BUG-003 — Verificación CNST-003 siempre reporta falso negativo

**Severidad:** ALTA  
**Archivo:** `provisioners/mariadb/setup.sh`  
**Línea:** ~163

### Descripción

La verificación CNST-003 en `setup.sh` consulta `USER_PRIVILEGES`:

```sql
SELECT COUNT(*) FROM information_schema.USER_PRIVILEGES
WHERE GRANTEE LIKE 'django_user%'
AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE','DROP','CREATE','ALTER');
```

`USER_PRIVILEGES` solo refleja grants globales (`GRANT ALL ON *.*`).
Los grants de tabla específica (`GRANT INSERT ON ivr_legacy.etl_runs`) viven en
`TABLE_PRIVILEGES` y son **invisibles** a esta consulta.

Tras correr `provision-mariadb.sh`, `django_user` tiene `INSERT, UPDATE, DELETE`
en 5 tablas, pero la verificación CNST-003 sigue reportando 0 escrituras:
`"CNST-003 verificado: django_user es READ-ONLY en ivr_legacy"`.

**Impacto:** El operador cree que CNST-003 está vigente. En realidad,
`django_user` tiene escritura en `etl_runs`, `base_ivr_detalle`,
`base_ivr_clientes`, `job_execution_log` y `job_config`.

**Corrección:**

```bash
# Consultar TABLE_PRIVILEGES en lugar de USER_PRIVILEGES:
write_tbls=$(mysql ... -e "
    SELECT GROUP_CONCAT(DISTINCT TABLE_NAME ORDER BY TABLE_NAME)
    FROM information_schema.TABLE_PRIVILEGES
    WHERE GRANTEE LIKE '''${db_user}''%'
    AND TABLE_SCHEMA = '${db_name}'
    AND PRIVILEGE_TYPE IN ('INSERT','UPDATE','DELETE');")

if [[ -z "$write_tbls" ]]; then
    log_success "CNST-003 verificado: ${db_user} es READ-ONLY en ${db_name}"
else
    log_info "CNST-003: ${db_user} tiene escritura en tablas operacionales: ${write_tbls}"
    log_info "  (extensión controlada por provision-mariadb.sh — ver CNST-003)"
fi
```

---

## BUG-004 — División por cero silenciosa en SPs de reporte

**Severidad:** MEDIA  
**Archivo:** `provisioners/mariadb/sp_rpt_reportes.sql`

### Descripción

`sp_rpt_clientes` calcula `pct_del_total` dividiendo por una subconsulta:

```sql
c.clientes_unicos
/ (SELECT SUM(c2.clientes_unicos)
   FROM base_ivr_clientes c2
   WHERE c2.trimestre = p_quarter)
* 100
```

Si `base_ivr_clientes` no tiene filas para `p_quarter` (ETL no ejecutado,
quarter incorrecto), el `SUM` retorna `NULL` y la división produce `NULL`
en el campo `pct_del_total`.

El mismo patrón sin `NULLIF` aparece en:
- `sp_rpt_clientes` L55
- `sp_rpt_centros_transferencia` L89 y en la variable `v_total_quarter` / L138
- `sp_rpt_llamadas_abandonadas` (variable `v_total_quarter` / L138)

Por contraste, `sp_rpt_centros_xsegmento` sí usa `NULLIF`:
```sql
/ NULLIF(SUM(b.total_llamadas), 0) * 100
```

MariaDB no lanza `ERROR` por división por cero — retorna `NULL`.
El reporte llega al endpoint Django con `pct_del_total = None` en lugar
de un error explícito.

**Corrección:**

```sql
-- En sp_rpt_clientes:
c.clientes_unicos
/ NULLIF(
    (SELECT SUM(c2.clientes_unicos) FROM base_ivr_clientes c2
     WHERE c2.trimestre = p_quarter),
  0) * 100

-- En sp_rpt_llamadas_abandonadas, para v_total_quarter:
ROUND(SUM(b.total_llamadas) / NULLIF(v_total_quarter, 0) * 100, 2)
```

---

## BUG-005 — `TABLES=$(root_exec ...)` con `set -euo` sin protección

**Severidad:** MEDIA  
**Archivo:** `provisioners/mariadb/backup_ivr_legacy.sh`  
**Línea:** 309

### Descripción

```bash
set -euo pipefail   # L44
...
TABLES=$(root_exec "${DB}" -N -e "SELECT table_name ..." 2>/dev/null)
```

Si `root_exec` falla (MariaDB no disponible, credenciales incorrectas,
socket no encontrado), `mysql` retorna exit code 1. Con `set -e`, bash
termina el script silenciosamente al evaluar `TABLES=$(cmd_fallida)`.

El `2>/dev/null` suprime el stderr de mysql pero **no** el exit code.

**Impacto:** El script de backup termina sin mensaje de error, sin
limpiar archivos intermedios, y sin registrar hallazgos. El operador
ve que el script se cortó sin diagnóstico.

**Corrección:**

```bash
TABLES=$(root_exec "${DB}" -N -e "SELECT table_name ..." 2>/dev/null) || true
# O más explícito:
TABLES=$(root_exec "${DB}" -N -e "SELECT table_name ..." 2>/dev/null) || {
    log "WARN: No se pudo obtener lista de tablas — BD no responde"
    TABLES=""
}
```

---

## BUG-006 — `SKIP_GRANT=$(root_exec ...)` — mismo patrón que BUG-005

**Severidad:** MEDIA  
**Archivo:** `provisioners/mariadb/backup_ivr_legacy.sh`  
**Línea:** 279

Igual que BUG-005: `SKIP_GRANT=$(root_exec -e "SHOW VARIABLES ..." | awk ...)`.
El pipe añade un nivel adicional: si `root_exec` falla, el pipe puede enmascarar
el exit code dependiendo de `pipefail`.

**Corrección:** `SKIP_GRANT=$(root_exec ...) || SKIP_GRANT=""`

---

## BUG-007 — SC2155: `local backup=$(...)` en `utils/core.sh` L75

**Severidad:** BAJA  
**Archivo:** `utils/core.sh`  
**Línea:** 75

```bash
local backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
```

`local` siempre retorna exit 0 aunque la asignación falle. Si `date`
falla (improbable pero posible en entornos muy restringidos), el error
queda enmascarado y `$backup` queda vacío.

**Corrección:**

```bash
local backup
backup="${file}.backup.$(date +%Y%m%d_%H%M%S)"
```

---

## BUG-008 — SC2155: `export PROJECT_ROOT=$(pwd)` en `utils/provisioning.sh` L28

**Severidad:** BAJA  
**Archivo:** `utils/provisioning.sh`  
**Línea:** 28

```bash
export PROJECT_ROOT="$(pwd)"
```

`export` con asignación enmascara el exit code de `pwd`. Si el directorio
actual no existe (cd previo fallido), el error queda oculto.

**Corrección:**

```bash
PROJECT_ROOT="$(pwd)"
export PROJECT_ROOT
```

---

## BUG-009 — Archivos temporales con rutas fijas en `ssl.sh`

**Severidad:** BAJA  
**Archivo:** `provisioners/adminer/ssl.sh`  
**Líneas:** 179, 183, 223

```bash
local csr_file="/tmp/adminer.csr"
local san_config="/tmp/adminer_san.cnf"
local ext_file="/tmp/adminer_ext.cnf"
```

Rutas fijas en `/tmp` — si dos instancias de `ssl.sh` corren simultáneamente
(entornos de CI con paralelismo), los archivos se sobreescriben mutuamente
produciendo certificados corruptos.

**Corrección:**

```bash
local csr_file
csr_file=$(mktemp /tmp/adminer_XXXXXX.csr)
local san_config
san_config=$(mktemp /tmp/adminer_san_XXXXXX.cnf)
local ext_file
ext_file=$(mktemp /tmp/adminer_ext_XXXXXX.cnf)
```

---

## BUG-010 — f-strings sin `{}` en `poblar_historico.py`

**Severidad:** INFORMATIVO  
**Archivo:** `provisioners/mariadb/poblar_historico.py`  
**Líneas:** 408, 415, 504, 557

```python
print(f"  Sin menús quitados")    # f-prefix innecesario — sin placeholders
print(f"  poblar_historico.py")   # ídem
```

No es un bug funcional — el código produce el output correcto. Es un
style issue: el prefijo `f` es redundante y puede confundir a quien
lee el código esperando interpolación.

**Corrección:** Eliminar el prefijo `f`:

```python
print("  Sin menús quitados")
print("  poblar_historico.py")
```

---

## BUG-011 — Falso positivo de pyflakes en perfiles proxy

**Severidad:** INFORMATIVO  
**Archivos:** `perfiles/q01_2026.py`, `perfiles/q02_2026.py`, `perfiles/q04_2025.py`

pyflakes reporta `'MENUS' imported but unused` en los perfiles proxy.
Los imports son necesarios porque `perfiles/__init__.py` los re-importa:

```python
# __init__.py:
from perfiles.q01_2026 import CONFIG as CFG_Q01_26, MENUS as M_Q01_26, VDN_POR_MENU as V_Q01_26
```

Sin el import en `q01_2026.py`, `__init__.py` fallaría con `ImportError`.
El análisis de pyflakes es dentro del archivo individual — no ve el uso externo.

**No requiere corrección.** Puede suprimirse con `# noqa: F401` si se quiere
silenciar la advertencia de herramientas CI.

---

## Bugs descartados en el análisis

| Candidato | Veredicto |
|---|---|
| `ivr_contar_dias_semana` O(n) | Limitación de performance, no bug. Rango máximo ~92 días. |
| `etl_runs` índice para heartbeat | No hay bug — `idx_timeout (status, timeout_at)` existe. |
| `verify.sh` check EXECUTE | No hay bug — `COUNT(DISTINCT Routine_name)` elimina duplicados por host. |
| Importes sin uso en perfiles | Falso positivo de pyflakes — necesarios para re-exportación. |
| SC1090 en todos los scripts | No es bug — source dinámico es correcto e intencional. |
| f-strings sin placeholder | Style issue, no bug funcional. |

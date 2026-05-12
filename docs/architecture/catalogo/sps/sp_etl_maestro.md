# `sp_etl_maestro`

**Archivo fuente:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Schema:** `ivr_legacy`  
**DEFINER:** `root@localhost` — SQL SECURITY DEFINER  
**Tipo:** PROCEDURE  
**Versión:** 2.0.0

---

## Propósito

Orquestador del pipeline ETL IVR. Es el único punto de entrada para la carga
de datos del quarter actual. Ejecuta seis pasos secuenciales con checkpoints
en `job_execution_log`, controla la concurrencia y determina automáticamente
el quarter y la tabla fuente según la fecha del sistema.

---

## Firma

```sql
CALL sp_etl_maestro();
-- Sin parámetros. Calcula el quarter actual internamente.
```

---

## Quién lo invoca

| Invocador | Contexto |
|---|---|
| `evt_etl_diario` | MySQL Event — disparo automático diario a las 02:00 AM |
| `run_etl.py` (IACT-api) | Django management command — ejecución manual o por APScheduler |

`django_user` tiene `GRANT EXECUTE ON PROCEDURE sp_etl_maestro` y puede
invocarlo directamente. Los SPs internos que llama (`sp_etl_base_detalle`,
`sp_etl_base_clientes`, `sp_etl_validar`) los invoca como DEFINER=root y
`django_user` no necesita EXECUTE en ellos.

---

## Flujo de ejecución — 7 pasos

```
PASO 0: ¿job_config.is_enabled = TRUE para 'etl_diario'?
           └── NO → INSERT SKIP en job_execution_log, v_abort=TRUE

PASO 1: ¿Hay otro RUNNING con start_time < 6h?
           └── SÍ → INSERT SKIP, v_abort=TRUE

PASO 2: Calcular quarter y tabla fuente
           v_year  = YEAR(CURDATE())
           v_qnum  = QUARTER(CURDATE())
           v_quarter = 'Q0{qnum}_{year_2d}'
           v_table   = 'tbl_historico_t{qnum}_{year}'

PASO 3: INSERT RUNNING en job_execution_log (maestro)
           v_maestro_id = LAST_INSERT_ID()

PASO 4: CALL sp_etl_base_detalle(...)
           EXIT HANDLER → marca step y maestro como FAILED

PASO 5: CALL sp_etl_base_clientes(...)
           EXIT HANDLER → marca step y maestro como FAILED

PASO 6: CALL sp_etl_validar(...)
           v_ok, v_msg ← resultado de validación

PASO 7: UPDATE maestro → SUCCESS o PARTIAL según v_ok
```

---

## Tablas que lee

| Tabla | Operación | Propósito |
|---|---|---|
| `job_config` | SELECT | Verificar `is_enabled` y `timeout_seconds` |
| `job_execution_log` | SELECT | Verificar concurrencia (PASO 1) |
| `base_ivr_detalle` | SELECT (vía `sp_etl_validar`) | Conteo post-carga |
| `base_ivr_clientes` | SELECT (vía `sp_etl_validar`) | Conteo post-carga |

## Tablas que escribe

| Tabla | Operación | Propósito |
|---|---|---|
| `job_execution_log` | INSERT, UPDATE | Checkpoints por paso (root/DEFINER) |
| `base_ivr_detalle` | INSERT/UPDATE (vía `sp_etl_base_detalle`) | Datos ETL |
| `base_ivr_clientes` | INSERT/UPDATE (vía `sp_etl_base_clientes`) | Datos ETL |

---

## Variables internas clave

| Variable | Tipo | Propósito |
|---|---|---|
| `v_abort` | BOOLEAN DEFAULT FALSE | Flag de salida temprana (reemplaza LEAVE en handlers) |
| `v_maestro_id` | INT | ID del registro maestro en `job_execution_log` |
| `v_step_id` | INT | ID del registro de cada paso en `job_execution_log` |
| `v_ok` | BOOLEAN | Resultado de `sp_etl_validar` |
| `v_quarter` | VARCHAR(10) | `'Q02_26'` — calculado en PASO 2 |
| `v_table` | VARCHAR(100) | `'tbl_historico_t2_2026'` — calculado en PASO 2 |

---

## Manejo de errores

Cada paso crítico (PASO 4 y PASO 5) tiene su propio `BEGIN...END` con
`DECLARE EXIT HANDLER FOR SQLEXCEPTION`. Cuando el handler dispara:

1. Marca el `v_step_id` como `FAILED` con el mensaje de error
2. Marca el `v_maestro_id` como `FAILED` de inmediato
3. El handler sale del bloque interno — la ejecución continúa en PASO 6

Esto garantiza que si `sp_etl_validar` también falla (y PASO 7 no ejecuta),
el maestro no queda en `RUNNING` indefinidamente bloqueando las siguientes
ejecuciones (BUG-002, resuelto en FASE 4).

---

## Estados posibles en `job_execution_log` al finalizar

| Estado del maestro | Condición |
|---|---|
| `SUCCESS` | Ambos ETL y validación correctos |
| `PARTIAL` | Algún paso falló o validación retorna `v_ok=FALSE` |
| `FAILED` | SQLEXCEPTION en PASO 4 o PASO 5, y PASO 7 no ejecutó |
| `SKIP` | Job deshabilitado o concurrencia activa |

---

## Ejemplo de invocación

```sql
CALL sp_etl_maestro();

-- Verificar resultado:
SELECT step_name, status, records_procesados, error_message
FROM job_execution_log
WHERE job_name = 'etl_diario'
ORDER BY id DESC LIMIT 5;
```

---

## Dependencias

```
sp_etl_maestro
  ├── job_config          (lectura)
  ├── job_execution_log   (lectura y escritura)
  ├── sp_etl_base_detalle (PASO 4)
  │     └── tbl_historico_tN_YYYY  (lectura — tabla dinámica)
  │     └── base_ivr_detalle       (escritura)
  ├── sp_etl_base_clientes (PASO 5)
  │     └── tbl_historico_tN_YYYY  (lectura — tabla dinámica)
  │     └── base_ivr_clientes      (escritura)
  └── sp_etl_validar (PASO 6)
        └── base_ivr_detalle   (lectura)
        └── base_ivr_clientes  (lectura)
```

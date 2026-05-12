# `job_execution_log`

**Schema:** `ivr_legacy`  
**Motor:** InnoDB

---

## Propósito

Tracking granular del pipeline ETL. Registra un fila por cada paso de cada
ejecución del job. Es la fuente de verdad para monitoreo operacional.

---

## Quién escribe

`sp_etl_maestro`, `sp_etl_historico` como `DEFINER=root`.
`django_user` **no tiene** INSERT/UPDATE — el ETL escribe en nombre del sistema.

---

## Columnas

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | INT AUTO_INCREMENT PK | |
| `job_name` | VARCHAR(100) NOT NULL | `etl_diario` \| `etl_historico` |
| `quarter_name` | VARCHAR(20) NULL | `'Q02_26'` |
| `step_name` | VARCHAR(50) NULL | `maestro` \| `etl_base_detalle` \| `etl_base_clientes` |
| `tabla_origen` | VARCHAR(100) NULL | `tbl_historico_t2_2026` |
| `start_time` | DATETIME NOT NULL | |
| `end_time` | DATETIME NULL | NULL mientras RUNNING |
| `status` | ENUM NOT NULL DEFAULT 'RUNNING' | `RUNNING` \| `SUCCESS` \| `PARTIAL` \| `FAILED` \| `SKIP` \| `TIMEOUT` |
| `records_procesados` | INT NULL DEFAULT 0 | Filas INSERT/UPDATE en base_ivr_* |
| `duracion_seg` | INT NULL | Calculado automáticamente al actualizar end_time |
| `error_message` | TEXT NULL | Mensaje del SQLEXCEPTION o descripción del problema |
| `ejecutado_por` | VARCHAR(50) NULL DEFAULT 'evt_etl_diario' | `evt_etl_diario` \| `management_command` \| `manual` |

---

## Estados del ciclo de vida

```
RUNNING → SUCCESS    (pipeline completó y validación pasó)
RUNNING → PARTIAL    (pipeline completó pero validación falló)
RUNNING → FAILED     (SQLEXCEPTION no recuperable)
RUNNING → SKIP       (job deshabilitado o concurrencia activa)
RUNNING → TIMEOUT    (heartbeat de run_etl.py detectó timeout)
```

---

## Consultas de monitoreo frecuentes

```sql
-- Últimas 10 ejecuciones del maestro:
SELECT step_name, status, start_time, end_time, records_procesados
FROM job_execution_log
WHERE job_name='etl_diario' AND step_name='maestro'
ORDER BY id DESC LIMIT 10;

-- Limpiar maestros RUNNING huérfanos:
UPDATE job_execution_log
SET status='FAILED', end_time=NOW(),
    error_message='corregido manualmente — proceso terminado inesperadamente'
WHERE status='RUNNING' AND start_time < DATE_SUB(NOW(), INTERVAL 2 HOUR);
```

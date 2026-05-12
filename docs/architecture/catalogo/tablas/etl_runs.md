# `etl_runs`

**Schema:** `ivr_legacy`  
**Motor:** InnoDB

---

## Propósito

Tracking por ejecución del management command `run_etl` de IACT-api.
A diferencia de `job_execution_log` (tracking interno del SP por paso),
`etl_runs` refleja el ciclo de vida de la invocación de Django: inicio,
heartbeat y estado final. Es la tabla que `django_user` escribe directamente.

---

## Quién escribe

`run_etl.py` y `scheduler.py` de IACT-api como `django_user`.
Operaciones: INSERT (inicio) y UPDATE (heartbeat, estado final).
DELETE no está autorizado — `django_user` no tiene ese privilegio.

---

## Quién lee

IACT-api para verificar estado actual, detectar timeouts y evitar ejecuciones
concurrentes desde el lado de la aplicación.

---

## Columnas

| Columna | Tipo | Descripción |
|---|---|---|
| `id` | INT AUTO_INCREMENT PK | |
| `trimestre` | VARCHAR(20) NOT NULL | Quarter procesado |
| `inicio_at` | DATETIME NOT NULL | Timestamp de inicio de run_etl |
| `fin_at` | DATETIME NULL | Timestamp de fin (NULL si en curso) |
| `timeout_at` | DATETIME NOT NULL | Límite. Si sigue `en_ejecucion` después → timeout |
| `heartbeat_at` | DATETIME NULL | Actualizado cada ~60s por el thread de heartbeat |
| `status` | ENUM NOT NULL DEFAULT 'en_ejecucion' | `en_ejecucion` \| `success` \| `failed` \| `timeout` \| `skip` |
| `registros_detalle` | INT NULL DEFAULT 0 | Copiado de job_execution_log al finalizar |
| `registros_clientes` | INT NULL DEFAULT 0 | Ídem |
| `error_message` | TEXT NULL | Mensaje de error de la capa Python |
| `trigger_source` | VARCHAR(100) NULL DEFAULT 'django_command' | `django_command` \| `evt_etl_diario` \| `manual` |

---

## Diferencias con `job_execution_log`

| Aspecto | `etl_runs` | `job_execution_log` |
|---|---|---|
| Escritor | `django_user` (app Django) | `root` (SPs ETL) |
| Granularidad | Una fila por ejecución del command | Una fila por PASO del SP |
| Heartbeat | Sí — actualizado cada ~60s | No |
| Timeout | Campo explícito `timeout_at` | No |
| Propósito | Monitoreo desde la app | Diagnóstico del pipeline SQL |

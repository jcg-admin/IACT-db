# `evt_etl_diario`

**Archivo fuente:** `provisioners/mariadb/sp_etl_pipeline.sql`  
**Schema:** `ivr_legacy`  
**Tipo:** MySQL Event (Recurring)  
**Status:** ENABLED

---

## Propósito

Disparo automático nocturno del pipeline ETL IVR. Ejecuta `sp_etl_maestro()`
una vez al día en la madrugada para procesar los datos del quarter actual.
Es la única forma de ejecución automática — la ejecución manual se realiza
desde `run_etl.py` en IACT-api.

---

## Definición

```sql
CREATE EVENT evt_etl_diario
    ON SCHEDULE EVERY 1 DAY
    STARTS CONCAT(CURDATE() + INTERVAL 1 DAY, ' 02:00:00')
    COMMENT 'ETL IVR nocturno — ejecuta sp_etl_maestro()'
    DO CALL sp_etl_maestro();
```

---

## Programación

| Atributo | Valor |
|---|---|
| Tipo | RECURRING |
| Intervalo | Cada 1 DAY |
| Inicio | 02:00:00 AM del día siguiente a la creación |
| Fin | Sin expiración |
| Status | ENABLED |

---

## Flujo de control

El event solo llama a `sp_etl_maestro()`. Toda la lógica de control está en el SP:

```
evt_etl_diario (02:00 AM)
  └── CALL sp_etl_maestro()
        ├── PASO 0: ¿job habilitado?
        ├── PASO 1: ¿concurrencia activa?
        ├── PASO 2..7: pipeline completo
        └── Registra resultado en job_execution_log
```

---

## Prerequisitos operacionales

El MySQL Event Scheduler debe estar habilitado en el servidor:

```sql
-- Verificar:
SHOW VARIABLES LIKE 'event_scheduler';
-- Debe retornar: ON

-- Habilitar si está OFF:
SET GLOBAL event_scheduler = ON;
-- O en my.cnf: event-scheduler = ON
```

---

## Monitoreo

```sql
-- Estado actual del evento:
SELECT EVENT_NAME, STATUS, LAST_EXECUTED, STARTS, INTERVAL_VALUE, INTERVAL_FIELD
FROM information_schema.EVENTS
WHERE EVENT_SCHEMA = 'ivr_legacy' AND EVENT_NAME = 'evt_etl_diario';

-- Últimas 5 ejecuciones (vía job_execution_log):
SELECT step_name, status, start_time, end_time, records_procesados, error_message
FROM job_execution_log
WHERE job_name = 'etl_diario' AND step_name = 'maestro'
ORDER BY id DESC LIMIT 5;
```

---

## Habilitar / deshabilitar sin tocar el event

```sql
-- Deshabilitar el ETL (el event sigue existiendo, sp_etl_maestro hace SKIP):
UPDATE job_config SET is_enabled = FALSE WHERE job_name = 'etl_diario';

-- Rehabilitar:
UPDATE job_config SET is_enabled = TRUE WHERE job_name = 'etl_diario';
```

Este mecanismo es preferible a `ALTER EVENT ... DISABLE` porque:
- No requiere privilegio de EVENT para el operador
- `sp_etl_maestro` registra el SKIP en `job_execution_log` — hay trazabilidad
- Re-habilitar es instantáneo sin recrear el event

---

## Relación con `run_etl.py`

`evt_etl_diario` y `run_etl.py` pueden coexistir. El check de concurrencia en
PASO 1 de `sp_etl_maestro` (ventana de 6 horas) evita que ambos procesen el
mismo quarter simultáneamente.

- `evt_etl_diario` registra `ejecutado_por = 'evt_etl_diario'`
- `run_etl.py` registra `ejecutado_por = 'management_command'` (en `etl_runs`)

---

## Notas de seguridad

El event ejecuta como `root@localhost` (el DEFINER de `sp_etl_maestro`).
`django_user` puede invocar `sp_etl_maestro` directamente pero no puede
crear ni modificar events (no tiene `EVENT` privilege). La gestión del event
es responsabilidad del DBA.

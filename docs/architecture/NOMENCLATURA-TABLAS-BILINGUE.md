# Nomenclatura bilingüe — Tablas del pipeline ETL

**Fecha de decisión:** 2026-05-09
**Contexto:** Revisión del plan v2.1 — análisis de inconsistencia entre
`schema_base_ivr.sql` (provisioner) y `intermediate-tables.rst` (spec v2.1)
**Decisión registrada como:** D-NOM-001
**Impacta:** `etl_runs`, `run_etl.py`, `scheduler.py`, `schema_base_ivr.sql`

---

## Problema detectado

Durante la revisión del plan IACT-db v2.1 se identificó una inconsistencia
entre cuatro fuentes para las columnas de `etl_runs`:

| Columna | BD real / provisioner / triggers.rst | intermediate-tables.rst (spec v2.1) |
|---------|--------------------------------------|-------------------------------------|
| inicio del ETL | `iniciado_en` | `inicio_at` |
| fin del ETL | `finalizado_en` | `fin_at` |
| estado actual | `estado` | `status` |
| quién disparó | `ejecutado_por` | `trigger_source` |
| mensaje de error | `mensaje_error` | `error_message` |
| ENUM éxito | `exitoso` | `success` |
| ENUM fallo | `fallido` | `failed` |
| heartbeat | *(no existe)* | `heartbeat_at` |

El provisioner `schema_base_ivr.sql` fue escrito el 2026-05-07 con nombres
en español. El spec `intermediate-tables.rst` fue escrito el 2026-05-08
(commit `c987d529`) con nombres en inglés. Dentro del mismo commit,
`triggers.rst` usó los nombres en español del provisioner, creando una
inconsistencia interna en el spec.

---

## Análisis de las tres capas del sistema

### Capa 1 — Tablas fuente del cliente (`tbl_historico_*`)

Nomenclatura heredada del sistema del cliente: `dFecha`, `cMenu`,
`cDID_Centro_Transferencia`. No es modificable — es propiedad del cliente.
No aplica ninguna convención propia.

### Capa 2 — Tablas materializadas del ETL (`base_ivr_*`)

El ETL materializa datos del dominio IVR. El dominio es español porque
la fuente es española. Mantener consistencia con la fuente es correcto.
Columnas: `trimestre`, `segmento`, `centro_transferencia`, `total_llamadas`.

**Criterio:** misma capa semántica que la fuente → español.

### Capa 3 — Tablas de infraestructura del pipeline (`etl_runs`, `job_execution_log`, `job_config`)

Son tablas técnicas del sistema de orquestación, no datos de negocio.
`job_execution_log` ya está definida con nomenclatura inglesa:
`status`, `start_time`, `end_time`, `error_message`, `step_name`.

**Criterio:** infraestructura técnica del pipeline → inglés, coherente
con `job_execution_log` que ya existe y fue correcto desde el inicio.

---

## Decisión D-NOM-001

**`etl_runs` debe usar nomenclatura inglesa**, coherente con `job_execution_log`.

Son la misma capa (infraestructura del pipeline) y deben tener el mismo
idioma. La BD actual tiene nombres en español porque el provisioner se
escribió antes del spec v2.1. La corrección es un ALTER TABLE.

### Mapeo de cambios

| Columna actual (español) | Columna objetivo (inglés) | Tipo |
|--------------------------|---------------------------|------|
| `iniciado_en` | `inicio_at` | `DATETIME NOT NULL` |
| `finalizado_en` | `fin_at` | `DATETIME NULL` |
| `estado` | `status` | ENUM (ver abajo) |
| `ejecutado_por` | `trigger_source` | `VARCHAR(100)` |
| `mensaje_error` | `error_message` | `TEXT NULL` |
| *(no existe)* | `heartbeat_at` | `DATETIME NULL` (nuevo) |

### ENUM status — valores

| Valor actual | Valor objetivo | Coherencia con job_execution_log |
|---|---|---|
| `en_ejecucion` | `en_ejecucion` | Se mantiene — valor sin traducción directa en el ENUM de job_execution_log |
| `exitoso` | `success` | `job_execution_log.status = 'SUCCESS'` |
| `fallido` | `failed` | `job_execution_log.status = 'FAILED'` |
| `timeout` | `timeout` | `job_execution_log.status = 'TIMEOUT'` |
| `skip` | `skip` | `job_execution_log.status = 'SKIP'` |

**Nota sobre `en_ejecucion`:** `job_execution_log` usa `RUNNING` para el
estado de ejecución activa. Se mantiene `en_ejecucion` en `etl_runs` porque:
1. Es el valor que usa `sp_etl_maestro` internamente para detectar concurrencia.
2. Cambiar ese valor requiere modificar el SP desplegado en MariaDB.
3. El SP es de la Capa 2 (española) — su lógica interna en español es coherente.

Si en el futuro se refactoriza `sp_etl_maestro`, se puede migrar a `RUNNING`.

### `heartbeat_at` — columna nueva

El spec `intermediate-tables.rst` define `heartbeat_at` como el mecanismo
de liveness sin Redis/RabbitMQ (ADR-BACK-012): el management command
`run_etl` actualiza este campo cada 60 segundos. Si el proceso muere,
el heartbeat se detiene y una tarea de housekeeping detecta el timeout.

Esta columna no existe en la BD actual. Se agrega en el ALTER TABLE.

---

## SQL de migración

```sql
-- Migración: etl_runs — español → inglés + agregar heartbeat_at
-- Ejecutar en ivr_legacy

ALTER TABLE etl_runs
    CHANGE COLUMN iniciado_en   inicio_at      DATETIME     NOT NULL,
    CHANGE COLUMN finalizado_en fin_at         DATETIME     NULL,
    CHANGE COLUMN estado        status         ENUM(
                                                 'en_ejecucion',
                                                 'success',
                                                 'failed',
                                                 'timeout',
                                                 'skip'
                                               ) NOT NULL DEFAULT 'en_ejecucion',
    CHANGE COLUMN ejecutado_por trigger_source VARCHAR(100) NULL DEFAULT 'scheduler',
    CHANGE COLUMN mensaje_error error_message  TEXT         NULL,
    ADD    COLUMN heartbeat_at  DATETIME       NULL
           COMMENT 'Último heartbeat del thread de Django. NULL si no hay heartbeat activo.'
           AFTER timeout_at;

-- Actualizar índices para las columnas renombradas
ALTER TABLE etl_runs
    DROP   INDEX idx_estado_inicio,
    ADD    INDEX idx_status_inicio (status, inicio_at DESC),
    DROP   INDEX idx_timeout,
    ADD    INDEX idx_timeout       (status, timeout_at)
           COMMENT 'Usado por el heartbeat de Django para detectar timeouts';
```

---

## Impacto en el código Django

`run_etl.py` y `scheduler.py` en IACT-api ya usan los nombres en inglés
del spec (`intermediate-tables.rst`). **No requieren cambio** — fueron
implementados contra el spec correcto.

La única corrección pendiente en el código es agregar el update de
`heartbeat_at` en el heartbeat thread de `run_etl.py`, que el spec define
pero la implementación actual omite.

---

## Impacto en provisioners

`schema_base_ivr.sql` en `provisioners/mariadb/` debe actualizarse para
que futuras instalaciones desde cero generen la tabla con los nombres
correctos. Pendiente como parte de la tarea de ALTER TABLE.

---

## Resumen del patrón bilingüe — guía de referencia

| Tabla | Idioma | Razón |
|-------|--------|-------|
| `tbl_historico_*` | Notación del cliente | Fuente heredada, no modificable |
| `base_ivr_detalle` | Español | Datos de negocio IVR — misma capa que la fuente |
| `base_ivr_clientes` | Español | Datos de negocio IVR |
| `job_execution_log` | **Inglés** | Infraestructura del pipeline — ya correcto |
| `job_config` | Mixto | Nombres funcionales: `is_enabled`, `timeout_seconds` (inglés técnico) + `ventana_inicio`, `notas` (español operativo) — aceptable |
| `etl_runs` | **Inglés** (objetivo) | Infraestructura del pipeline — alinear con `job_execution_log` |

---

## Ver también

- `schema_base_ivr.sql` — DDL que requiere actualización
- `PLAN-IMPLEMENTACION-V2.1.md` — T-022 (verificación de `etl_runs`)
- `FLUJO-ETL-V2.1.md` — código Python de `run_etl` con nombres en español (a actualizar)
- IACT-api: `apps/pipeline/management/commands/run_etl.py` — ya con nombres en inglés
- IACT-api: `apps/pipeline/scheduler.py` — ya con nombres en inglés

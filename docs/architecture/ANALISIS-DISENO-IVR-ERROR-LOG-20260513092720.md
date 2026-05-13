# Análisis — Tabla `ivr_error_log`: diseño, normalización y decisiones

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Contexto:** Módulo 17 identifica que los errores de los SPs de reporte no persisten.
`job_execution_log` cubre los errores ETL. Esta tabla cubre todo lo demás.

---

## Qué enseña MariaDB sobre diseño de tablas de error

La mejor referencia es el propio MySQL/MariaDB. Sus dos tablas de log nativas son:

### `mysql.general_log`

```sql
CREATE TABLE general_log (
    event_time   TIMESTAMP(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    user_host    MEDIUMTEXT   NOT NULL,
    thread_id    BIGINT UNSIGNED NOT NULL,
    server_id    INT UNSIGNED NOT NULL,
    command_type VARCHAR(64)  NOT NULL,
    argument     MEDIUMTEXT   NOT NULL
) ENGINE=CSV;
```

Una sola tabla. Sin FK. Sin índices. Sin normalización alguna. Todo el contexto
en cada fila. `ENGINE=CSV` porque es append-only y la lectura es secundaria.

### `mysql.slow_log`

Mismo patrón: todo en una tabla, `start_time`, `user_host`, `query_time`,
`rows_sent`, `sql_text`. Cada fila cuenta su propia historia completa.

### `performance_schema.events_errors_summary_*`

Las tablas de errors en performance_schema son **tablas de resumen** (agregadas),
no de eventos individuales. No son logs — son contadores. Sirven para métricas
(`SUM_ERROR_RAISED`, `SUM_ERROR_HANDLED`) no para auditoría.

**Lección clave de MariaDB:** las tablas de log son intencionalmente denormalizadas.
La redundancia es una característica, no un defecto.

---

## Por qué `ivr_error_log` no está en 3NF — y por qué está bien

La Tercera Forma Normal (3NF) exige que cada atributo no-clave dependa únicamente
de la clave primaria y no de otros atributos no-clave. En una tabla de log,
esto se interpretaría así:

```
-- 3NF estricta requeriría:
error_type_catalog (id, codigo, descripcion, nivel_numerico)
sp_catalog         (id, nombre, schema_name, descripcion)
ivr_error_log      (id, ts, error_type_id FK, sp_id FK, sqlstate, mensaje)
```

**Por qué esto es un error de diseño para tablas de log:**

Las tablas de log tienen propiedades que las hacen incompatibles con la filosofía
de normalización estricta:

**1. Son append-only.** Las anomalías de actualización que la normalización previene
(inconsistencia al cambiar un valor en múltiples filas) no ocurren en tablas de log
porque las filas nunca se actualizan. El mismo texto `'PARAM_INVALIDO'` en 1,000 filas
no genera ningún riesgo de inconsistencia.

**2. El INSERT debe ser atómico y mínimo.** Un EXIT HANDLER en un SP captura un error
y tiene que registrarlo inmediatamente. Si el INSERT requiere hacer primero un
`SELECT id FROM error_type_catalog WHERE codigo = 'ETL_FALLO'`, ese SELECT puede
fallar (la tabla puede no estar disponible, puede haber un lock). El handler registra
el error o no lo registra — no puede fallar registrando el error.

**3. Cada fila debe ser autónoma.** Un log que requiere JOINs para ser legible es
un log degradado. Si `sp_catalog` se corrompe, los logs pierden contexto.
La auditoria debe sobrevivir a fallos parciales del sistema.

**4. Las tablas referenciadas pueden cambiar.** Si en el futuro se renombra un SP,
la referencia histórica en `sp_catalog` queda desactualizada. La fila de log
debe preservar el nombre del SP **en el momento del error**, no el nombre actual.

---

## Diseño elegido: semi-normalizado con ENUMs

El diseño de `ivr_error_log` usa un nivel intermedio:

| Columna | Nivel de normalización | Justificación |
|---|---|---|
| `error_type` | ENUM (vocabulario controlado) | Sin tabla satélite — INSERT atómico |
| `severity` | ENUM (vocabulario controlado) | Idem |
| `sp_nombre` | VARCHAR (denormalizado) | Nombre real al momento del error |
| `sql_state` | CHAR(5) (denormalizado) | SQLSTATE estándar — no cambia |
| `p_quarter` | VARCHAR (denormalizado) | Contexto histórico preservado |
| `p_segmento` | VARCHAR (denormalizado) | Idem |
| `job_log_id` | FK nullable | Vínculo débil — ON DELETE SET NULL |
| `contexto` | LONGTEXT JSON | Extensible sin alterar el schema |

### Por qué ENUM en lugar de una tabla `error_type_catalog`

Un ENUM garantiza el vocabulario controlado sin overhead de FK:

```sql
-- Con tabla satélite (problema):
INSERT INTO ivr_error_log (error_type_id, ...)
SELECT id FROM error_type_catalog WHERE codigo = 'PARAM_INVALIDO'  -- puede fallar
...

-- Con ENUM (solución):
INSERT INTO ivr_error_log (error_type, ...)
VALUES ('PARAM_INVALIDO', ...)  -- atómico, sin SELECT previo
```

Cuando el vocabulario de errores cambia (nuevo tipo), se hace `ALTER TABLE ivr_error_log
MODIFY error_type ENUM(...)` — una operación DDL, no data migration.

### Por qué `job_log_id` sí es FK (con ON DELETE SET NULL)

A diferencia de `sp_nombre`, el vínculo con `job_execution_log` sí aporta valor
como FK porque:
- Permite obtener el contexto completo del ETL (quarter, tabla, duración) con un JOIN
- `ON DELETE SET NULL` preserva el error aunque se purgue el log del job
- Es nullable — errores de reporte no tienen contexto ETL (`job_log_id = NULL`)

---

## Taxonomía de errores (`error_type`)

| Tipo | Severidad típica | Origen | Se registra desde |
|---|---|---|---|
| `PARAM_INVALIDO` | MEDIA | 7 SPs de reporte | EXIT HANDLER post-SIGNAL |
| `ETL_FALLO` | CRITICA | `sp_etl_maestro` PASO 4/5/6 | EXIT HANDLER |
| `ETL_PARTIAL` | ALTA | `sp_etl_maestro` PASO 7 | Código de negocio |
| `VALIDACION` | ALTA | `sp_etl_validar` | EXIT HANDLER o resultado p_ok=FALSE |
| `REPORTE_VACIO` | BAJA | 7 SPs de reporte | Código de negocio (si se desea) |
| `SISTEMA` | CRITICA | Cualquier SP | EXIT HANDLER con errno conocido |

---

## Índices — diseñados para las consultas operacionales

Las 5 consultas más frecuentes sobre una tabla de auditoría:

```sql
-- 1. "¿Qué errores hubo en las últimas 24 horas?" → idx_ts
SELECT * FROM ivr_error_log WHERE ts >= NOW() - INTERVAL 24 HOUR;

-- 2. "¿Hay errores CRITICOS pendientes?" → idx_severity_ts
SELECT * FROM ivr_error_log WHERE severity='CRITICA' AND ts >= NOW() - INTERVAL 48 HOUR;

-- 3. "¿Cuántas veces falló sp_rpt_clientes esta semana?" → idx_sp_ts
SELECT COUNT(*) FROM ivr_error_log WHERE sp_nombre='sp_rpt_clientes'
  AND ts >= NOW() - INTERVAL 7 DAY;

-- 4. "¿Qué errores tuvimos en Q02_26?" → idx_quarter_ts
SELECT * FROM ivr_error_log WHERE p_quarter='Q02_26';

-- 5. "¿Qué errores generó el job #54?" → idx_job_log
SELECT * FROM ivr_error_log WHERE job_log_id = 54;
```

---

## Vista `v_errores_recientes`

Consulta operacional para el dashboard Django: errores de las últimas 48 horas
con el estado del job ETL asociado (LEFT JOIN — null para errores de reporte).

```sql
SELECT e.id, e.ts, e.error_type, e.severity, e.sp_nombre,
       LEFT(e.error_message, 120) AS error_resumen,
       j.status AS job_status, j.step_name AS job_step
FROM ivr_error_log e
LEFT JOIN job_execution_log j ON j.id = e.job_log_id
WHERE e.ts >= NOW() - INTERVAL 48 HOUR
ORDER BY e.ts DESC;
```

---

## Respuesta directa a la pregunta de normalización

Las tablas de log **no deben estar en 3NF estricta**. La razón no es pereza de
diseño — es que las propiedades que la normalización protege (consistencia en
actualizaciones) no aplican a datos que nunca se actualizan. Y los costos que
la normalización impone (JOINs, INSERTs complejos, dependencias entre tablas)
sí penalizan en un caso de uso donde el INSERT rápido y el log autónomo son
los requerimientos principales.

El nivel correcto es **semi-normalizado**: ENUM para el vocabulario controlado
(evita valores libres sin overhead de FK), VARCHAR para el contexto histórico
(preserva exactamente qué pasó en el momento del error), y FK débil cuando
el JOIN con otra tabla aporta valor sin comprometer la integridad del log.

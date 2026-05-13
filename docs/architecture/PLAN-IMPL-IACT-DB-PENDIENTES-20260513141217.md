# Plan de Implementación — IACT-db Módulos 11-17

**Versión:** 2.1.0
**Fecha:** 2026-05-13
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR
**Principio:** cada tarea es atómica, desplegable y verificable de forma independiente.
Al cerrar cada tarea verify.sh debe pasar sin errores nuevos.
**Sin deuda técnica:** ninguna tarea deja código, provision o tests en estado incompleto.

---

## Cambio de nomenclatura respecto al análisis anterior

El análisis `ANALISIS-NOMENCLATURA-ERROR-LOG.md` (2026-05-13) demostró que
`ivr_error_log` era semánticamente incorrecto:

- El prefijo `ivr_` implica que los errores son del IVR (la fuente de datos).
  Los errores son de la plataforma analítica IACT que procesa esos datos.
- `error_log` es menos preciso que `event_log` — el ENUM incluye `PARAM_INVALIDO`
  y `VALIDACION`, que son eventos operacionales, no excepciones técnicas.
- Las tablas de control del proyecto usan `job_*` y `etl_*`, nunca `ivr_*`.

**Nombre adoptado: `pipeline_event_log`**
Inspiración directa: Databricks `pipeline_event_log` — mismo concepto:
auditoría + calidad de datos + estado del pipeline.
`pipeline_event_log` nombra correctamente el alcance total: errores del ETL
Y eventos de la API de reportes (PARAM_INVALIDO desde Django).

| Nombre anterior | Nombre nuevo |
|---|---|
| `ivr_error_log` | `pipeline_event_log` |
| `schema_error_log.sql` | `schema_pipeline_event_log.sql` |
| `v_errores_recientes` | `v_eventos_recientes` |

---

## Mapa de fases

```
FASE 1 — Provision + Infraestructura de eventos    (4 tareas)
FASE 2 — Window functions en 4 SPs de reporte      (4 tareas)
FASE 3 — Nuevos objetos de observabilidad           (2 tareas)
FASE 4 — Mejoras opcionales + monitoreo             (3 tareas)
```

**Versiones al iniciar el plan:**

| Objeto | Versión inicial | Versión final |
|---|---|---|
| `sp_etl_maestro` | 2.4.0 | 2.5.0 |
| `sp_etl_historico` | 2.0.0 | 2.1.0 |
| `sp_rpt_cMENU_ERROR` | 2.0.1 | 2.1.0 |
| `sp_rpt_menu_centro` | 2.0.1 | 2.1.0 |
| `sp_rpt_clientes` | 2.0.1 | 2.1.0 |
| `sp_rpt_menu_redirigidos` | 2.0.1 | 2.1.0 |
| `sp_rpt_llamadas_abandonadas` | 2.2.1 | 2.2.2 |
| `sp_rpt_centros_transferencia` | 2.1.1 | 2.2.0 |
| `sp_rpt_centros_xsegmento` | 2.2.1 | 2.3.0 |
| `v_etl_rendimiento` | — | 1.0.0 (nuevo) |
| `sp_rpt_resumen_abandono_rollup` | — | 1.0.0 (nuevo) |

---

## FASE 1 — Provision + Infraestructura de eventos

### T1.1 — Corregir `provision-mariadb.sh` y `verify.sh`

**Fecha estimada:** 2026-05-13
**Archivos:** `scripts/provision-mariadb.sh`, `verify.sh`

**Problema:** `schema_pipeline_event_log.sql`, `v_quarter_actual.sql` y
`v_sla_distribucion.sql` existen en disco pero no están en el array `sql_files`
de `provision-mariadb.sh`. En un despliegue limpio, `pipeline_event_log` no
existiría — T1.2, T1.3 y T1.4 fallarían.

**Cambios en `provision-mariadb.sh`:**

```bash
# Después de schema_base_ivr.sql:
"${prov}/schema_pipeline_event_log.sql"

# Sección de vistas (nueva), antes de Jobs:
"${prov}/objetos/vistas/v_quarter_actual.sql"
"${prov}/objetos/vistas/v_sla_distribucion.sql"
```

Actualizar mensaje de éxito: `(20 objetos)` → `(23 objetos)`.

**Cambios en `verify.sh`:**

```bash
# Agregar pipeline_event_log al bucle de tablas:
for tbl in base_ivr_detalle base_ivr_clientes \
           job_execution_log etl_runs job_config \
           pipeline_event_log; do
```

Actualizar contador: `(${tbl_ok}/5)` → `(${tbl_ok}/6)`.

**Verificación:**

```bash
# 2026-05-13: baseline antes de despliegue
bash scripts/provision-mariadb.sh
# → "23 objetos aplicados"

mysql ivr_legacy -e "SELECT COUNT(*) FROM pipeline_event_log;"
# → 0 (tabla existe, vacía)

bash verify.sh
# → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `fix(provision): schema_pipeline_event_log y vistas en provision y verify`

---

### T1.2 — `sp_etl_maestro` v2.5.0 — INSERT a `pipeline_event_log` en PASO 4/5/6 y PASO 7

**Prerrequisito:** T1.1
**Fecha estimada:** 2026-05-13
**Archivo:** `provisioners/mariadb/objetos/sps/sp_etl_maestro.sql`

**Cambio en PASO 4, 5, 6 (EXIT HANDLERs):** agregar bloque protegido antes
de la lógica existente del handler:

```sql
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    INSERT INTO pipeline_event_log
        (error_type, severity, sp_nombre, sql_state,
         p_quarter, error_message, job_log_id, ejecutado_por)
    VALUES (<valores por PASO>);
END;
```

| PASO | `error_type` | `severity` | `error_message` | `job_log_id` |
|---|---|---|---|---|
| 4 | `'ETL_FALLO'` | `'CRITICA'` | `CONCAT('Falló etl_base_detalle: ', v_err_msg)` | `v_maestro_id` |
| 5 | `'ETL_FALLO'` | `'CRITICA'` | `CONCAT('Falló etl_base_clientes: ', v_err_msg)` | `v_maestro_id` |
| 6 | `'ETL_PARTIAL'` | `'ALTA'` | `CONCAT('Error en sp_etl_validar: ', v_err_msg)` | `v_maestro_id` |

**Cambio en PASO 7 (v_ok=FALSE — GAP identificado en 2026-05-13):**

```sql
ELSE
    IF NOT COALESCE(v_ok, FALSE) THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO pipeline_event_log
                (error_type, severity, sp_nombre,
                 p_quarter, error_message, job_log_id, ejecutado_por)
            VALUES
                ('VALIDACION', 'ALTA', 'sp_etl_validar',
                 v_quarter, v_msg, v_maestro_id, 'evt_etl_diario');
        END;
    END IF;
    UPDATE job_execution_log SET status = IF(...), ...
```

**Verificación:**

```sql
-- Fecha verificación: 2026-05-13
SELECT COUNT(*) FROM pipeline_event_log;  -- baseline N
-- Simular fallo PASO 4: verificar que aparece ETL_FALLO con job_log_id
SELECT error_type, severity, sp_nombre, p_quarter, LEFT(error_message, 60)
FROM pipeline_event_log ORDER BY ts DESC LIMIT 1;
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(errores): sp_etl_maestro v2.5.0 — pipeline_event_log en PASO 4/5/6/7`

---

### T1.3 — 7 SPs de reporte vX.X.2 — INSERT a `pipeline_event_log` antes de cada SIGNAL

**Prerrequisito:** T1.1
**Fecha estimada:** 2026-05-13
**Archivos:** los 7 `sp_rpt_*.sql`

En cada validación de `p_quarter`, agregar antes del SIGNAL:

```sql
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    INSERT INTO pipeline_event_log
        (error_type, severity, sp_nombre, sql_state, mysql_errno,
         p_quarter, error_message, ejecutado_por)
    VALUES ('PARAM_INVALIDO', 'MEDIA', '<nombre_sp>', '22023', 1644,
            p_quarter,
            CONCAT('p_quarter invalido: ', p_quarter),
            'django_api');
END;
```

En cada validación de `p_segmento` (5 SPs con este parámetro):

```sql
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    INSERT INTO pipeline_event_log
        (error_type, severity, sp_nombre, sql_state, mysql_errno,
         p_quarter, p_segmento, error_message, ejecutado_por)
    VALUES ('PARAM_INVALIDO', 'MEDIA', '<nombre_sp>', '22023', 1644,
            p_quarter, p_segmento,
            CONCAT('p_segmento invalido: ', p_segmento),
            'django_api');
END;
```

**Versiones resultantes:**

| SP | Versión nueva | Valida segmento |
|---|---|---|
| `sp_rpt_cMENU_ERROR` | 2.0.2 | Sí |
| `sp_rpt_centros_transferencia` | 2.1.2 | Sí |
| `sp_rpt_centros_xsegmento` | 2.2.2 | No |
| `sp_rpt_clientes` | 2.0.2 | No |
| `sp_rpt_llamadas_abandonadas` | 2.2.2 | Sí |
| `sp_rpt_menu_centro` | 2.0.2 | Sí |
| `sp_rpt_menu_redirigidos` | 2.0.2 | Sí |

**Verificación:**

```sql
-- Fecha verificación: 2026-05-13
SELECT COUNT(*) FROM pipeline_event_log;  -- baseline N
CALL sp_rpt_clientes('INVALIDO');          -- ERROR 1644 (22023)
SELECT COUNT(*) FROM pipeline_event_log;  -- N+1

CALL sp_rpt_llamadas_abandonadas('Q01_25','seg_malo');
SELECT COUNT(*) FROM pipeline_event_log;  -- N+2

CALL sp_rpt_clientes('Q01_25');            -- resultado normal, sin evento
SELECT COUNT(*) FROM pipeline_event_log;  -- sigue N+2
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(errores): 7 SPs reporte vX.X.2 — pipeline_event_log antes de SIGNAL`

---

### T1.4 — `sp_etl_historico` v2.1.0 — cobertura completa de errores

**Prerrequisito:** T1.1
**Fecha estimada:** 2026-05-13
**Archivo:** `provisioners/mariadb/objetos/sps/sp_etl_historico.sql`
**Identificado en:** `ANALISIS-COBERTURA-IVR-ERROR-LOG.md` (2026-05-13) — GAP 2

`sp_etl_historico` no tiene EXIT HANDLER. Si `sp_etl_base_detalle` falla,
`job_execution_log` queda con `status='RUNNING'` indefinidamente. Tres sub-gaps:

**2a — INSERT a `pipeline_event_log` antes del SIGNAL de validación:**

```sql
IF p_quarter_num NOT IN (1, 2, 3, 4) THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             error_message, ejecutado_por)
        VALUES ('PARAM_INVALIDO', 'MEDIA', 'sp_etl_historico', '45000', 1644,
                CONCAT('p_quarter_num invalido: ', p_quarter_num),
                'django_api');
    END;
    SIGNAL ...
END IF;
```

**2b — EXIT HANDLERs para CALL a `sp_etl_base_detalle` y `sp_etl_base_clientes`:**

```sql
BEGIN
    DECLARE v_err_msg TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO pipeline_event_log
                (error_type, severity, sp_nombre, sql_state,
                 p_quarter, error_message, job_log_id, ejecutado_por)
            VALUES ('ETL_FALLO', 'CRITICA', 'sp_etl_historico', '45000',
                    v_quarter,
                    CONCAT('Falló etl_base_detalle: ', v_err_msg),
                    v_step_id, 'manual');
        END;
        UPDATE job_execution_log
        SET status='FAILED', end_time=NOW(), error_message=v_err_msg
        WHERE id = v_step_id;
    END;
    CALL sp_etl_base_detalle(v_quarter, v_inicio, v_fin, v_table, v_step_id);
END;
```

Handler análogo para `sp_etl_base_clientes`.

**2c — INSERT cuando `v_ok=FALSE`:**

```sql
CALL sp_etl_validar(v_quarter, v_ok, v_msg);
IF NOT COALESCE(v_ok, FALSE) THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO pipeline_event_log
            (error_type, severity, sp_nombre,
             p_quarter, error_message, ejecutado_por)
        VALUES ('VALIDACION', 'ALTA', 'sp_etl_validar',
                v_quarter, v_msg, 'manual');
    END;
END IF;
```

**Verificación:**

```bash
# Fecha verificación: 2026-05-13
# Simular p_quarter_num inválido:
mysql -e "CALL sp_etl_historico(2025, 5);"  -- ERROR + pipeline_event_log +1
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(errores): sp_etl_historico v2.1.0 — SIGNAL + EXIT HANDLERs + pipeline_event_log`

---

## FASE 2 — Window functions en 4 SPs de reporte

**Prerrequisito:** FASE 1 completa.

### T2.1 — `sp_rpt_cMENU_ERROR` v2.1.0 — `OVER()` reemplaza subconsulta

**Fecha estimada:** 2026-05-20
**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_cMENU_ERROR.sql`

**CORRECCIÓN** al `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md`:
la especificación correcta verificada en motor MariaDB 10.11.14 es `OVER()`
sin PARTITION BY. Con `p_segmento='todas'`: subq=119, `OVER(seg)`=55, `OVER()`=119.

```sql
-- Reemplazar subconsulta correlacionada:
(SELECT SUM(b2.total_llamadas) FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
   AND b2.menu REGEXP '^[0-9]+$'
   AND LENGTH(b2.menu) >= 7) AS total_anomalias_quarter

-- Por:
SUM(SUM(b.total_llamadas)) OVER () AS total_anomalias_quarter
```

**Verificación:**

```sql
-- Fecha verificación: 2026-05-20
CALL sp_rpt_cMENU_ERROR('Q01_25', 'todas');
-- total_anomalias_quarter debe ser 119 en TODAS las filas

CALL sp_rpt_cMENU_ERROR('Q01_25', 'nacional_A');
-- total_anomalias_quarter debe ser 55 en TODAS las filas
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_cMENU_ERROR v2.1.0 — OVER() reemplaza subq [corr]`

---

### T2.2 — `sp_rpt_menu_centro` v2.1.0 — `OVER(PARTITION BY centro)` reemplaza subconsulta

**Fecha estimada:** 2026-05-20
**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_menu_centro.sql`

```sql
-- Reemplazar:
ROUND(SUM(b.total_llamadas)
    / NULLIF(
        (SELECT SUM(b2.total_llamadas) FROM base_ivr_detalle b2
         WHERE b2.trimestre = p_quarter
           AND b2.centro_transferencia = b.centro_transferencia
           AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
      0) * 100, 2) AS pct_del_centro

-- Por:
ROUND(SUM(b.total_llamadas)
    / NULLIF(
        SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia),
      0) * 100, 2) AS pct_del_centro
```

**Verificación:**

```sql
-- Fecha verificación: 2026-05-20
-- Centro 10228051, p_segmento='todas': pct_del_centro = 87.50 (308/352)
-- Centro 10228051, p_segmento='nacional_A': pct_del_centro = 100.00 (154/154)
CALL sp_rpt_menu_centro('Q01_25', 'todas');
CALL sp_rpt_menu_centro('Q01_25', 'nacional_A');
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_menu_centro v2.1.0 — OVER(PARTITION BY centro) reemplaza subq`

---

### T2.3 — `sp_rpt_clientes` v2.1.0 — `OVER()` reemplaza subconsulta

**Fecha estimada:** 2026-05-20
**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_clientes.sql`

```sql
-- Reemplazar:
ROUND(c.clientes_unicos / NULLIF(
    (SELECT SUM(c2.clientes_unicos) FROM base_ivr_clientes c2
     WHERE c2.trimestre = p_quarter), 0) * 100, 2) AS pct_del_total

-- Por:
ROUND(c.clientes_unicos
    / NULLIF(SUM(c.clientes_unicos) OVER (), 0) * 100, 2) AS pct_del_total
```

**Verificación:**

```sql
-- Fecha verificación: 2026-05-20
CALL sp_rpt_clientes('Q01_25');
-- nacional_A: 37586, pct=45.25
-- nacional_B: 24753, pct=29.80
-- puebla:     20729, pct=24.95
-- suma pct = 100.00%
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_clientes v2.1.0 — OVER() reemplaza subconsulta`

---

### T2.4 — `sp_rpt_menu_redirigidos` v2.1.0 — `OVER(PARTITION BY menu)` + variable `v_total_scope`

**Fecha estimada:** 2026-05-20
**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_menu_redirigidos.sql`

**CORRECCIÓN** al `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md`:
subq1 requiere `OVER(PARTITION BY menu)`, no `OVER(PARTITION BY segmento, menu)`.
Con `p_segmento='todas'`, `SinOpcion_Cabecera`: subq=3942, `OVER(seg,menu)`=1698, `OVER(menu)`=3942.

```sql
-- subq1 — pct_del_menu:
ROUND(SUM(b.total_llamadas) / NULLIF(
    SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.menu),
  0) * 100, 2) AS pct_del_menu

-- subq2 — pct_del_total:
-- CORRECCIÓN H-T2.4-001: OVER() NO puede reemplazar subq2.
-- El WHERE del SP excluye VACIO y centros centinela; subq2 original los incluye.
-- Diferencia de denominador: 119205 vs 109639 (9566 filas) → KPI distinto.
-- Solución: variable v_total_scope pre-calculada ANTES del SELECT principal.
DECLARE v_total_scope BIGINT DEFAULT 0;
SELECT SUM(total_llamadas) INTO v_total_scope
FROM base_ivr_detalle
WHERE trimestre = p_quarter
  AND (p_segmento = 'todas' OR segmento = p_segmento);

-- Uso en el SELECT:
ROUND(SUM(b.total_llamadas) / NULLIF(v_total_scope, 0) * 100, 4) AS pct_del_total
```

**Verificación — OBLIGATORIO probar ambos escenarios:**

```sql
-- Fecha verificación: 2026-05-20
-- Escenario A: p_segmento='nacional_A'
CALL sp_rpt_menu_redirigidos('Q01_25', 'nacional_A');
-- SinOpcion_Cabecera/19020086: pct_del_menu = 1643/1698*100 = 96.76%

-- Escenario B: p_segmento='todas'
CALL sp_rpt_menu_redirigidos('Q01_25', 'todas');
-- SinOpcion_Cabecera/19020086: pct_del_menu = 1643/3942*100 = 41.68%
-- El cambio de 96.76% a 41.68% es CORRECTO — denominador más amplio
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_menu_redirigidos v2.1.0 — OVER(menu)+OVER() [corr]`

---

## FASE 3 — Nuevos objetos de observabilidad

### T3.1 — `v_etl_rendimiento` v1.0.0 — vista con LAG()

**Fecha estimada:** 2026-05-27
**Archivos:**
- CREAR: `provisioners/mariadb/objetos/vistas/v_etl_rendimiento.sql`
- MODIFICAR: `scripts/provision-mariadb.sh`

```sql
CREATE OR REPLACE VIEW v_etl_rendimiento AS
SELECT
    job_name
    , quarter_name
    , step_name
    , status
    , start_time
    , TIMESTAMPDIFF(SECOND, start_time, end_time)                        AS duracion_seg
    , LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
        OVER (PARTITION BY job_name, step_name ORDER BY start_time)      AS duracion_anterior_seg
    , TIMESTAMPDIFF(SECOND, start_time, end_time)
      - LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
          OVER (PARTITION BY job_name, step_name ORDER BY start_time)    AS delta_seg
FROM job_execution_log
WHERE status = 'SUCCESS';
```

Actualizar `provision-mariadb.sh`: agregar vista + actualizar mensaje a `(24 objetos)`.

**Verificación:**

```sql
-- Fecha verificación: 2026-05-27
SELECT job_name, step_name, duracion_seg, duracion_anterior_seg, delta_seg
FROM v_etl_rendimiento ORDER BY start_time DESC LIMIT 5;
-- Primera ejecución de cada step: duracion_anterior_seg = NULL (correcto)
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(vistas): v_etl_rendimiento v1.0.0 — LAG() para regresiones de rendimiento ETL`

---

### T3.2 — `sp_rpt_resumen_abandono_rollup` v1.0.0 — SP ejecutivo con WITH ROLLUP

**Fecha estimada:** 2026-05-27
**Archivos:**
- CREAR: `provisioners/mariadb/objetos/sps/sp_rpt_resumen_abandono_rollup.sql`
- MODIFICAR: `scripts/provision-mariadb.sh`

El SP incluye desde v1.0.0: validación SIGNAL + INSERT a `pipeline_event_log` + ROLLUP.

```sql
CREATE OR REPLACE PROCEDURE sp_rpt_resumen_abandono_rollup(
    IN p_quarter VARCHAR(10)
)
BEGIN
    DECLARE v_total BIGINT DEFAULT 0;

    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO pipeline_event_log
                (error_type, severity, sp_nombre, sql_state, mysql_errno,
                 p_quarter, error_message, ejecutado_por)
            VALUES ('PARAM_INVALIDO', 'MEDIA',
                    'sp_rpt_resumen_abandono_rollup', '22023', 1644,
                    p_quarter, CONCAT('p_quarter invalido: ', p_quarter),
                    'django_api');
        END;
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25 ... Q04_YY';
    END IF;

    SELECT SUM(total_llamadas) INTO v_total
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera');

    SELECT
        p_quarter                                                AS trimestre
        , COALESCE(b.segmento, 'TOTAL')                       AS segmento
        , COALESCE(UPPER(TRIM(b.menu)), '--- SUBTOTAL ---')   AS menu
        , SUM(b.total_llamadas)                                  AS abandonadas
        , ROUND(SUM(b.total_llamadas) / NULLIF(v_total, 0) * 100, 2) AS pct_del_quarter
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.segmento, b.menu WITH ROLLUP;
END;
```

Actualizar `provision-mariadb.sh`: agregar SP + EXECUTE grant + mensaje `(25 objetos)`.

**Verificación:**

```sql
-- Fecha verificación: 2026-05-27
CALL sp_rpt_resumen_abandono_rollup('Q01_25');
-- 13 filas: detalle + subtotales + TOTAL
-- Fila TOTAL: abandonadas=40544, pct_del_quarter=100.00

CALL sp_rpt_resumen_abandono_rollup('INVALIDO');
-- ERROR 1644 (22023) + pipeline_event_log +1 fila
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_resumen_abandono_rollup v1.0.0 — WITH ROLLUP + validacion + log`

---

## FASE 4 — Mejoras opcionales

### T4.1 — `sp_rpt_centros_xsegmento` v2.3.0 — PERCENT_RANK + FIRST_VALUE

**Fecha estimada:** 2026-06-03
**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_centros_xsegmento.sql`

```sql
-- Agregar al SELECT después de ranking:
, ROUND(PERCENT_RANK() OVER (
    PARTITION BY cc.segmento ORDER BY cc.total_llamadas
  ), 4)                                                     AS percentil_actividad
, ROUND(cc.total_llamadas / FIRST_VALUE(cc.total_llamadas) OVER (
    PARTITION BY cc.segmento ORDER BY cc.total_llamadas DESC
  ) * 100, 1)                                               AS pct_del_lider
```

**Verificación:**

```sql
-- Fecha verificación: 2026-06-03
CALL sp_rpt_centros_xsegmento('Q01_25');
-- nacional_A ranking 1: percentil_actividad=1.0000, pct_del_lider=100.0
-- nacional_A ranking 3 (10828091): pct_del_lider=87.4
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_centros_xsegmento v2.3.0 — PERCENT_RANK + FIRST_VALUE`

---

### T4.2 — `sp_rpt_centros_transferencia` v2.2.0 — NTILE(4)

**Fecha estimada:** 2026-06-03
**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_centros_transferencia.sql`

```sql
-- Agregar al SELECT:
, NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) DESC
  )                                                         AS cuartil_centro
```

**Verificación:**

```sql
-- Fecha verificación: 2026-06-03
CALL sp_rpt_centros_transferencia('Q01_25', 'nacional_A');
-- Centro mayor volumen: cuartil_centro=1
-- Con 28 centros: 7 por cuartil
```

```bash
bash verify.sh  # → OK: 28, WARN: 0, ERR: 0
```

**Commit:** `feat(reportes): sp_rpt_centros_transferencia v2.2.0 — NTILE(4)`

---

### T4.3 — Verificación de centros distintos (operacional, sin commit)

**Fecha estimada:** al conectar fuente de producción

```sql
-- Ejecutar con datos reales (fecha real de ejecución):
SELECT segmento,
       COUNT(DISTINCT centro_transferencia) AS centros_distintos
FROM base_ivr_detalle
WHERE trimestre = (SELECT quarter FROM v_quarter_actual)
  AND centro_transferencia NOT IN (
      'CASO_NULL','CASO_ERROR_CEROS',
      'ERROR_CARACTER_INICIAL','CLIENTE_COLGO'
  )
GROUP BY segmento;
```

| Resultado | Acción |
|---|---|
| < 200 centros/segmento | Sin acción |
| 200–500 centros/segmento | Monitorear rendimiento de `sp_rpt_centros_xsegmento` |
| > 500 centros/segmento | Revisar fragmentación en `fn_normalizar_centro` |

---

## Estado final del sistema al completar todas las fases

```
verify.sh:
  OK: 27, WARN: 0, ERR: 0
  (H-T1.1-001: el bloque de tablas emite UN ok() para el grupo — agregar
  pipeline_event_log al bucle expande el criterio, no añade un check nuevo.
  El 6/6 en el mensaje 'Tablas analíticas completas' confirma su presencia.)

provision-mariadb.sh:
  "25 objetos aplicados"

Objetos SQL:
  Funciones:    7  (sin cambios)
  SPs ETL:      5  (sp_etl_maestro v2.5.0, sp_etl_historico v2.1.0)
  SPs Reporte:  8  (7 existentes + sp_rpt_resumen_abandono_rollup v1.0.0)
  Jobs:         1  (sin cambios)
  Vistas:       4  (v_quarter_actual, v_sla_distribucion — existentes;
                     v_etl_rendimiento v1.0.0 — nueva;
                     v_eventos_recientes — en schema_pipeline_event_log.sql)
  Schemas:      2  (schema_base_ivr.sql + schema_pipeline_event_log.sql)
```


---

## Cierre — Estado de implementación al 2026-05-13

**Todas las fases completadas.** El plan fue ejecutado íntegramente en la sesión
del 2026-05-13. No quedaron tareas pendientes ni deuda técnica.

| Fase | Tareas | Estado | Commits principales |
|---|---|---|---|
| FASE 1 — Provision + Infraestructura | T1.1, T1.2, T1.3, T1.4 | COMPLETA | 377b01d, 768a7b2, cecbba9, d45a440 |
| FASE 2 — Window functions | T2.1, T2.2, T2.3, T2.4 | COMPLETA | 8918bba |
| FASE 3 — Observabilidad | T3.1, T3.2 | COMPLETA | f1639d0 |
| FASE 4 — Mejoras opcionales | T4.1, T4.2, T4.3 | COMPLETA | 14ac02e |

**Hallazgos que modificaron la implementación respecto a este plan:**

- H-T1.1-001: verify.sh OK sigue en 27 (no 28). El bloque de tablas emite un
  solo `ok()` para el grupo — el 6/6 confirma `pipeline_event_log`.
- H-T2.4-001: subq2 de `sp_rpt_menu_redirigidos` NO se reemplazó con `OVER()`.
  El denominador difiere en 9,566 filas. Se usó variable `v_total_scope`.
- H-T4.2-001: NTILE con SUM OVER anidado no compila en MariaDB 10.11. Se usó
  LEFT JOIN con subquery agrupada por centro.

**Documentos de hallazgos generados:**

- `HALLAZGOS-FASE1-IMPL-PIPELINE-EVENT-LOG-20260513142619.md`
- `HALLAZGOS-FASE2-IMPL-WINDOW-FUNCTIONS-20260513175024.md`
- `HALLAZGOS-FASE3-IMPL-OBSERVABILIDAD-20260513175744.md`
- `HALLAZGOS-FASE4-IMPL-MEJORAS-OPCIONALES-20260513180611.md`

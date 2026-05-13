# Plan de Implementación — IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Principio:** cada tarea es atómica, desplegable y verificable de forma independiente.
Al cerrar cada tarea verify.sh debe pasar sin errores nuevos.  
**Sin deuda técnica:** ninguna tarea deja código, provision o tests en estado incompleto.

---

## Mapa de fases

```
FASE 1 — Provision + Infraestructura de errores   (3 tareas)
FASE 2 — Window functions en 4 SPs de reporte     (4 tareas)
FASE 3 — Nuevos objetos de observabilidad          (2 tareas)
FASE 4 — Mejoras opcionales + monitoreo            (3 tareas)
```

**Versiones al iniciar el plan:**

| Objeto | Versión inicial | Versión final |
|---|---|---|
| `sp_etl_maestro` | 2.4.0 | 2.5.0 |
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

## FASE 1 — Provision + Infraestructura de errores

### T1.1 — Corregir `provision-mariadb.sh` y `verify.sh`

**Problema:** `schema_error_log.sql`, `v_quarter_actual.sql` y `v_sla_distribucion.sql`
existen en disco pero **no están en el array `sql_files`** de `provision-mariadb.sh`.
En un despliegue limpio `ivr_error_log` no existiría — T1.2 y T1.3 fallarían.

**Archivos a modificar:** `scripts/provision-mariadb.sh`, `verify.sh`

**Cambios en `provision-mariadb.sh`:**

1. Agregar `schema_error_log.sql` después de `schema_base_ivr.sql`:

```bash
"${prov}/schema_base_ivr.sql"
"${prov}/schema_error_log.sql"   # ← agregar
```

2. Agregar sección de vistas después de los SPs de reporte y antes de Jobs:

```bash
# Vistas — alias y consultas operacionales sobre tablas existentes
"${prov}/objetos/vistas/v_quarter_actual.sql"
"${prov}/objetos/vistas/v_sla_distribucion.sql"
```

3. Actualizar mensaje de éxito del paso SQL: de `(20 objetos)` a `(23 objetos)`.

**Cambios en `verify.sh`:** agregar `ivr_error_log` al bucle de tablas y actualizar
el contador:

```bash
# Antes:
for tbl in base_ivr_detalle base_ivr_clientes \
           job_execution_log etl_runs job_config; do

# Después:
for tbl in base_ivr_detalle base_ivr_clientes \
           job_execution_log etl_runs job_config \
           ivr_error_log; do
```

Actualizar el mensaje de `(${tbl_ok}/5)` a `(${tbl_ok}/6)`.

**Verificación:**

```bash
bash scripts/provision-mariadb.sh
# → "23 objetos aplicados"
mysql ivr_legacy -e "SELECT COUNT(*) FROM ivr_error_log;"
# → 0 (tabla existe, vacía)
bash verify.sh
# → OK: 28+, Errores: 0
```

**Commit:** `fix(provision): agregar schema_error_log y vistas a provision-mariadb.sh`

---

### T1.2 — `sp_etl_maestro` v2.5.0 — INSERT a `ivr_error_log` en 3 EXIT HANDLERs

**Prerrequisito:** T1.1  
**Archivo:** `provisioners/mariadb/objetos/sps/sp_etl_maestro.sql`

En cada EXIT HANDLER (PASO 4, 5, 6), agregar un bloque protegido con CONTINUE
HANDLER **antes** de la lógica existente del handler:

```sql
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    INSERT INTO ivr_error_log
        (error_type, severity, sp_nombre, sql_state,
         p_quarter, error_message, job_log_id, ejecutado_por)
    VALUES (<valores por PASO — ver tabla>);
END;
```

| PASO | `error_type` | `severity` | `error_message` | `job_log_id` |
|---|---|---|---|---|
| 4 | `'ETL_FALLO'` | `'CRITICA'` | `CONCAT('Falló etl_base_detalle: ', v_err_msg)` | `v_maestro_id` |
| 5 | `'ETL_FALLO'` | `'CRITICA'` | `CONCAT('Falló etl_base_clientes: ', v_err_msg)` | `v_maestro_id` |
| 6 | `'ETL_PARTIAL'` | `'ALTA'` | `CONCAT('Error en sp_etl_validar: ', v_err_msg)` | `v_maestro_id` |

Los campos comunes en los 3 handlers: `sp_nombre='sp_etl_maestro'`, `sql_state='45000'`,
`p_quarter=v_quarter` (disponible en el scope externo), `ejecutado_por='evt_etl_diario'`.

**Verificación:**

```sql
SELECT COUNT(*) FROM ivr_error_log;  -- baseline N

-- Simular fallo del PASO 4 (requiere tabla fuente ausente o error forzado):
-- Después del fallo: job_execution_log status=FAILED, ivr_error_log +1 fila
SELECT error_type, severity, sp_nombre, p_quarter, LEFT(error_message,60)
FROM ivr_error_log ORDER BY ts DESC LIMIT 1;
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(errores): sp_etl_maestro v2.5.0 — ivr_error_log en EXIT HANDLERs PASO 4/5/6`

---

### T1.3 — 7 SPs de reporte vX.X.2 — INSERT a `ivr_error_log` antes de cada SIGNAL

**Prerrequisito:** T1.1  
**Archivos:** los 7 `sp_rpt_*.sql`

En cada bloque `IF p_quarter NOT REGEXP...`, agregar entre el IF y el SIGNAL:

```sql
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    INSERT INTO ivr_error_log
        (error_type, severity, sp_nombre, sql_state, mysql_errno,
         p_quarter, error_message, ejecutado_por)
    VALUES ('PARAM_INVALIDO', 'MEDIA', '<nombre_sp>', '22023', 1644,
            p_quarter, CONCAT('p_quarter invalido: ', p_quarter), 'django_api');
END;
```

En cada bloque `IF p_segmento NOT IN...` (solo los 5 SPs con este parámetro):

```sql
BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
    INSERT INTO ivr_error_log
        (error_type, severity, sp_nombre, sql_state, mysql_errno,
         p_quarter, p_segmento, error_message, ejecutado_por)
    VALUES ('PARAM_INVALIDO', 'MEDIA', '<nombre_sp>', '22023', 1644,
            p_quarter, p_segmento,
            CONCAT('p_segmento invalido: ', p_segmento), 'django_api');
END;
```

**Versiones resultantes:**

| SP | Versión nueva | Valida seg |
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
SELECT COUNT(*) FROM ivr_error_log;  -- baseline N
CALL sp_rpt_clientes('INVALIDO');     -- ERROR 1644 (22023)
SELECT COUNT(*) FROM ivr_error_log;  -- N+1

CALL sp_rpt_llamadas_abandonadas('Q01_25', 'seg_malo');  -- ERROR 1644 (22023)
SELECT COUNT(*) FROM ivr_error_log;  -- N+2

CALL sp_rpt_clientes('Q01_25');       -- resultado normal, sin log
SELECT COUNT(*) FROM ivr_error_log;  -- sigue N+2
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(errores): 7 SPs reporte vX.X.2 — ivr_error_log antes de cada SIGNAL`

---

## FASE 2 — Window functions en 4 SPs de reporte

**Prerrequisito de la fase completa:** FASE 1 terminada. Los SPs ya tienen la versión
con log de errores sobre la que se aplican los cambios de window functions.

### T2.1 — `sp_rpt_cMENU_ERROR` v2.1.0 — `OVER()` reemplaza subconsulta

**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_cMENU_ERROR.sql`

**CORRECCIÓN** al análisis anterior: la especificación correcta es `OVER()` sin
PARTITION BY, no `OVER(PARTITION BY segmento)`.

Con `p_segmento='todas'`: subq devuelve 119 (grand total).
`OVER(PARTITION BY segmento)` daría 55 (per-segment). `OVER()` da 119. Correcto.

```sql
-- Reemplazar:
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
   AND b2.menu REGEXP '^[0-9]+$'
   AND LENGTH(b2.menu) >= 7
) AS total_anomalias_quarter

-- Por:
SUM(SUM(b.total_llamadas)) OVER () AS total_anomalias_quarter
```

**Verificación:**

```sql
-- Con p_segmento='todas': total_anomalias_quarter debe ser 119 en TODAS las filas
CALL sp_rpt_cMENU_ERROR('Q01_25', 'todas');

-- Con p_segmento='nacional_A': total_anomalias_quarter debe ser 55
CALL sp_rpt_cMENU_ERROR('Q01_25', 'nacional_A');
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(reportes): sp_rpt_cMENU_ERROR v2.1.0 — OVER() reemplaza subq corr. [corr analisis]`

---

### T2.2 — `sp_rpt_menu_centro` v2.1.0 — `OVER(PARTITION BY centro)` reemplaza subconsulta

**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_menu_centro.sql`

```sql
-- Reemplazar el NULLIF(subq, 0) por la window function:
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia),
      0) * 100, 2
) AS pct_del_centro
```

**Verificación:**

```sql
-- Con p_segmento='todas', centro 10228051:
CALL sp_rpt_menu_centro('Q01_25', 'todas');
-- RES-FallasLinea/DEFAULT: pct_del_centro debe ser 87.50 (308/352×100)

-- Con p_segmento='nacional_A', mismo centro:
CALL sp_rpt_menu_centro('Q01_25', 'nacional_A');
-- pct: 154/154 = 100.00 (solo filas de nacional_A visibles)
-- Verificar coherencia: total_nacional_A = 154+33+3+... = suma correcta
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(reportes): sp_rpt_menu_centro v2.1.0 — OVER(PARTITION BY centro) reemplaza subq`

---

### T2.3 — `sp_rpt_clientes` v2.1.0 — `OVER()` reemplaza subconsulta

**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_clientes.sql`

```sql
-- Reemplazar:
ROUND(
    c.clientes_unicos
    / NULLIF(
        (SELECT SUM(c2.clientes_unicos) FROM base_ivr_clientes c2
         WHERE c2.trimestre = p_quarter),
      0) * 100, 2
) AS pct_del_total

-- Por:
ROUND(
    c.clientes_unicos
    / NULLIF(SUM(c.clientes_unicos) OVER (), 0) * 100, 2
) AS pct_del_total
```

**Verificación:**

```sql
CALL sp_rpt_clientes('Q01_25');
-- nacional_A: 37586, pct=45.25
-- nacional_B: 24753, pct=29.80
-- puebla:     20729, pct=24.95
-- Suma de pct = 100.00%
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(reportes): sp_rpt_clientes v2.1.0 — OVER() reemplaza subconsulta`

---

### T2.4 — `sp_rpt_menu_redirigidos` v2.1.0 — 2 window functions reemplazan 2 subconsultas

**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_menu_redirigidos.sql`

**CORRECCIÓN** al análisis anterior: subq1 requiere `OVER(PARTITION BY menu)`,
no `OVER(PARTITION BY segmento, menu)`.

Con `p_segmento='todas'`, `SinOpcion_Cabecera` en 3 segmentos:
subq1=3,942. `OVER(seg,menu)`=1,698. `OVER(menu)`=3,942. Correcto.

**Reemplazo de subq1 (`pct_del_menu`):**

```sql
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.menu),
      0) * 100, 2
) AS pct_del_menu
```

**Reemplazo de subq2 (`pct_del_total`):**

```sql
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        SUM(SUM(b.total_llamadas)) OVER (),
      0) * 100, 4
) AS pct_del_total
```

**Verificación — OBLIGATORIO probar ambos escenarios de `p_segmento`:**

```sql
-- Escenario A — p_segmento='nacional_A':
CALL sp_rpt_menu_redirigidos('Q01_25', 'nacional_A');
-- Para SinOpcion_Cabecera/19020086:
--   pct_del_menu: 1643/1698×100 = 96.76%  (denominador = total del menú en nacional_A)

-- Escenario B — p_segmento='todas':
CALL sp_rpt_menu_redirigidos('Q01_25', 'todas');
-- Para SinOpcion_Cabecera/19020086:
--   pct_del_menu: 1643/3942×100 = 41.68%  (denominador = total del menú en 3 segmentos)
-- Para cliente_colgo/CLIENTE_COLGO/nacional_A:
--   pct_del_menu: 12278/27040×100 = 45.40%
```

El cambio de 96.76% a 41.68% para el escenario 'todas' es correcto — el denominador
más amplio (3 segmentos) reduce el porcentaje, que es la semántica esperada del KPI.

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(reportes): sp_rpt_menu_redirigidos v2.1.0 — OVER(menu)+OVER() [corr analisis]`

---

## FASE 3 — Nuevos objetos de observabilidad

### T3.1 — `v_etl_rendimiento` v1.0.0 — vista con LAG()

**Archivos:**
- CREAR: `provisioners/mariadb/objetos/vistas/v_etl_rendimiento.sql`
- MODIFICAR: `scripts/provision-mariadb.sh`

**Contenido de la vista:**

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

**Cambio en `provision-mariadb.sh`** (sección vistas, después de `v_sla_distribucion.sql`):

```bash
"${prov}/objetos/vistas/v_etl_rendimiento.sql"
```

Actualizar mensaje de éxito: `(23 objetos)` → `(24 objetos)`.

**Verificación:**

```sql
SELECT job_name, step_name, duracion_seg, duracion_anterior_seg, delta_seg
FROM v_etl_rendimiento ORDER BY start_time DESC LIMIT 5;
-- Primera ejecución de cada step: duracion_anterior_seg = NULL
-- Ejecuciones posteriores: valor numérico en duracion_anterior_seg
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(vistas): v_etl_rendimiento v1.0.0 — LAG() para regresiones de rendimiento ETL`

---

### T3.2 — `sp_rpt_resumen_abandono_rollup` v1.0.0 — SP ejecutivo con WITH ROLLUP

**Archivos:**
- CREAR: `provisioners/mariadb/objetos/sps/sp_rpt_resumen_abandono_rollup.sql`
- MODIFICAR: `scripts/provision-mariadb.sh`

El SP incluye desde v1.0.0: validación SIGNAL + INSERT a `ivr_error_log` + ROLLUP.

**Contenido del SP:**

```sql
CREATE OR REPLACE PROCEDURE sp_rpt_resumen_abandono_rollup(
    IN p_quarter VARCHAR(10)
)
BEGIN
    DECLARE v_total BIGINT DEFAULT 0;

    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
        BEGIN
            DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
            INSERT INTO ivr_error_log
                (error_type, severity, sp_nombre, sql_state, mysql_errno,
                 p_quarter, error_message, ejecutado_por)
            VALUES ('PARAM_INVALIDO', 'MEDIA',
                    'sp_rpt_resumen_abandono_rollup', '22023', 1644,
                    p_quarter,
                    CONCAT('p_quarter invalido: ', p_quarter),
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
        , COALESCE(b.segmento, 'TOTAL')                         AS segmento
        , COALESCE(UPPER(TRIM(b.menu)), '--- SUBTOTAL ---')     AS menu
        , SUM(b.total_llamadas)                                  AS abandonadas
        , ROUND(
            SUM(b.total_llamadas) / NULLIF(v_total, 0) * 100, 2
          )                                                       AS pct_del_quarter
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.segmento, b.menu WITH ROLLUP;
END;
```

**Cambios en `provision-mariadb.sh`:**

1. Agregar en la sección de SPs de reporte:
```bash
"${prov}/objetos/sps/sp_rpt_resumen_abandono_rollup.sql"
```

2. Agregar en la lista de EXECUTE grants:
```sql
'sp_rpt_resumen_abandono_rollup',
```

3. Actualizar mensaje: `(24 objetos)` → `(25 objetos)`.

**Verificación:**

```sql
CALL sp_rpt_resumen_abandono_rollup('Q01_25');
-- 13 filas: 3 detalle×3seg + 3 subtotales + 1 TOTAL
-- Fila TOTAL: abandonadas=40544, pct_del_quarter=100.00

CALL sp_rpt_resumen_abandono_rollup('INVALIDO');
-- ERROR 1644 (22023) + ivr_error_log +1 fila

-- Grant ejecutado por provision:
SELECT COUNT(*) FROM information_schema.TABLE_PRIVILEGES
WHERE GRANTEE LIKE "'django_user'%"
  AND TABLE_NAME = 'sp_rpt_resumen_abandono_rollup';
-- O verificar via SHOW GRANTS FOR 'django_user'@'localhost';
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
# sp_rpt_count incluye el nuevo SP (LIKE 'sp_rpt%')
```

**Commit:** `feat(reportes): sp_rpt_resumen_abandono_rollup v1.0.0 — WITH ROLLUP + validacion + log`

---

## FASE 4 — Mejoras opcionales

### T4.1 — `sp_rpt_centros_xsegmento` v2.3.0 — PERCENT_RANK + FIRST_VALUE

**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_centros_xsegmento.sql`

Agregar dos columnas al SELECT final, después de la columna `ranking` existente:

```sql
-- Percentil de actividad: 0.0 = menos activo, 1.0 = más activo del segmento
, ROUND(PERCENT_RANK() OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas        -- ASC: mayor volumen → percentil 1.0
  ), 4)                               AS percentil_actividad

-- Porcentaje del líder del segmento
, ROUND(
    cc.total_llamadas
    / FIRST_VALUE(cc.total_llamadas) OVER (
        PARTITION BY cc.segmento
        ORDER BY cc.total_llamadas DESC
      ) * 100, 1
  )                                   AS pct_del_lider
```

**Verificación:**

```sql
CALL sp_rpt_centros_xsegmento('Q01_25');
-- nacional_A, ranking 1 (10728487): percentil_actividad=1.0000, pct_del_lider=100.0
-- nacional_A, ranking 3 (10828091): pct_del_lider=87.4 (4803/5493×100)
-- nacional_A, último ranking: percentil_actividad=0.0000
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(reportes): sp_rpt_centros_xsegmento v2.3.0 — PERCENT_RANK + FIRST_VALUE`

---

### T4.2 — `sp_rpt_centros_transferencia` v2.2.0 — NTILE(4)

**Archivo:** `provisioners/mariadb/objetos/sps/sp_rpt_centros_transferencia.sql`

Agregar columna al SELECT:

```sql
, NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) DESC
  )                                    AS cuartil_centro
```

**Verificación:**

```sql
CALL sp_rpt_centros_transferencia('Q01_25', 'nacional_A');
-- Centro 10728487 (mayor volumen): cuartil_centro = 1
-- Centro en posición ceil(28/4)+1 (posición 8): cuartil_centro = 2
-- 28 centros = 7 por cuartil
```

```bash
bash verify.sh  # → OK: 28+, Errores: 0
```

**Commit:** `feat(reportes): sp_rpt_centros_transferencia v2.2.0 — NTILE(4) cuartil de actividad`

---

### T4.3 — Verificación de centros distintos (no es código)

No genera commit. Ejecutar con datos reales al conectar la fuente de producción:

```sql
SELECT segmento,
       COUNT(DISTINCT centro_transferencia) AS centros_distintos
FROM base_ivr_detalle
WHERE trimestre = (SELECT quarter FROM v_quarter_actual)
  AND centro_transferencia NOT IN (
      'CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO'
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
  OK: 28, WARN: 0, ERR: 0  (tabla ivr_error_log agregada al check /6)

provision-mariadb.sh:
  "25 objetos aplicados"

Objetos SQL en provisioners/mariadb/objetos/:
  Funciones:  7  (sin cambios desde FASE 4 anterior)
  SPs ETL:    5  (sp_etl_maestro v2.5.0)
  SPs Reporte: 8  (7 existentes + sp_rpt_resumen_abandono_rollup v1.0.0)
  Jobs:        1  (sin cambios)
  Vistas:      4  (v_quarter_actual, v_sla_distribucion — ya existentes;
                    v_etl_rendimiento v1.0.0;
                    v_errores_recientes — ya existente, en schema_error_log.sql)
  Schemas:     2  (schema_base_ivr.sql + schema_error_log.sql)
```

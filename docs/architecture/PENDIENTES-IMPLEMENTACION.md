# Pendientes de Implementación — IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Baseline:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Fuentes:** análisis de Módulos 11-17 + diseño ivr_error_log + referencia SP_RELACIONAR_PAGOS

---

## Estado de implementación por módulo

| Módulo / Área | Implementado | Pendiente |
|---|---|---|
| Módulo 11 — Subconsultas | Completo (FASE 1-4) | — |
| Módulo 12 — EXCEPT / INTERSECT | Completo (`sp_etl_validar` v2.2.0) | — |
| Módulo 13 — DENSE_RANK | Completo (`sp_rpt_centros_xsegmento` v2.2.1) | PERCENT_RANK, FIRST_VALUE (opcional) |
| Módulo 14 — WITH ROLLUP / PIVOT | ROLLUP en SP existente + `v_sla_distribucion` | SP de resumen ejecutivo |
| Módulo 15 — CREATE OR REPLACE | Completo (20 objetos migrados) | — |
| Módulo 16 — Programación | LEAVE + tabla derivada + `v_quarter_actual` | — |
| Módulo 17 — Manejo de errores | SIGNAL en 7 SPs + EXIT HANDLER en 2 SPs | Conexión con `ivr_error_log` |
| ivr_error_log | Tabla + vista creadas | Alimentar desde SPs existentes |
| Window functions (4 SPs) | — | 4 SPs con subconsultas correlacionadas |
| Vista ETL rendimiento | — | `v_etl_rendimiento` con LAG() |

---

## P1 — Conectar `ivr_error_log` con los EXIT HANDLERs de `sp_etl_maestro`

**Prioridad:** ALTA  
**Objeto:** `sp_etl_maestro` v2.4.0 → v2.5.0  
**Fuente:** `ANALISIS-DISENO-IVR-ERROR-LOG.md`, `ANALISIS-SP-RELACIONAR-PAGOS-REFERENCIA.md`

### Situación actual

La tabla `ivr_error_log` existe pero ningún SP le inserta datos automáticamente.
Los EXIT HANDLERs de los PASO 4, 5 y 6 de `sp_etl_maestro` actualizan
`job_execution_log` cuando falla el ETL, pero el error no queda en el log de auditoría.

### Qué implementar

En cada uno de los 3 EXIT HANDLERs de `sp_etl_maestro`, agregar un INSERT a
`ivr_error_log` ANTES del UPDATE a `job_execution_log`. El INSERT debe ir protegido
con `DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END` para que un fallo del log
no enmascare el error original — patrón verificado en motor real.

**Patrón para PASO 4 (idéntico para PASO 5 y 6 ajustando `sp_nombre` y `error_message`):**

```sql
DECLARE EXIT HANDLER FOR SQLEXCEPTION
BEGIN
    GET DIAGNOSTICS CONDITION 1 v_err_msg = MESSAGE_TEXT;

    -- Insertar en ivr_error_log protegiendo el INSERT con CONTINUE HANDLER
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log
            (error_type, severity, sp_nombre, sql_state,
             p_quarter, error_message, job_log_id, ejecutado_por)
        VALUES
            ('ETL_FALLO', 'CRITICA', 'sp_etl_maestro', '45000',
             v_quarter, CONCAT('Falló etl_base_detalle: ', v_err_msg),
             v_maestro_id, 'evt_etl_diario');
    END;

    -- Lógica existente del handler (sin cambios)
    UPDATE job_execution_log
    SET status='FAILED', end_time=NOW(), error_message=v_err_msg
    WHERE id = v_step_id;
    UPDATE job_execution_log
    SET status='FAILED', end_time=NOW(),
        error_message=CONCAT('Falló etl_base_detalle: ', v_err_msg)
    WHERE id = v_maestro_id;
    SET v_detalle_cargado = FALSE;
END;
```

**Variaciones por PASO:**

| PASO | `error_type` | `error_message` | `job_log_id` |
|---|---|---|---|
| PASO 4 | `'ETL_FALLO'` | `CONCAT('Falló etl_base_detalle: ', v_err_msg)` | `v_maestro_id` |
| PASO 5 | `'ETL_FALLO'` | `CONCAT('Falló etl_base_clientes: ', v_err_msg)` | `v_maestro_id` |
| PASO 6 | `'ETL_PARTIAL'` | `CONCAT('Error en sp_etl_validar: ', v_err_msg)` | `v_maestro_id` |

El campo `job_log_id` vincula el error al registro maestro del job — permite consultar
desde `v_errores_recientes` el estado completo del pipeline que falló.

---

## P2 — Conectar `ivr_error_log` con los SIGNAL de los 7 SPs de reporte

**Prioridad:** ALTA  
**Objetos:** 7 SPs de reporte (todos en versión x.x.1 post-Módulo 17)  
**Fuente:** `ANALISIS-DISENO-IVR-ERROR-LOG.md`, `ANALISIS-SP-RELACIONAR-PAGOS-REFERENCIA.md`

### Situación actual

Los 7 SPs ya validan `p_quarter` y `p_segmento` con `SIGNAL SQLSTATE '22023'`.
Cuando Django llama con parámetros inválidos, el error llega correctamente al cliente,
pero desaparece — no queda registro de cuántas veces ocurrió, desde qué endpoint,
ni con qué parámetro exacto.

### Qué implementar

Antes de cada `SIGNAL`, insertar en `ivr_error_log` con un `CONTINUE HANDLER` de
protección. El `SIGNAL` se lanza igual — el registro es adicional.

**Patrón para validación de `p_quarter` (aplicar en los 7 SPs):**

```sql
IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, error_message, ejecutado_por)
        VALUES
            ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_xxx', '22023', 1644,
             p_quarter,
             CONCAT('p_quarter invalido: ', p_quarter),
             'django_api');
    END;
    SIGNAL SQLSTATE '22023'
        SET MESSAGE_TEXT = 'p_quarter: formato invalido. Esperado: Q01_25 ... Q04_YY';
END IF;
```

**Patrón para validación de `p_segmento` (solo los 5 SPs que lo tienen):**

```sql
IF p_segmento NOT IN ('todas', 'nacional_A', 'nacional_B', 'puebla') THEN
    BEGIN
        DECLARE CONTINUE HANDLER FOR SQLEXCEPTION BEGIN END;
        INSERT INTO ivr_error_log
            (error_type, severity, sp_nombre, sql_state, mysql_errno,
             p_quarter, p_segmento, error_message, ejecutado_por)
        VALUES
            ('PARAM_INVALIDO', 'MEDIA', 'sp_rpt_xxx', '22023', 1644,
             p_quarter, p_segmento,
             CONCAT('p_segmento invalido: ', p_segmento),
             'django_api');
    END;
    SIGNAL SQLSTATE '22023'
        SET MESSAGE_TEXT = 'p_segmento: valor no reconocido...';
END IF;
```

**SPs afectados y campo `sp_nombre` a usar:**

| SP | Valida quarter | Valida segmento | sp_nombre en log |
|---|---|---|---|
| `sp_rpt_cMENU_ERROR` | Sí | Sí | `'sp_rpt_cMENU_ERROR'` |
| `sp_rpt_centros_transferencia` | Sí | Sí | `'sp_rpt_centros_transferencia'` |
| `sp_rpt_centros_xsegmento` | Sí | No | `'sp_rpt_centros_xsegmento'` |
| `sp_rpt_clientes` | Sí | No | `'sp_rpt_clientes'` |
| `sp_rpt_llamadas_abandonadas` | Sí | Sí | `'sp_rpt_llamadas_abandonadas'` |
| `sp_rpt_menu_centro` | Sí | Sí | `'sp_rpt_menu_centro'` |
| `sp_rpt_menu_redirigidos` | Sí | Sí | `'sp_rpt_menu_redirigidos'` |

---

## P3 — Window aggregate en `sp_rpt_cMENU_ERROR`

**Prioridad:** MEDIA  
**Objeto:** `sp_rpt_cMENU_ERROR` v2.0.1 → v2.1.0  
**Fuente:** `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` D-1

### Situación actual

```sql
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
   AND b2.menu REGEXP '^[0-9]+$'
   AND LENGTH(b2.menu) >= 7
) AS total_anomalias_quarter
```

La subconsulta aplica los mismos filtros `REGEXP` y `LENGTH` que la consulta exterior.
Su resultado es el mismo escalar para cada fila del `GROUP BY` — se calcula N veces
cuando podría calcularse una sola vez.

### Reemplazo verificado

```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento) AS total_anomalias_quarter
```

**Verificación Q01_25:** `total_subq = total_window = 55` en todos los registros.

**Beneficio en producción:** con 50-200 filas de resultado estimadas,
el segundo scan de `base_ivr_detalle` se ejecutaba 50-200 veces por llamada al SP.
Con la window function: un solo paso.

---

## P4 — Window aggregate en `sp_rpt_menu_centro`

**Prioridad:** MEDIA  
**Objeto:** `sp_rpt_menu_centro` v2.0.1 → v2.1.0  
**Fuente:** `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` D-2

### Situación actual

```sql
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND b2.centro_transferencia = b.centro_transferencia
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)) AS total_centro
```

Subconsulta correlacionada: una ejecución por fila del `GROUP BY`. En producción
el SP puede tener 500-2,000 filas de resultado — el segundo scan ejecuta
centenares de veces.

### Reemplazo verificado

```sql
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia) AS total_centro
```

**Verificación Q01_25:** `pct_subq = pct_window = 45.55` para CLIENTE_COLGO.
Idéntico en todos los centros verificados.

**Nota:** el `NOT IN ('CASO_NULL', ...)` en el WHERE exterior filtra los centinela
antes de que la window function los vea. La partición opera solo sobre centros
válidos — equivalencia semántica correcta.

---

## P5 — Window aggregate en `sp_rpt_clientes`

**Prioridad:** BAJA  
**Objeto:** `sp_rpt_clientes` v2.0.1 → v2.1.0  
**Fuente:** `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` D-3

### Situación actual

```sql
(SELECT SUM(c2.clientes_unicos) FROM base_ivr_clientes c2
 WHERE c2.trimestre = p_quarter) AS total_quarter
```

El SP devuelve 3 filas fijas. El impacto de rendimiento es imperceptible.
El cambio es por uniformidad de estilo con los otros SPs del grupo.

### Reemplazo verificado

```sql
SUM(c.clientes_unicos) OVER () AS total_quarter
```

**Verificación Q01_25:** `total_subq = total_window = 83,068`.

---

## P6 — Window aggregates en `sp_rpt_menu_redirigidos`

**Prioridad:** MEDIA  
**Objeto:** `sp_rpt_menu_redirigidos` v2.0.1 → v2.1.0  
**Fuente:** `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` D-4

### Situación actual — 2 subconsultas

**Subconsulta 1 — `pct_del_menu`:**
```sql
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND b2.menu = b.menu
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)) AS total_menu
```

**Subconsulta 2 — `pct_del_total`:**
```sql
(SELECT SUM(b3.total_llamadas)
 FROM base_ivr_detalle b3
 WHERE b3.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b3.segmento = p_segmento)) AS total_scope
```

### Reemplazos verificados

```sql
-- Subq1: total por menú dentro del scope (segmento o todos)
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento, b.menu) AS total_menu

-- Subq2: total del scope completo — CRÍTICO: sin PARTITION BY
SUM(SUM(b.total_llamadas)) OVER () AS total_scope
```

**Restricción crítica de subq2:** `OVER ()` sin `PARTITION BY` es la única opción
correcta. `OVER (PARTITION BY segmento)` sería incorrecto cuando `p_segmento='todas'`
porque cambiaría la semántica del KPI (daría total por segmento, no total global).

**Verificación Q01_25 — ambos escenarios:**

```
p_segmento='nacional_A':
  pct_total_subq = pct_total_over_all = 22.79%  ✓

p_segmento='todas':
  pct_total_subq = pct_total_over_all = 10.30%  ✓  (grand total)
  pct_total_over_seg = 22.79%  ✗  (semántica distinta — NO usar)
```

---

## P7 — Vista `v_etl_rendimiento` con `LAG()`

**Prioridad:** MEDIA  
**Objeto:** nueva vista  
**Fuente:** `RECOMENDACIONES-POST-MODULOS-11-12-13.md` R3

### Qué implementar

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

### Valor operacional

El ETL completo tarda ~9 minutos en producción. Si un día tarda 18 minutos
(`delta_seg = 540`), la vista expone la regresión sin necesidad de comparar
manualmente timestamps. Django puede consultar esta vista en el endpoint de
estado del ETL para mostrar tendencias de rendimiento.

```sql
-- Consulta operacional:
SELECT job_name, step_name, duracion_seg, duracion_anterior_seg, delta_seg
FROM v_etl_rendimiento
WHERE step_name = 'etl_base_detalle'
ORDER BY start_time DESC LIMIT 5;
```

---

## P8 — SP `sp_rpt_resumen_abandono_rollup`

**Prioridad:** MEDIA  
**Objeto:** nuevo SP  
**Fuente:** `ANALISIS-MODULO14-PIVOT-GROUPING-SETS.md`

### Problema que resuelve

`sp_rpt_llamadas_abandonadas` devuelve solo el nivel de detalle (segmento × menú).
Para construir un dashboard de resumen ejecutivo, Django necesita hacer 3 llamadas
separadas para obtener detalle, subtotales por segmento y grand total.

Un SP con `WITH ROLLUP` entrega la jerarquía completa en una sola llamada.

### Qué implementar

```sql
CREATE OR REPLACE PROCEDURE sp_rpt_resumen_abandono_rollup(
    IN p_quarter  VARCHAR(10)
)
BEGIN
    IF p_quarter NOT REGEXP '^Q0[1-4]_[0-9]{2}$' THEN
        SIGNAL SQLSTATE '22023'
            SET MESSAGE_TEXT = 'p_quarter: formato invalido';
    END IF;

    SELECT
        p_quarter                                            AS trimestre
        , COALESCE(b.segmento, 'TOTAL')                     AS segmento
        , COALESCE(UPPER(TRIM(b.menu)), '--- SUBTOTAL ---')  AS menu
        , SUM(b.total_llamadas)                              AS abandonadas
        , ROUND(SUM(b.total_llamadas)
            / NULLIF((SELECT SUM(total_llamadas)
                      FROM base_ivr_detalle
                      WHERE trimestre = p_quarter), 0) * 100, 2) AS pct_del_quarter
    FROM base_ivr_detalle b
    WHERE b.trimestre = p_quarter
      AND b.menu IN ('VACIO', 'cliente_colgo', 'SinOpcion_Cabecera')
    GROUP BY b.segmento, b.menu WITH ROLLUP;
END;
```

**Resultado esperado** (una sola llamada cubre los 3 niveles):
```
trimestre  segmento    menu               abandonadas  pct_del_quarter
Q01_25     nacional_A  CLIENTE_COLGO         12,278        10.30%
Q01_25     nacional_A  SINOPCION_CABECERA     1,698         1.42%
Q01_25     nacional_A  VACIO                  4,410         3.70%
Q01_25     nacional_A  --- SUBTOTAL ---       18,386        15.42%   ← subtotal segmento
Q01_25     nacional_B  ...
Q01_25     TOTAL       --- SUBTOTAL ---       40,544        34.01%   ← grand total
```

---

## P9 — Columnas opcionales en `sp_rpt_centros_xsegmento`

**Prioridad:** BAJA  
**Objeto:** `sp_rpt_centros_xsegmento` v2.2.1 → v2.3.0  
**Fuente:** `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` Grupo E

### Qué agregar (nuevas columnas al SELECT existente)

```sql
-- Percentil de actividad: 0.0=menos activo, 1.0=más activo del segmento
, ROUND(PERCENT_RANK() OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas
  ), 4) AS percentil_actividad

-- Porcentaje del líder del segmento
, ROUND(cc.total_llamadas
    / FIRST_VALUE(cc.total_llamadas) OVER (
        PARTITION BY cc.segmento
        ORDER BY cc.total_llamadas DESC
      ) * 100, 1) AS pct_del_lider
```

**Ejemplo de resultado con datos reales Q01_25:**

```
segmento    centro      total  rango  percentil_actividad  pct_del_lider
nacional_A  10728487   89,621    1           1.0000           100.0%
nacional_A  10828091   78,329    2           0.9643            87.4%
nacional_A  10728527    1,000   28           0.0357             1.1%
```

---

## P10 — Columna opcional en `sp_rpt_centros_transferencia`

**Prioridad:** BAJA  
**Objeto:** `sp_rpt_centros_transferencia` v2.1.1 → v2.2.0  
**Fuente:** `ANALISIS-CANDIDATOS-WINDOW-FUNCTIONS-POR-OBJETO.md` Grupo E

### Qué agregar

```sql
-- Cuartil de actividad del centro en el resultado filtrado
, NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) DESC
  ) AS cuartil_centro
-- Q1=más activo, Q4=menos activo
```

Permite al operador identificar en qué cuartil cae un centro sin calcular
umbrales manuales por quarter.

---

## P11 — Monitoreo de centros distintos con datos reales

**Prioridad:** BAJA — informacional, no es un cambio de código  
**Fuente:** `RECOMENDACIONES-POST-MODULOS-11-12-13.md` R7

Cuando se conecte la fuente de datos de producción, ejecutar:

```sql
SELECT segmento, COUNT(DISTINCT centro_transferencia) AS centros_distintos
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND centro_transferencia NOT IN (
      'CASO_NULL', 'CASO_ERROR_CEROS',
      'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO'
  )
GROUP BY segmento;
```

**Interpretación:**

| Resultado | Acción |
|---|---|
| < 200 centros/segmento | Sin acción — el SP es viable |
| 200-500 centros/segmento | Monitorear rendimiento del SP |
| > 500 centros/segmento | Revisar si hay VDNs fragmentados por normalización insuficiente |

Con la fórmula O(1) de FASE 4 el SP es viable hasta ~1,000 centros.

---

## Decisiones de NO implementar

Documentadas aquí para evitar que se reabran sin justificación nueva.

| Objeto | Propuesta rechazada | Motivo |
|---|---|---|
| `sp_rpt_llamadas_abandonadas` | Reemplazar subq `pct_del_segmento` por window function | Cambiaría el denominador: `18,386 / 53,879 = 34.12%` → `18,386 / 18,386 = 100%`. Sin valor analítico. |
| `sp_rpt_clientes` | No refactorizar (P5 es baja prioridad) | 3 filas fijas. Impacto imperceptible. Solo uniformidad de estilo. |
| `sp_rpt_menu_redirigidos` subq2 | `OVER (PARTITION BY segmento)` | Incorrecto cuando `p_segmento='todas'`. Usar `OVER ()` sin PARTITION BY. |
| `ivr_error_log` en 3NF | Tablas satélite `error_type_catalog`, `sp_catalog` | INSERT desde EXIT HANDLER no puede hacer SELECTs previos. Fila debe ser autónoma. |
| `CREATE SYNONYM` | No disponible en MariaDB | Usar VIEWs donde aplique. Sin gap funcional en IACT-db. |
| `GROUPING SETS` / `CUBE` | No disponible en MariaDB | Sin gap funcional para IACT-db. Emular con UNION ALL si se necesita. |

---

## Orden de implementación sugerido

```
SPRINT 1 — Completar la infraestructura de errores
  P1 — Conectar ivr_error_log con EXIT HANDLERs de sp_etl_maestro
  P2 — Conectar ivr_error_log con SIGNAL de los 7 SPs de reporte

  Razón: la tabla ya existe, el patrón está verificado, la ventana de implementación
  es pequeña (modificar handlers existentes). Completar P1 y P2 hace que ivr_error_log
  empiece a acumular datos reales desde el primer ETL de producción.

SPRINT 2 — Window functions en SPs de reporte
  P6 — sp_rpt_menu_redirigidos (2 subconsultas — la de mayor impacto)
  P4 — sp_rpt_menu_centro (500-2,000 filas estimadas en producción)
  P3 — sp_rpt_cMENU_ERROR
  P5 — sp_rpt_clientes (baja prioridad — 3 filas)

  Razón: los SPs de mayor volumen primero. sp_rpt_menu_redirigidos tiene
  la complejidad más alta (2 subconsultas con denominadores distintos) y requiere
  la mayor atención al detalle (subq2 = OVER () sin PARTITION BY).

SPRINT 3 — Observabilidad y nuevos objetos
  P7 — v_etl_rendimiento con LAG()
  P8 — sp_rpt_resumen_abandono_rollup

  Razón: herramientas de monitoreo y nuevas capacidades analíticas. No bloquean
  nada existente.

SPRINT 4 — Mejoras opcionales (cuando haya tiempo / datos reales)
  P9  — PERCENT_RANK + FIRST_VALUE en sp_rpt_centros_xsegmento
  P10 — NTILE(4) en sp_rpt_centros_transferencia
  P11 — Query de monitoreo de centros (ejecutar con datos reales)
```

---

## Cuadro resumen de pendientes

| ID | Objeto afectado | Tipo | Prioridad | Versión actual → nueva | Fuente |
|---|---|---|---|---|---|
| P1 | `sp_etl_maestro` | Modificar | ALTA | 2.4.0 → 2.5.0 | ANALISIS-DISENO-IVR-ERROR-LOG |
| P2 | 7 SPs de reporte | Modificar | ALTA | x.x.1 → x.x.2 | ANALISIS-DISENO-IVR-ERROR-LOG |
| P3 | `sp_rpt_cMENU_ERROR` | Modificar | MEDIA | 2.0.1 → 2.1.0 | ANALISIS-CANDIDATOS-WF |
| P4 | `sp_rpt_menu_centro` | Modificar | MEDIA | 2.0.1 → 2.1.0 | ANALISIS-CANDIDATOS-WF |
| P5 | `sp_rpt_clientes` | Modificar | BAJA | 2.0.1 → 2.1.0 | ANALISIS-CANDIDATOS-WF |
| P6 | `sp_rpt_menu_redirigidos` | Modificar | MEDIA | 2.0.1 → 2.1.0 | ANALISIS-CANDIDATOS-WF |
| P7 | `v_etl_rendimiento` | Crear | MEDIA | — → 1.0.0 | RECOMENDACIONES-11-12-13 |
| P8 | `sp_rpt_resumen_abandono_rollup` | Crear | MEDIA | — → 1.0.0 | ANALISIS-MODULO14 |
| P9 | `sp_rpt_centros_xsegmento` | Modificar | BAJA | 2.2.1 → 2.3.0 | ANALISIS-CANDIDATOS-WF |
| P10 | `sp_rpt_centros_transferencia` | Modificar | BAJA | 2.1.1 → 2.2.0 | ANALISIS-CANDIDATOS-WF |
| P11 | Query monitoreo | Ejecutar | BAJA | — | RECOMENDACIONES-11-12-13 |

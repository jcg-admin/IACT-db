# Recomendaciones — IACT-db post-análisis Módulos 11, 12 y 13

**Versión:** 1.0.0  
**Fecha:** 2026-05-13

---

## Estado del sistema antes de este documento

Las 4 fases del plan resolvieron todos los hallazgos del análisis comparativo SQL
Server vs IACT-db. El análisis de los tres módulos produjo implementaciones
adicionales y documentó las decisiones explícitas de no actuar. Este documento
sintetiza qué queda pendiente, qué se decidió no tocar y por qué, y qué vigilar
cuando lleguen los datos reales de producción.

**Deuda técnica de código:** ninguna.

---

## Lo que está completo y no requiere acción

| Componente | Versión | Lo que resuelve |
|---|---|---|
| `ivr_contar_dias_semana` | 3.0.0 | O(1) sin WHILE ni dependencia de `ivr_es_dia_semana` |
| `ivr_agregar_dias_semana` | 3.0.0 | O(1) sin WHILE ni dependencia de `ivr_es_dia_semana` |
| `sp_etl_base_detalle` | 2.2.0 | PREPARE fuera del WHILE + TX por mes con ROLLBACK+RESIGNAL |
| `sp_etl_maestro` | 2.2.0 | Guard `v_detalle_cargado` en PASO 5 y PASO 7 |
| `sp_etl_validar` | 2.1.0 | Check 4 (EXCEPT) + Check 5 (INTERSECT) de integridad de segmentos |
| `sp_rpt_centros_xsegmento` | 2.2.0 | 3 CTEs + DENSE_RANK por volumen dentro de cada segmento |
| `sp_rpt_centros_transferencia` | 2.1.0 | LEFT JOIN con tabla derivada pre-agregada |

---

## Recomendación 1 — Refactorizar `sp_rpt_cMENU_ERROR` y `sp_rpt_menu_centro`

**Tipo:** mejora de estilo con beneficio de rendimiento menor  
**Prioridad:** media  
**Riesgo:** bajo — equivalencia verificada en motor real

### Qué hacer

Reemplazar las subconsultas correlacionadas de estos dos SPs por el patrón
`SUM(SUM(col)) OVER (PARTITION BY ...)`. La equivalencia semántica está demostrada:

```sql
-- sp_rpt_cMENU_ERROR: reemplazar
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento)
   AND b2.menu REGEXP '^[0-9]+$'
   AND LENGTH(b2.menu) >= 7
) AS total_anomalias_quarter

-- por:
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento) AS total_anomalias_quarter
```

```sql
-- sp_rpt_menu_centro: reemplazar
(SELECT SUM(b2.total_llamadas)
 FROM base_ivr_detalle b2
 WHERE b2.trimestre = p_quarter
   AND b2.centro_transferencia = b.centro_transferencia
   AND (p_segmento = 'todas' OR b2.segmento = p_segmento))

-- por:
SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.centro_transferencia)
```

### Por qué vale la pena

En producción, `sp_rpt_menu_centro` puede tener 500-2,000 filas de resultado.
Con la subconsulta correlacionada, MariaDB ejecuta un subquery adicional por
cada fila del GROUP BY. Con la window function, el total por centro se calcula
en un solo paso sobre el resultado ya agrupado. No hay segundo scan.

`sp_rpt_cMENU_ERROR` tiene menos filas pero la misma mejora estructural.
Ambos quedan con el mismo patrón que `sp_rpt_centros_xsegmento` (FASE 2),
lo que hace el código más uniforme y predecible para futuros desarrolladores.

---

## Recomendación 2 — No tocar `sp_rpt_llamadas_abandonadas`

**Tipo:** decisión explícita de no actuar  
**Prioridad:** ninguna — el SP está correcto  

### Por qué no se cambia

La subconsulta correlacionada de `pct_del_segmento` no es un error de diseño
— es el denominador correcto para el KPI de tasa de abandono:

```
Denominador correcto: TODAS las llamadas del segmento (incluidas las no abandonadas)
Denominador incorrecto: solo las llamadas abandonadas (daría siempre 100%)
```

Verificado en producción con Q01_25:

```
nacional_A:
  Llamadas abandonadas (numerador):     18,386
  Todas las llamadas del segmento:      53,879   ← lo que usa la subconsulta
  Tasa de abandono real:                34.12%

  Si se reemplazara por window function:
  Denominador disponible:               18,386   ← solo las visibles tras WHERE
  Resultado:                           100.00%   ← sin valor analítico
```

Cualquier intento de "uniformar" este SP con una window function destruiría el
KPI. Si en el futuro alguien propone el cambio, la documentación
`ANALISIS-PATRON-SUM-OVER-WINDOW.md` lo explica y previene el error.

Si se quisiera eliminar la subconsulta preservando la semántica, la única
alternativa válida sería un CTE previo que pre-agregue el total del segmento
sin filtro de menú abandonado — exactamente el patrón de FASE 2. Pero dado
que el SP ya es correcto y tiene 9 filas de resultado, el cambio no está
justificado por rendimiento.

---

## Recomendación 3 — Agregar vista de monitoreo del ETL con `LAG()`

**Tipo:** herramienta operacional nueva  
**Prioridad:** media  
**Riesgo:** ninguno — es una vista de solo lectura

### Qué hacer

Crear una vista sobre `job_execution_log` que compare cada ejecución del ETL
con la anterior usando `LAG()`:

```sql
CREATE OR REPLACE VIEW v_etl_rendimiento AS
SELECT
    job_name
    , quarter_name
    , step_name
    , status
    , start_time
    , TIMESTAMPDIFF(SECOND, start_time, end_time)                      AS duracion_seg
    , LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
        OVER (PARTITION BY job_name, step_name ORDER BY start_time)    AS duracion_anterior_seg
    , TIMESTAMPDIFF(SECOND, start_time, end_time)
      - LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
          OVER (PARTITION BY job_name, step_name ORDER BY start_time)  AS delta_seg
FROM job_execution_log
WHERE status = 'SUCCESS';
```

### Por qué vale la pena en producción

A escala real, el ETL procesa 11.6M filas y tarda ~9 minutos. Si en un día
concreto tarda 18 minutos (`delta_seg = 540`), hay una señal de alerta sin
necesidad de comparar manualmente los timestamps. Django puede consultar esta
vista en el endpoint de estado del ETL para exponer tendencias de rendimiento.

---

## Recomendación 4 — No refactorizar `sp_rpt_clientes`

**Tipo:** decisión explícita de no actuar  
**Prioridad:** ninguna  

El SP devuelve 3 filas — una por segmento. La subconsulta correlacionada que
calcula `pct_del_total` ejecuta sobre una tabla de 3 filas. El costo es
literalmente 3 operaciones. Refactorizarlo con una window function (`OVER ()`)
eliminaría la subconsulta pero el beneficio es imperceptible. El SP es correcto,
es simple y no tiene deuda técnica.

---

## Recomendación 5 — Evaluar `sp_rpt_menu_redirigidos` cuando crezca el volumen

**Tipo:** monitoreo diferido  
**Prioridad:** baja — condicional al crecimiento del volumen  

Este SP tiene 2 subconsultas correlacionadas con denominadores distintos. La
equivalencia semántica es compleja porque cada subconsulta usa un alcance
diferente. El patrón correcto para eliminarlo sería 2 CTEs (como FASE 2), no
window functions.

En el ejemplo tiene ~50 filas de resultado. En producción puede alcanzar
200-1,000 filas según el número de combinaciones `menu × centro × segmento`
activas. Si la respuesta del SP se vuelve lenta, ese es el momento de aplicar
el patrón de FASE 2 — no antes.

---

## Recomendación 6 — Mantener el gate de la suite de tests para `ivr_contar` e `ivr_agregar`

**Tipo:** proceso de calidad  
**Prioridad:** alta si se modifican las funciones de calendario  

Las funciones de calendario v3.0.0 tienen una suite de 217 casos (112 + 105)
derivada del WHILE como fuente de verdad. Si en el futuro se detecta un caso
borde incorrecto y se corrige la fórmula, la suite debe ejecutarse antes de
desplegar. El patrón `SUM(SUM(col)) OVER (PARTITION BY ...)` y el `DENSE_RANK`
en `sp_rpt_centros_xsegmento` dependen de estas funciones siendo correctas.

---

## Recomendación 7 — Vigilar el crecimiento de centros distintos en producción

**Tipo:** monitoreo de escala  
**Prioridad:** media — relevante cuando se conecte la fuente real  

El análisis de escala mostró que con 300 centros por segmento, las funciones
de calendario se invocan 8,100 veces por ejecución del SP (con fórmula O(1)).
Sin la fórmula O(1) serían 248,400 iteraciones de WHILE — inaceptable.

La pregunta que hay que responder cuando lleguen los datos reales:

```sql
SELECT segmento, COUNT(DISTINCT centro_transferencia) AS centros_distintos
FROM base_ivr_detalle
WHERE trimestre = 'Q01_25'
  AND centro_transferencia NOT IN ('CASO_NULL','CASO_ERROR_CEROS','ERROR_CARACTER_INICIAL','CLIENTE_COLGO')
GROUP BY segmento;
```

Si el resultado está en el rango de 50-200 centros por segmento, el SP es
completamente viable. Si supera 500, conviene revisar si algún VDN está
fragmentando innecesariamente (por ejemplo, variantes del mismo número con
formatos distintos que la función de normalización no unifica).

---

## Hallazgo transversal — el cuello de botella no era el obvio

Los análisis revelaron que el cuello de botella real del sistema no era donde
parecía. La secuencia lógica de dependencias es:

```
FASE 4 (O(1) en funciones de calendario)
  ↓ prerequisito para
sp_rpt_centros_xsegmento siendo viable a escala de producción
  ↓ habilitó
DENSE_RANK (Módulo 13) siendo una adición de costo casi nulo
  ↓ porque
el CTE ya reduce la entrada de la window function de miles de filas a N_centros filas
```

Sin FASE 4, agregar `DENSE_RANK` al SP solo habría añadido una columna a un SP
ya lento. La corrección de la fórmula de las funciones de calendario fue el
cambio de mayor impacto en escenarios de producción con muchos centros.

---

## Cuadro de prioridades

| Recomendación | Prioridad | Esfuerzo | Impacto |
|---|---|---|---|
| R1: Window aggregate en `sp_rpt_cMENU_ERROR` y `sp_rpt_menu_centro` | Media | Bajo | Rendimiento menor + uniformidad de estilo |
| R2: No tocar `sp_rpt_llamadas_abandonadas` | — | — | Preserva KPI correcto |
| R3: Vista `v_etl_rendimiento` con `LAG()` | Media | Bajo | Monitoreo operacional del ETL |
| R4: No refactorizar `sp_rpt_clientes` | — | — | 3 filas fijas: sin justificación |
| R5: Evaluar `sp_rpt_menu_redirigidos` cuando crezca el volumen | Baja | Medio | Solo si aparece lentitud |
| R6: Mantener suite de tests de funciones de calendario | Alta | Ninguno | Regresiones silenciosas en fórmulas O(1) |
| R7: Consultar centros distintos con datos reales | Media | Ninguno | Validar supuesto de escala |

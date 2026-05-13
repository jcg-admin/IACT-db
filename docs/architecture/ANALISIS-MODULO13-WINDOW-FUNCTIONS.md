# Análisis — Módulo 13: Window Functions aplicadas a IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Fuente:** Módulo 13 — "Uso de funciones de clasificación de ventanas, desplazamiento y agregado"  
**Motor:** MariaDB 10.11 (window functions disponibles desde MariaDB 10.2.0)

---

## Disponibilidad en MariaDB 10.11

Todas las funciones del módulo están disponibles — verificadas en el motor real:

| Función | Categoría | Disponible | Verificada |
|---|---|---|---|
| `SUM/MIN/MAX OVER (PARTITION BY ...)` | Agregado | Sí | Sí |
| `ROW_NUMBER() OVER (...)` | Clasificación | Sí | Sí |
| `RANK() OVER (...)` | Clasificación | Sí | Sí |
| `DENSE_RANK() OVER (...)` | Clasificación | Sí | Sí |
| `NTILE(n) OVER (...)` | Clasificación | Sí | Sí |
| `PERCENT_RANK() OVER (...)` | Distribución | Sí | Sí |
| `CUME_DIST() OVER (...)` | Distribución | Sí | Sí |
| `LAG(col, n) OVER (...)` | Desplazamiento | Sí | Sí |
| `LEAD(col, n) OVER (...)` | Desplazamiento | Sí | Sí |
| `FIRST_VALUE() OVER (...)` | Desplazamiento | Sí | — |
| `LAST_VALUE() OVER (...)` | Desplazamiento | Sí | — |
| `ROWS BETWEEN ... AND ...` | Marco | Sí | — |

---

## Principio crítico antes de evaluar aplicabilidad

El módulo enseña que las window functions operan sobre "una ventana o conjunto de
filas". En la práctica, esto significa que **la window function agrega únicamente
sobre las filas visibles tras el `WHERE` de la consulta exterior**, mientras que una
subconsulta correlacionada puede tener su propio `WHERE` con un alcance diferente.

Esto hace que window functions y subconsultas correlacionadas sean semánticamente
equivalentes **solo cuando ambas condiciones de filtro son idénticas**.

Ejemplo verificado en MariaDB 10.11 — mismo resultado (equivalentes):
```sql
-- Subconsulta correlacionada:
/ NULLIF((SELECT SUM(b2.total_llamadas) FROM base_ivr_detalle b2
          WHERE b2.trimestre = p_quarter AND b2.segmento = b.segmento), 0)

-- Window function equivalente:
/ NULLIF(SUM(SUM(b.total_llamadas)) OVER (PARTITION BY b.segmento), 0)
-- (solo equivalente si el WHERE exterior usa el mismo filtro de segmento)
```

---

## Análisis SP por SP

### SPs ya optimizados en FASE 2 — no requieren cambios

`sp_rpt_centros_xsegmento` y `sp_rpt_centros_transferencia` ya eliminaron sus
subconsultas correlacionadas en FASE 2 usando CTEs y JOINs pre-agregados.
El patrón `SUM(SUM(col)) OVER (PARTITION BY ...)` habría producido el mismo resultado,
pero los CTEs son igualmente correctos y ya están desplegados.

### SPs restantes — análisis de equivalencia semántica

| SP | Subconsultas | Veredicto | Patrón window equivalente |
|---|---|---|---|
| `sp_rpt_cMENU_ERROR` | 1 — `WHERE` idéntico al exterior | Equivalente | `SUM(SUM(total_llamadas)) OVER (PARTITION BY segmento)` |
| `sp_rpt_menu_centro` | 1 — correlaciona por `centro_transferencia` | Equivalente | `SUM(SUM(total_llamadas)) OVER (PARTITION BY centro_transferencia)` |
| `sp_rpt_llamadas_abandonadas` | 2 — `WHERE` compatible con el exterior | Equivalente | `SUM(SUM(total_llamadas)) OVER (PARTITION BY segmento)` |
| `sp_rpt_clientes` | 1 — subq usa total global (sin partición) | Requiere `OVER ()` | `SUM(SUM(clientes_unicos)) OVER ()` sin PARTITION BY |
| `sp_rpt_menu_redirigidos` | 2 — denominadores con alcances distintos | Complejo | Requiere análisis por denominador; no es reemplazo directo |

**Verificación de equivalencia en MariaDB para los casos válidos:**

```
sp_rpt_cMENU_ERROR — nacional_A, cliente_colgo:
  pct_subquery = 22.79 | pct_window = 22.79  ← idénticos

sp_rpt_menu_centro — nacional_A, CLIENTE_COLGO:
  pct_subquery = 45.55 | pct_window = 45.55  ← idénticos
```

---

## Oportunidades concretas

### 1. Agregar `RANK()` a `sp_rpt_centros_xsegmento`

El módulo describe `RANK()` como la función que "devuelve la posición de cada fila
dentro de la partición". En `sp_rpt_centros_xsegmento`, añadir una columna de
ranking por volumen dentro de cada segmento tiene valor operacional: permite
identificar los centros más activos de un vistazo, sin ordenación adicional
en el cliente.

```sql
-- En el SELECT final del SP (sobre centros_calendario):
, RANK() OVER (
    PARTITION BY cc.segmento
    ORDER BY cc.total_llamadas DESC
  ) AS rango_en_segmento
```

Resultado verificado en MariaDB 10.11:
```
nacional_A  10728487  5493  rango=1
nacional_A  19020086  5084  rango=2
nacional_A  10828091  4803  rango=3
```

Esta adición es no destructiva — no cambia ninguna columna existente.

### 2. `LAG()` para monitoreo operacional del ETL en `job_execution_log`

El módulo describe `LAG()` como función para "comparaciones entre filas sin la
necesidad de una unión automática". `job_execution_log` acumula el historial de
ejecuciones del ETL. Una consulta con `LAG()` detecta regresiones de rendimiento
sin hacer un self-join:

```sql
SELECT
    job_name
    , quarter_name
    , step_name
    , status
    , start_time
    , TIMESTAMPDIFF(SECOND, start_time, end_time) AS duracion_seg
    , LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
        OVER (PARTITION BY job_name, step_name ORDER BY start_time)
        AS duracion_anterior_seg
    , TIMESTAMPDIFF(SECOND, start_time, end_time)
      - LAG(TIMESTAMPDIFF(SECOND, start_time, end_time))
          OVER (PARTITION BY job_name, step_name ORDER BY start_time)
        AS delta_seg
FROM job_execution_log
WHERE status = 'SUCCESS'
ORDER BY start_time DESC;
```

Esta consulta es operacional (no parte de un SP de negocio) — puede ejecutarse
directamente para diagnóstico. Verificada en el motor real con datos de `etl_diario`.

### 3. Window aggregate como alternativa a subconsultas en SPs de bajo impacto

Para `sp_rpt_cMENU_ERROR`, `sp_rpt_menu_centro` y `sp_rpt_llamadas_abandonadas`,
las subconsultas correlacionadas son semánticamente equivalentes a window aggregates.
El patrón `SUM(SUM(col)) OVER (PARTITION BY ...)` elimina la subconsulta y es
más idiomático.

Sin embargo, dado que la cardinalidad de estos SPs es baja (3-150 filas), el
impacto en rendimiento es menor. La refactorización es un candidato opcional
si se desea uniformidad de estilo con los SPs ya optimizados en FASE 2.

---

## Funciones del módulo sin aplicación directa en IACT-db

**`ROWS BETWEEN ... AND ...` (marcos):** Las ventanas de marco son útiles para
running totals y promedios móviles. En IACT-db los SPs de reporte no tienen
cálculos acumulativos — cada reporte es un snapshot de un quarter específico.

**`NTILE(n)`:** Divide filas en n cuartiles. Útil para análisis estadístico de
distribución de centros. No hay requisito actual que lo justifique.

**`PERCENT_RANK()` / `CUME_DIST()`:** Para análisis de distribución estadística.
No hay requisito actual en los SPs de reporte.

**`FIRST_VALUE()` / `LAST_VALUE()`:** Para obtener el primer o último valor
dentro de un marco. No hay un caso de uso directo en los SPs actuales.

---

## Resumen de aplicabilidad

| Función | Aplica | Tipo de aplicación | SP objetivo |
|---|---|---|---|
| `RANK() OVER (PARTITION BY ...)` | Sí — oportunidad nueva | Columna de ranking por volumen | `sp_rpt_centros_xsegmento` |
| `LAG() OVER (PARTITION BY ...)` | Sí — monitoreo operacional | Detección de regresiones ETL | `job_execution_log` (consulta ad-hoc) |
| `SUM() OVER (PARTITION BY ...)` | Sí — equivalente a subconsultas | Reemplazo de subconsultas correlacionadas | 3 SPs de bajo impacto (opcional) |
| `ROWS BETWEEN`, `NTILE`, distribución | No — sin caso de uso | — | — |

**Acción prioritaria:** `RANK()` en `sp_rpt_centros_xsegmento` — añade valor
informacional sin romper ninguna columna existente y requiere una sola línea.

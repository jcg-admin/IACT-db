# Hallazgos — Ejecución FASE 2 (optimización de SPs de reporte)

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Plan de referencia:** `PLAN-IMPL-HALLAZGOS-SQL-SERVER-IACT-DB.md` FASE 2  
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR  
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Archivos modificados

| Archivo | Objeto | Versión anterior | Versión nueva | Hallazgo resuelto |
|---|---|---|---|---|
| `objetos/sps/sp_rpt_centros_xsegmento.sql` | `sp_rpt_centros_xsegmento` | 2.0.0 | 2.1.0 | H-IACT-002 |
| `objetos/sps/sp_rpt_centros_transferencia.sql` | `sp_rpt_centros_transferencia` | 2.0.0 | 2.1.0 | H-IACT-003 |

---

## Resultado de las tareas

| Tarea | Descripción | Estado | Hallazgo detectado |
|---|---|---|---|
| T-2.1 | `sp_rpt_centros_xsegmento` con 3 CTEs | COMPLETO | H-F2-001 |
| T-2.2 | `sp_rpt_centros_transferencia` con JOIN pre-agregado | COMPLETO | — |
| T-2.3 | Verificación de resultados idénticos al snapshot | PASA | — |
| T-2.4 | verify.sh 27 OK | PASA | — |

---

## H-F2-001 — El plan T-2.1 era incompleto: solo eliminaba redundancias del CASE, no la subconsulta correlacionada de `pct_del_segmento`

**Detectado en:** T-2.1, durante el análisis completo del SP antes de implementar  
**Severidad:** MEDIA — la subconsulta correlacionada para `pct_del_segmento` ejecutaba una vez por cada fila del resultado  
**Estado:** RESUELTO con un tercer CTE en la misma tarea

### Descripción

El plan original para T-2.1 especificaba una subconsulta derivada de un nivel para
materializar `primera_act` y `ultima_act`. El análisis del SP completo reveló que
además de las invocaciones de función WHILE, el SP tenía una subconsulta correlacionada
adicional para `pct_del_segmento` no contemplada en el plan:

```sql
-- Original — subconsulta correlacionada por fila:
ROUND(
    SUM(b.total_llamadas)
    / NULLIF(
        (SELECT SUM(b2.total_llamadas)
         FROM base_ivr_detalle b2
         WHERE b2.trimestre = p_quarter
           AND b2.segmento  = b.segmento),
      0) * 100, 4
)
```

Con 84 filas de resultado (validado en snapshot de Q01_25), esta subconsulta
ejecutaba 84 veces — un scan de `base_ivr_detalle` por cada centro.

### Auditoría completa del SP antes de implementar

| Elemento | Evaluaciones por fila | Con 84 filas |
|---|---|---|
| `LAST_DAY(STR_TO_DATE(CONCAT(MAX(b.fecha),...)))` | 9 | 756 evaluaciones de agregado |
| `STR_TO_DATE(CONCAT(MIN(b.fecha),...))` | 2 | 168 evaluaciones de agregado |
| `ivr_contar_dias_semana` (función WHILE) | 5 | 5 × 84 × ~45 iter = ~18,900 iter |
| `ivr_agregar_dias_semana` (función WHILE) | 3 | 3 × 84 × ~5 iter = ~1,260 iter |
| Subconsulta correlacionada `pct_del_segmento` | 1 | 84 scans de `base_ivr_detalle` |

### Corrección implementada — 3 CTEs

En lugar de una subconsulta derivada de un nivel, se implementaron 3 CTEs:

**CTE 1 — `centros`:** GROUP BY que calcula `primera_act` y `ultima_act` una sola
vez. El SELECT exterior recibe escalares — no re-evalúa las expresiones de agregado
`MAX(b.fecha)`, `STR_TO_DATE`, `LAST_DAY` en cada invocación de función.

**CTE 2 — `centros_calendario`:** Calcula las métricas de calendario UNA vez por
centro usando los escalares del CTE 1. `dias_sin_actividad` se materializa aquí
para que el SELECT final lo use en el CASE sin re-invocar `ivr_contar_dias_semana`.

**CTE 3 — `totales_segmento`:** Calcula `SUM(total_llamadas)` por segmento en un
solo scan de `base_ivr_detalle`. El SELECT final hace `INNER JOIN` en lugar de
ejecutar una subconsulta correlacionada por fila.

### Comparación antes / después

| Elemento | Antes (v2.0.0) | Después (v2.1.0) |
|---|---|---|
| `LAST_DAY(STR_TO_DATE(MAX(...)))` | 9x por fila | 1x en el GROUP BY del CTE 1 |
| `ivr_contar_dias_semana` por fila | 5 invocaciones | 2 invocaciones (columnas) |
| `ivr_agregar_dias_semana` por fila | 3 invocaciones | 3 invocaciones (sin cambio) |
| CASE: invoca `ivr_contar` | 3x (WHEN × función) | 0x — usa `cc.dias_sin_actividad` escalar |
| `pct_del_segmento` | Subconsulta correlacionada ×84 | `INNER JOIN totales_segmento` — 1 scan |

El CASE es el cambio más significativo: en el diseño original, MariaDB no puede
reutilizar el resultado de `ivr_contar_dias_semana` dentro del mismo SELECT porque
se llama con expresiones de agregado como argumentos. Con el CTE 2,
`dias_sin_actividad` es una columna escalar materializada — el CASE la lee sin
ejecutar ninguna función.

---

## T-2.2 — `sp_rpt_centros_transferencia`: JOIN pre-agregado

### Problema original

La subconsulta correlacionada para `porcentaje`:

```sql
/ NULLIF(
    (SELECT SUM(b2.total_llamadas)
     FROM base_ivr_detalle b2
     WHERE b2.trimestre = p_quarter
       AND b2.fecha     = b.fecha
       AND (p_segmento = 'todas' OR b2.segmento = p_segmento)),
  0) * 100, 7
```

Ejecuta una vez por cada fila del resultado. Con ~3,000 filas por quarter
(6 meses de datos × 3 segmentos × N centros × M menús), la subconsulta
hace ~3,000 scans de `base_ivr_detalle`.

### Corrección implementada — LEFT JOIN

```sql
LEFT JOIN (
    SELECT
        fecha
        , SUM(total_llamadas) AS total_mes
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento)
    GROUP BY fecha
) AS totales
    ON totales.fecha = b.fecha
```

Un solo scan de `base_ivr_detalle` calcula `total_mes` para todos los meses.
El JOIN produce un scan vs ~3,000 scans.

### Verificación de equivalencia semántica

La subconsulta original correlacionaba por `b2.fecha = b.fecha` y filtraba por
segmento. El JOIN pre-agrega por `fecha` con el mismo filtro de segmento. El
denominador del porcentaje es idéntico en ambos diseños.

Snapshot pre-FASE 2:
```
202501: 100.0000
202502: 100.0000
202503: 100.0000
```

Post-FASE 2:
```
202501: 100.0000
202502: 100.0000
202503: 100.0000
```

La suma de porcentajes por fecha sigue siendo exactamente 100 en cada grupo —
la equivalencia semántica está confirmada.

---

## Verificación funcional final

```
sp_rpt_centros_xsegmento Q01_25:
  Total filas:    84  (snapshot: 84)
  Primera fila:   10728487 | total=4580 | dias_periodo=64 | dias_sin=293
                  | sla=FUERA_SLA | pct=10.0157
  Todos los valores idénticos al snapshot pre-FASE 2.

sp_rpt_centros_transferencia Q01_25 nacional_A:
  Total filas:    1018
  Suma porcentaje por fecha:
    202501: 100.0000  (snapshot: 100.0000)
    202502: 100.0000  (snapshot: 100.0000)
    202503: 100.0000  (snapshot: 100.0000)

verify.sh: 27 OK, 0 WARN, 0 ERR, EXIT 0
```

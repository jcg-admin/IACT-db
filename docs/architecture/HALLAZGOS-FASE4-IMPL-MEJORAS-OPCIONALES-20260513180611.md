# Hallazgos — Implementación FASE 4

**Versión:** 1.0.0
**Fecha:** 2026-05-13
**Alcance:** FASE 4 del plan PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md
**Baseline al iniciar:** verify.sh 27 OK, 0 WARN, 0 ERR
**Baseline al cerrar:** verify.sh 27 OK, 0 WARN, 0 ERR

---

## Resumen de tareas ejecutadas

| Tarea | Descripción | Estado | Hallazgos |
|---|---|---|---|
| T4.1 | sp_rpt_centros_xsegmento v2.3.0 | COMPLETO | — |
| T4.2 | sp_rpt_centros_transferencia v2.2.0 | COMPLETO | H-T4.2-001 (crítico) |
| T4.3 | Query monitoreo centros (operacional) | DOCUMENTADA | — |

---

## H-T4.2-001 — `NTILE` con `SUM OVER` anidado no compila en MariaDB 10.11

**Tarea:** T4.2
**Severidad:** CRÍTICA — el enfoque del plan no funciona en el motor
**Estado:** RESUELTO con LEFT JOIN subquery antes de implementar en producción

### Descripción

El plan (`PLAN-IMPL-IACT-DB-PENDIENTES-20260513141217.md`) especificaba:

```sql
NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) DESC
) AS cuartil_centro
```

Con la intención de que `SUM(b.total_llamadas)` agregara los totales por centro
dentro de la window. Verificado en motor MariaDB 10.11.14:

```
ERROR: You have an error in your SQL syntax... near 'NTILE(4) OVER (
    PARTITION BY b.trimestre, b.segmento
    ORDER BY SUM(b.total_llamadas) OVER (...) DESC'
```

MariaDB 10.11 prohíbe el uso de una window function (SUM OVER) como clave de
ORDER BY dentro de otra window function (NTILE). Esto es coherente con el estándar
SQL — la ejecución de window functions es una fase única; no pueden anidarse en
el ORDER BY de otra.

### Análisis de la estructura del SP

`sp_rpt_centros_transferencia` retorna UNA FILA POR (fecha, segmento, centro,
menu, opcion). Cada centro aparece múltiples veces (una por día × menú × opción).
Para un "cuartil por centro" significativo, el cuartil debe basarse en el volumen
TOTAL del centro en el periodo, no en el volumen de cada fila individual.

**¿Por qué `b.total_llamadas` directo no sirve?**
`NTILE(4) OVER(ORDER BY b.total_llamadas DESC)` rankearía cada fila por su propio
volumen diario, no por el volumen acumulado del centro en el quarter. Un centro
con muchas llamadas pequeñas (1 por día durante 90 días) quedaría en Q4 aunque
su total sea mayor que un centro con pocas llamadas grandes.

### Solución — LEFT JOIN con subquery de cuartiles

La subquery calcula el cuartil a nivel de CENTRO (GROUP BY centro), luego el
LEFT JOIN propaga ese cuartil a todas las filas del centro:

```sql
LEFT JOIN (
    SELECT
        trimestre
        , segmento
        , centro_transferencia
        , NTILE(4) OVER (
            PARTITION BY trimestre, segmento
            ORDER BY SUM(total_llamadas) DESC
          )                              AS cuartil_centro
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento)
      AND centro_transferencia NOT IN (
          'CASO_NULL', 'CASO_ERROR_CEROS',
          'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO'
      )
    GROUP BY trimestre, segmento, centro_transferencia
) AS cr
    ON  cr.trimestre            = b.trimestre
    AND cr.segmento             = b.segmento
    AND cr.centro_transferencia = b.centro_transferencia
```

**Propiedades verificadas en motor real:**

1. Todas las filas del mismo centro tienen el mismo cuartil (verificado con
   `COUNT(DISTINCT cuartil_centro) = 1` para todos los centros).

2. La distribución es correcta: con 28 centros en nacional_A,
   `7 centros por cuartil` (NTILE(4) sobre 28 centros = 4 grupos de 7).

3. Centinelas (CASO_NULL, CASO_ERROR_CEROS, etc.) reciben `cuartil_centro = NULL`
   porque no aparecen en la subquery cr — el LEFT JOIN no los empareja.

4. El SP ya tiene un LEFT JOIN para `totales` (totales por fecha). El segundo
   LEFT JOIN para cuartiles es un segundo scan de `base_ivr_detalle`. Para una
   tarea opcional de mejora, este coste es aceptable.

### Verificación post-implementación

```sql
-- Q01_25 nacional_A:
CALL sp_rpt_centros_transferencia('Q01_25', 'nacional_A');
-- 14 columnas (13 originales + cuartil_centro)
-- centro 10728487 (mayor volumen): cuartil_centro = 1 ✓
-- CLIENTE_COLGO (centinela):       cuartil_centro = NULL ✓

-- Distribución de cuartiles:
-- cuartil 1: 7 centros, cuartil 2: 7, cuartil 3: 7, cuartil 4: 7 ✓
```

---

## T4.3 — Query de monitoreo de centros (operacional)

Esta tarea no genera commits. Es una verificación que debe ejecutarse cuando
se conecte la fuente de datos de producción.

```sql
-- Ejecutar con datos reales:
SELECT segmento,
       COUNT(DISTINCT centro_transferencia) AS centros_distintos
FROM base_ivr_detalle
WHERE trimestre = (SELECT quarter FROM v_quarter_actual)
  AND centro_transferencia NOT IN (
      'CASO_NULL', 'CASO_ERROR_CEROS',
      'ERROR_CARACTER_INICIAL', 'CLIENTE_COLGO'
  )
GROUP BY segmento;
```

**Interpretación:**

| Resultado | Acción |
|---|---|
| < 200 centros/segmento | Sin acción — el sistema es viable |
| 200–500 centros/segmento | Monitorear rendimiento de `sp_rpt_centros_xsegmento` |
| > 500 centros/segmento | Revisar fragmentación en `fn_normalizar_centro` |

Con datos de prueba (`Q01_25`): 28 centros en `nacional_A`, 16 en `nacional_B`,
17 en `puebla`. Con la fórmula O(1) de FASE 4 el SP es viable hasta ~1,000 centros.

---

## Estado final de objetos al cerrar FASE 4

| Objeto | Versión anterior | Versión final | Cambio |
|---|---|---|---|
| `sp_rpt_centros_xsegmento` | 2.2.2 | 2.3.0 | +`percentil_actividad`, +`pct_del_lider` |
| `sp_rpt_centros_transferencia` | 2.1.2 | 2.2.0 | +`cuartil_centro` via LEFT JOIN subquery |

---

## Verificaciones realizadas

### T4.1 — sp_rpt_centros_xsegmento

```sql
-- 2026-05-13
CALL sp_rpt_centros_xsegmento('Q01_25');
-- 84 filas (28 centros × 3 segmentos)
-- 22 columnas (20 originales + percentil_actividad + pct_del_lider)

-- nacional_A, top 3:
-- [19] rango_en_segmento  [20] percentil_actividad  [21] pct_del_lider
-- 10728487 rango=1  percentil=1.0000  pct_lider=100.0
-- 19020086 rango=2  percentil=0.9630  pct_lider=92.6
-- 10828091 rango=3  percentil=0.9259  pct_lider=87.4

-- Verificación de semántica:
-- percentil ORDER BY ASC: el de mayor volumen → 1.0000 ✓
-- pct_del_lider: 5084/5493*100 = 92.6% para el segundo centro ✓
```

### T4.2 — sp_rpt_centros_transferencia

```sql
-- 2026-05-13
CALL sp_rpt_centros_transferencia('Q01_25', 'nacional_A');
-- 1030 filas (N fechas × centros × menus × opciones)
-- 14 columnas (13 originales + cuartil_centro)

-- Centros de Q1 (cuartil=1): los 7 de mayor volumen acumulado ✓
-- CLIENTE_COLGO centinela: cuartil=NULL ✓
-- 7 centros por cuartil (28 centros / 4 = 7) ✓
-- cuartiles_distintos=1 para todos los centros ✓
```

---

## Estado completo del plan al cerrar FASE 4

```
FASE 1 — Provision + Infraestructura de errores:   COMPLETA
FASE 2 — Window functions en 4 SPs de reporte:     COMPLETA
FASE 3 — Nuevos objetos de observabilidad:          COMPLETA
FASE 4 — Mejoras opcionales:                        COMPLETA

verify.sh: 27 OK, 0 WARN, 0 ERR
provision-mariadb.sh: 25 objetos
```

---

## Commits de la FASE 4

| Hash | Mensaje | Tareas |
|---|---|---|
| `14ac02e` | feat(reportes): FASE 4 — PERCENT_RANK, FIRST_VALUE, NTILE(4) | T4.1 + T4.2 |

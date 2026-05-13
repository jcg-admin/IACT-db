# Análisis — Módulo 11: Expresiones de Tabla aplicadas a IACT-db

**Versión:** 1.0.0  
**Fecha:** 2026-05-13  
**Fuente:** Módulo 11 — "Uso de expresiones de tabla" (Vistas, TVF, Tablas Derivadas, CTEs)  
**Motor:** MariaDB 10.11 (no SQL Server — impacta la aplicabilidad)

---

## Marco de comparación

El módulo cubre cuatro expresiones de tabla en T-SQL (SQL Server):
vistas, funciones de valor de tabla en línea (TVF), tablas derivadas y CTEs.
Antes de evaluar su aplicabilidad a IACT-db hay que determinar cuáles están
disponibles en MariaDB 10.11 y cuáles ya se usan en el proyecto.

---

## Tabla de aplicabilidad por expresión

| Expresión | Disponible en MariaDB 10.11 | Estado en IACT-db | Decisión |
|---|---|---|---|
| Vistas (`CREATE VIEW`) | Sí | No se usan actualmente | Oportunidad menor — evaluada abajo |
| TVF en línea (`CREATE FUNCTION ... RETURNS TABLE`) | **No** — MariaDB no tiene TVF | No aplica | Descartada |
| Tablas derivadas (`FROM (SELECT ...) AS alias`) | Sí | Implementadas en FASE 2 (`sp_rpt_centros_transferencia`) | Ya en uso |
| CTEs (`WITH ... AS (SELECT ...)`) | Sí — desde MariaDB 10.2.1 | Implementadas en FASE 2 (`sp_rpt_centros_xsegmento`) | Ya en uso |

---

## Lo que ya está implementado

### Tablas derivadas — `sp_rpt_centros_transferencia` v2.1.0

El patrón del módulo (página 11-12) fue aplicado exactamente en FASE 2 (T-2.2).
La subconsulta correlacionada para `porcentaje` fue reemplazada por un
`LEFT JOIN` con una subconsulta derivada pre-agregada:

```sql
-- Patrón del módulo: tabla derivada en la cláusula FROM
LEFT JOIN (
    SELECT fecha, SUM(total_llamadas) AS total_mes
    FROM base_ivr_detalle
    WHERE trimestre = p_quarter
      AND (p_segmento = 'todas' OR segmento = p_segmento)
    GROUP BY fecha
) AS totales ON totales.fecha = b.fecha
```

Resultado: un solo scan de `base_ivr_detalle` en lugar de ~3,000 scans correlacionados.

### CTEs — `sp_rpt_centros_xsegmento` v2.1.0

El patrón del módulo (páginas 17-18) fue aplicado en FASE 2 (T-2.1) con 3 CTEs
encadenados. El módulo describe que los CTEs "soportan múltiples definiciones y
referencias múltiples" — exactamente lo que necesitábamos para materializar
`primera_act`, `ultima_act` y `dias_sin_actividad` una sola vez por centro:

```sql
WITH centros AS (           -- CTE 1: GROUP BY una sola vez
    SELECT ..., primera_act, ultima_act
    FROM base_ivr_detalle GROUP BY ...
),
centros_calendario AS (     -- CTE 2: funciones WHILE sobre escalares
    SELECT *, ivr_contar_dias_semana(...) AS dias_sin_actividad
    FROM centros
),
totales_segmento AS (       -- CTE 3: elimina subconsulta correlacionada
    SELECT segmento, SUM(total_llamadas) AS total_seg
    FROM base_ivr_detalle GROUP BY segmento
)
SELECT ..., CASE WHEN cc.dias_sin_actividad = 0 THEN 'ACTIVO_HOY' ...
FROM centros_calendario cc
INNER JOIN totales_segmento ts ON ts.segmento = cc.segmento;
```

---

## TVF en línea — no aplica a MariaDB

El módulo (páginas 7-9) explica las TVF como "vistas parametrizadas" que
devuelven una tabla virtual. SQL Server tiene dos tipos: inline (basada en
un solo SELECT) y multi-statement (que crea y carga una variable de tabla).

**MariaDB no tiene TVF.** Sus funciones almacenadas siempre retornan escalares.
Lo más cercano en MariaDB es un SP con `SELECT` que devuelve un result set,
pero no puede usarse en la cláusula `FROM` de otra consulta.

Este punto ya estaba documentado en el análisis comparativo inicial:
"Multi-statement TVF vs inline TVF → No aplica — MariaDB no tiene TVF."

---

## Vistas — oportunidad existente pero con alcance limitado

El módulo define las vistas como "expresiones de tabla con definiciones
almacenadas" que simplifican y encapsulan. En IACT-db no se usan vistas.

### ¿Aportarían valor?

**Limitación principal:** las vistas no aceptan parámetros. Todos los SPs de reporte
reciben `p_quarter` (y algunos `p_segmento`) como parámetros de entrada. Una vista
no puede filtrar `WHERE trimestre = p_quarter` — ese filtro debe estar en el SP llamador.

**Caso evaluado:** una vista que pre-agregara `base_ivr_detalle` por `trimestre × segmento`
podría simplificar los SPs de reporte. Pero generaría un scan completo de la tabla en cada
invocación — sin la restricción de `trimestre`, el costo sería mayor que el de la subconsulta
correlacionada original.

**Conclusión:** las vistas no aportan valor en los SPs de reporte actuales porque su utilidad
depende de agregar sin parámetros. Los 5 SPs que aún tienen subconsultas correlacionadas
tienen cardinalidades bajas (3-150 filas) — su costo real es bajo y no justifica el overhead
de una vista.

---

## SPs restantes con subconsultas correlacionadas

Los 5 SPs no modificados en FASE 2 siguen teniendo subconsultas correlacionadas.
El módulo confirma el patrón correcto para eliminarlas (tablas derivadas o CTEs).

| SP | Subconsultas correlacionadas | Filas resultado | Impacto | Acción |
|---|---|---|---|---|
| `sp_rpt_clientes` | 1 (`c2.trimestre = p_quarter`) | 3 | MUY BAJO | No justifica cambio |
| `sp_rpt_llamadas_abandonadas` | 1 (`b3.segmento = b.segmento`) | ~9 | MUY BAJO | No justifica cambio |
| `sp_rpt_cMENU_ERROR` | 1 (sin correlación fuerte) | ~20 | BAJO | No justifica cambio |
| `sp_rpt_menu_redirigidos` | 2 (`b2.menu = b.menu`, totales) | ~50 | BAJO | Candidato opcional |
| `sp_rpt_menu_centro` | 1 (`b2.centro = b.centro`) | ~150 | BAJO | Candidato opcional |

**Los dos SPs con mayor cardinalidad** son candidatos opcionales si el volumen de datos
crece significativamente. La corrección seguiría el mismo patrón que T-2.2:
reemplazar la subconsulta por un `LEFT JOIN` con tabla derivada pre-agregada.

---

## Resumen de aplicabilidad

| Expresión del módulo | Aplica | Implementada | Pendiente |
|---|---|---|---|
| Vistas | Parcialmente | No — alcance limitado sin parámetros | Ninguna acción requerida |
| TVF en línea | No — MariaDB no las tiene | — | No aplica |
| Tablas derivadas | Sí | FASE 2 (`sp_rpt_centros_transferencia`) | Opcional en 2 SPs de bajo impacto |
| CTEs | Sí | FASE 2 (`sp_rpt_centros_xsegmento`) | Opcional en 2 SPs de bajo impacto |

**No hay acción obligatoria.** Las correcciones de mayor impacto (FASE 2) ya se implementaron
usando exactamente los patrones que el módulo enseña. Los SPs restantes tienen
cardinalidades bajas que no justifican refactoring en el volumen actual de datos.
